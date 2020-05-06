-- ###############
-- ## Customer ###
-- ###############

CREATE OR REPLACE FUNCTION getRecentLocations(cname VARCHAR(50))
returns Table (
    deliveryLocation    VARCHAR(100),
    latitude    NUMERIC,
    longitude   NUMERIC) AS $$
begin
    RETURN QUERY (
        SELECT
            O.deliveryLocation,
            L.latitude,
            L.longitude
        FROM        Orders O INNER JOIN Locations L ON (O.deliveryLocation = L.name)
        WHERE       O.customerName = cname
        ORDER BY    O.creation DESC
        LIMIT       5);
end
$$ language plpgsql;

CREATE OR REPLACE FUNCTION useRewardPoints(cname VARCHAR(50), orderid INTEGER)
RETURNS VOID AS $$
declare
    totalcost_int   INTEGER := (
        SELECT  totalCost
        FROM    Orders
        WHERE   id = orderid
    )::NUMERIC::FLOAT::INTEGER;
    cur_rewardPoints    INTEGER := (
        SELECT  rewardPoints
        FROM    Customers
        WHERE   username = cname
    );
    RATE            INTEGER := 20;
    rebate_int      INTEGER := CASE
        WHEN (totalcost_int < (cur_rewardPoints / RATE)) THEN
            totalcost_int
        ELSE
            (cur_rewardPoints / RATE)
        END;
begin
    UPDATE  Orders
    SET     totalCost = totalCost - rebate_int::MONEY
    WHERE   id = orderid;

    UPDATE  Customers
    SET     rewardPoints = rewardPoints - (rebate_int * RATE)
    WHERE   username = cname;
end
$$ language plpgsql;

-- Adds reward points for the customer based on the order's total cost
CREATE OR REPLACE FUNCTION updateRewardPoints(cname VARCHAR(50), orderid INTEGER)
RETURNS VOID AS $$
declare
    totalcost_int   INTEGER := (
        SELECT  totalCost
        FROM    Orders
        WHERE   id = orderid
    )::NUMERIC::FLOAT::INTEGER;
begin
    UPDATE  Customers
    SET     rewardPoints = rewardPoints + totalcost_int
    WHERE   username = cname;
end
$$ language plpgsql;

-- ###############
-- #### Rider ####
-- ###############

CREATE OR REPLACE FUNCTION getOrderInfo(riderName VARCHAR(50))
returns Table(
    deliveryLocation    VARCHAR(100),
    totalCost           MONEY,
    paymentMethod       PAYMENT_METHOD,
    creation            TIMESTAMP,
    departure           TIMESTAMP,
    arrival             TIMESTAMP,
    collection          TIMESTAMP,
    delivery            TIMESTAMP,
    restaurantName      VARCHAR(50),
    customerName        VARCHAR(50)
    ) as $$
declare
    orderid INTEGER := (
        SELECT  orderid
        FROM    Riders R
        WHERE   R.username = riderName);
begin
    IF orderid IS NULL THEN
        RAISE EXCEPTION 'Rider % does not have an order!', riderName;
    ELSE
        RETURN QUERY (
            SELECT
                O.deliveryLocation,
                O.totalCost,
                O.paymentMethod,
                O.creation,
                O.departure,
                O.arrival,
                O.collection,
                O.delivery,
                O.restaurantName,
                O.customerName
            FROM    Orders O
            WHERE   O.id = orderid
            LIMIT   1);
    END IF;
end
$$ language plpgsql;


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

-- Check what is the status of the current rider w.r.t the order
CREATE OR REPLACE FUNCTION riderStatus(
    riderName VARCHAR(50)
) returns VARCHAR(20) AS $$
DECLARE
    oid INTEGER := (SELECT orderid FROM Riders WHERE username = riderName);
    departure TIMESTAMP := (SELECT departure FROM Orders WHERE id = oid);
    arrival TIMESTAMP := (SELECT arrival FROM Orders WHERE id = oid);
    collection TIMESTAMP := (SELECT collection FROM Orders WHERE id = oid);
    delivery TIMESTAMP := (SELECT delivery FROM Orders WHERE id = oid);
BEGIN
    IF oid IS NULL THEN
        RETURN 'none';
    END IF;

    IF departure IS NULL THEN
        RETURN 'departure';
    ELSIF arrival IS NULL THEN
        RETURN 'arrival';
    ELSIF collection IS NULL THEN
        RETURN 'collection';
    ELSIF delivery IS NULL THEN
        RETURN 'delivery';
    ELSE
        RAISE EXCEPTION 'Rider % has already delivered order', riderName;
    END IF;
END
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
declare
    rider   RECORD;
begin
    FOR rider in SELECT * FROM PartTimeRiders LOOP
        UPDATE  PartTimeRiders
        SET     weeksalary = calculateBaseSalary(username)
        WHERE   username = rider.username;
    END LOOP;
end
$$ language plpgsql;

-- Resets all full-time riders week salary
CREATE OR REPLACE FUNCTION resetFullimeRidersSalary()
returns VOID as $$
declare
    rider   RECORD;
begin
    FOR rider in SELECT * FROM FullTimeRiders LOOP
        UPDATE  FullTimeRiders
        SET     monthsalary = calculateBaseSalary(username) * 4
        WHERE   username = rider.username;
    END LOOP;
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

-- ###############
-- #### Promo  ###
-- ###############

CREATE OR REPLACE FUNCTION getAvailablePromotions()
returns Table (
    id          INTEGER,
    startDate   DATE,
    endDate     DATE,
    code        VARCHAR(10),
    description VARCHAR(100),
    rname       VARCHAR(50)) as $$
begin
    RETURN QUERY (
        SELECT  CP.id, CP.startDate, CP.endDate, CP.code, CP.description, RP.rname
        FROM    CodePromotions CP LEFT JOIN RestaurantPromotions RP on (CP.id = RP.id)
        WHERE
            CP.startDate <= CURRENT_TIMESTAMP AND
            (CP.endDate is NULL OR CURRENT_TIMESTAMP <= CP.endDate));
end
$$ language plpgsql;

CREATE OR REPLACE FUNCTION getDOW(INTEGER)
returns TEXT as $$
declare
    dow TEXT[7] := '{"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"}';
begin
    RETURN dow[$1];
end
$$ language plpgsql;
