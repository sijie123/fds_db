-- ###############
-- #### Rider ####
-- ###############  

-- Note that assumes correct timezone (rn now() gives me +00)
CREATE OR REPLACE FUNCTION findAvailable(TIMESTAMPTZ)
returns Table (
    username    VARCHAR(50),
    latitude    NUMERIC,
    longitude   NUMERIC) as $$ 
declare
    day     INTEGER := 0;
    shift   INTEGER := 0;
    ts      TIMESTAMP := $1::TIMESTAMP;
begin
    -- Parse the timestamp
    day     := EXTRACT(ISODOW FROM ts)::INTEGER;
    shift   := EXTRACT(HOUR FROM ts)::INTEGER;
    IF (shift < 10 OR shift > 22) THEN
        RAISE EXCEPTION 'FDS closed at %', ts;
    ELSE
        shift := shift - 9; -- 10:00 is index 1
    END IF;
    -- Return all available riders
    RETURN  QUERY 
        SELECT  R.username, R.latitude, R.longitude
        FROM    PartTimeRiders PTR, Riders R
        WHERE   (PTR.ws[day][shift]) AND (PTR.username = R.username) AND (R.orderid IS NULL)
        UNION
        SELECT  R.username, R.latitude, R.longitude
        FROM    FullTimeRiders FTR, Riders R
        WHERE   (FTR.ws[day][shift]) AND (FTR.username = R.username) AND (R.orderid IS NULL);
end 
$$ language plpgsql;

-- $1:          restaurant name
-- $2:          current time, with timezone
-- ret:         username of closest available rider
CREATE OR REPLACE FUNCTION findNearestAvailableRider(VARCHAR(100), TIMESTAMPTZ)
returns VARCHAR(50) as $$ 
declare
    chosenone   VARCHAR(50);
begin
    chosenone := (
        SELECT  AR.username
        FROM    findAvailable($2) as AR, Locations as L
        WHERE   L.name = (
            SELECT  R.location
            FROM    Restaurants R
            WHERE   R.name = $1
            )
        AND ((AR.latitude - L.latitude) ^ 2 + (AR.longitude - L.longitude) ^ 2) <= ALL (
            SELECT ((AR2.latitude - L.latitude) ^ 2 + (AR2.longitude - L.longitude) ^ 2)
            FROM findAvailable($2) as AR2
            )
    );

    IF chosenone IS NULL THEN
        RAISE EXCEPTION 'No riders available!';
    END IF;

    return chosenone;
end 
$$ language plpgsql;

-- Update departure time of the order (by the rider)
CREATE OR REPLACE FUNCTION riderDeparture(
    riderName   VARCHAR(50),
    currenttime TIMESTAMP DEFAULT CURRENT_TIMESTAMP)
returns TIMESTAMP as $$
declare
    oid INTEGER := (SELECT orderid FROM Riders WHERE username = riderName);
begin
    IF oid IS NULL THEN
        RAISE EXCEPTION 'Rider % does not have an order', riderName;
    END IF;

    UPDATE  Orders
    SET     departure = currenttime
    WHERE   id = oid;
    RETURN currenttime;
end
$$ language plpgsql;

-- Update departure time of the order (by the rider)
CREATE OR REPLACE FUNCTION riderDeparture(
    riderName   VARCHAR(50),
    currenttime TIMESTAMP DEFAULT CURRENT_TIMESTAMP)
returns TIMESTAMP as $$
declare
    oid INTEGER := (SELECT orderid FROM Riders WHERE username = riderName);
begin
    IF oid IS NULL THEN
        RAISE EXCEPTION 'Rider % does not have an order', riderName;
    END IF;

    UPDATE  Orders
    SET     departure = currenttime
    WHERE   id = oid;
    RETURN currenttime;
end
$$ language plpgsql;

-- Update arrival time of the order (by the rider)
CREATE OR REPLACE FUNCTION riderArrival(
    riderName   VARCHAR(50),
    currenttime TIMESTAMP DEFAULT CURRENT_TIMESTAMP)
returns TIMESTAMP as $$
declare
    oid INTEGER := (SELECT orderid FROM Riders WHERE username = riderName);
begin
    IF oid IS NULL THEN
        RAISE EXCEPTION 'Rider % does not have an order', riderName;
    END IF;

    UPDATE  Orders
    SET     arrival = currenttime
    WHERE   id = oid;
    RETURN currenttime;
end
$$ language plpgsql;

-- Update collection time of the order (by the rider)
CREATE OR REPLACE FUNCTION riderCollection(
    riderName   VARCHAR(50),
    currenttime TIMESTAMP DEFAULT CURRENT_TIMESTAMP)
returns TIMESTAMP as $$
declare
    oid INTEGER := (SELECT orderid FROM Riders WHERE username = riderName);
begin
    IF oid IS NULL THEN
        RAISE EXCEPTION 'Rider % does not have an order', riderName;
    END IF;

    UPDATE  Orders
    SET     collection = currenttime
    WHERE   id = oid;
    RETURN currenttime;
end
$$ language plpgsql;

-- Update delivery time of the order (by the rider)
CREATE OR REPLACE FUNCTION riderDelivery(
    riderName   VARCHAR(50),
    currenttime TIMESTAMP DEFAULT CURRENT_TIMESTAMP)
returns TIMESTAMP as $$
declare
    oid INTEGER := (SELECT orderid FROM Riders WHERE username = riderName);
begin
    IF oid IS NULL THEN
        RAISE EXCEPTION 'Rider % does not have an order', riderName;
    END IF;

    UPDATE  Riders
    SET     orderid = NULL
    WHERE   orderid = oid;

    UPDATE  Orders
    SET     delivery = currenttime
    WHERE   id = oid;

    RETURN currenttime;
end
$$ language plpgsql;

-- Resets all part-time riders week salary
CREATE OR REPLACE FUNCTION resetPartimeRidersSalary()
returns VOID as $$
begin
    UPDATE  PartTimeRiders 
    SET     weeksalary = 0;
end
$$ language plpgsql;

-- Resets all full-time riders week salary
CREATE OR REPLACE FUNCTION resetFullimeRidersSalary()
returns VOID as $$
begin
    UPDATE  FullTimeRiders 
    SET     monthsalary = 0;
end
$$ language plpgsql;

-- Dev function to set all riders as available for delivery
CREATE OR REPLACE FUNCTION _freeRiders()
returns VOID as $$
begin
    UPDATE  Riders 
    SET     orderid = NULL;
end
$$ language plpgsql;

-- ###############
-- #### FOOD  ####
-- ###############

CREATE OR REPLACE FUNCTION refresh_qty()
returns VOID as $$
begin
    UPDATE  Food
    SET     currQty = maxQty;
end
$$ language plpgsql;
