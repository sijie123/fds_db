-- Statistics Functions

-- ###############
-- ## FDS    #####
-- ###############

CREATE OR REPLACE FUNCTION newCustomersMonthlyCount()
returns Table (
    year    INTEGER,
    month   INTEGER,
    count   INTEGER) as $$
begin
    RETURN QUERY 
        WITH CustomersCreationDate as (
            SELECT  U.username as username, DATE_PART('YEAR', U.creationdate)::INTEGER as year, DATE_PART('MONTH', U.creationdate)::INTEGER as month
            FROM    Users as U inner join Customers as C on (U.username = C.username))
        SELECT      CCD.year, CCD.month, count(CCD.username)::INTEGER
        FROM        CustomersCreationDate as CCD
        GROUP BY    (CCD.year, CCD.month)
        ORDER BY    CCD.year DESC, CCD.month DESC;
end 
$$ language plpgsql;

CREATE OR REPLACE FUNCTION parseOrdersDate()
returns Table (
    id              INTEGER,
    restaurantName  VARCHAR(50),
    customerName    VARCHAR(50),
    riderName       VARCHAR(50),
    year            INTEGER,
    month           INTEGER,
    creation        TIMESTAMP,
    departure       TIMESTAMP,
    arrival         TIMESTAMP,
    collection      TIMESTAMP,
    delivery        TIMESTAMP,
    totalCost       MONEY,
    deliveryFee     MONEY) as $$
begin
    RETURN QUERY
        SELECT  
            O.id, 
            O.restaurantName,
            O.customerName,
            O.riderName,
            DATE_PART('YEAR', O.creation)::INTEGER as year, 
            DATE_PART('MONTH', O.creation)::INTEGER as month,
            O.creation,
            O.departure,
            O.arrival,
            O.collection,
            O.delivery,
            O.totalCost,
            O.deliveryFee
        FROM Orders O;
end
$$ language plpgsql;

CREATE OR REPLACE FUNCTION ordersStatsMonthly()
returns Table (
    year    INTEGER,
    month   INTEGER,
    count   INTEGER,
    sum     MONEY) as $$
begin
    RETURN QUERY 
        SELECT
            OD.year,
            OD.month,
            count(OD.id)::INTEGER,
            sum(OD.totalCost + OD.deliveryFee)
        FROM        parseOrdersDate() as OD
        GROUP BY    (OD.year, OD.month)
        ORDER BY    OD.year DESC, OD.month DESC;
end 
$$ language plpgsql;

CREATE OR REPLACE FUNCTION customersOrdersStatsMonthly()
returns Table (
    year            INTEGER,
    month           INTEGER,
    customerName    VARCHAR(50),
    count           INTEGER,
    sum             MONEY) as $$
begin
    RETURN QUERY 
        SELECT      
            OD.year,
            OD.month, 
            OD.customerName,
            count(OD.id)::INTEGER,
            sum(OD.totalCost + OD.deliveryFee)
        FROM        parseOrdersDate() as OD
        GROUP BY    (OD.year, OD.month, OD.customerName)
        ORDER BY    OD.year DESC, OD.month DESC, OD.customerName ASC;
end 
$$ language plpgsql;

CREATE OR REPLACE FUNCTION ridersOrdersStatsMonthly()
returns Table (
    year            INTEGER,
    month           INTEGER,
    riderName       VARCHAR(50),
    countOrders     INTEGER,
    sumInterval     INTERVAL,
    avgInterval     INTERVAL,
    sumRating       INTEGER,
    avgRating       INTEGER,
    salary          MONEY) as $$
begin
    RETURN QUERY 
        (SELECT      
            OD.year as year,
            OD.month as month, 
            OD.riderName as riderName,
            count(OD.delivery)::INTEGER,
            sum(age(OD.delivery, OD.departure)),
            sum(age(OD.delivery, OD.departure))/count(OD.delivery),
            count(DR.rating)::INTEGER,
            sum(DR.rating)::INTEGER/count(DR.rating)::INTEGER,
            CASE
                WHEN EXISTS(
                    SELECT  1 
                    FROM    PartTimeRiders
                    WHERE   username = OD.riderName) THEN (
                        SELECT  weeksalary
                        FROM    PartTimeRiders
                        WHERE   username = OD.riderName
                        ) * 4 + 1::MONEY * count(OD.delivery)
                ELSE (
                    SELECT  monthsalary
                    FROM    FullTimeRiders
                    WHERE   username = OD.riderName
                    ) + 1::MONEY * count(OD.delivery)
            END as salary
        FROM        parseOrdersDate() as OD, DeliveryRatings as DR
        WHERE       OD.delivery IS NOT NULL AND DR.orderId = OD.id
        GROUP BY    (OD.year, OD.month, OD.riderName))
        UNION
        (SELECT      
            OD.year as year,
            OD.month as month, 
            R.username as riderName,
            NULL::INTEGER,
            NULL::INTERVAL,
            NULL::INTERVAL,
            NULL::INTEGER,
            NULL::INTEGER,
            CASE
                WHEN EXISTS(
                    SELECT  1 
                    FROM    PartTimeRiders
                    WHERE   username = R.username) THEN (
                        SELECT  weeksalary
                        FROM    PartTimeRiders PTR
                        WHERE   PTR.username = R.username
                        ) * 4
                ELSE (
                    SELECT  monthsalary
                    FROM    FullTimeRiders FTR
                    WHERE   FTR.username = R.username
                    )
            END as salary
        FROM        parseOrdersDate() as OD, Riders as R
        WHERE       NOT EXISTS (
            SELECT  1
            FROM    parseOrdersDate() as OD2
            WHERE   OD2.year = OD.year AND OD2.month = OD.month AND OD2.riderName = R.username)
        GROUP BY    (OD.year, OD.month, R.username))
        ORDER BY    year DESC, month DESC, riderName ASC;
end 
$$ language plpgsql;

-- ###############
-- ## Restaurant #
-- ###############

CREATE OR REPLACE FUNCTION singleRestaurantOrdersStatsMonthly(VARCHAR(50))
returns Table (
    year            INTEGER,
    month           INTEGER,
    countOrders     INTEGER,
    sumOrdersCost   MONEY) as $$
begin
    RETURN QUERY 
        SELECT
            OD.year as year,
            OD.month as month, 
            count(OD.id)::INTEGER,
            sum(OD.totalCost)
        FROM        parseOrdersDate() as OD
        WHERE       OD.restaurantName = $1
        GROUP BY    (OD.year, OD.month)
        ORDER BY    year DESC, month DESC;        
end
$$ language plpgsql;

CREATE OR REPLACE FUNCTION singleRestaurantFoodOrdersStatsMonthly(VARCHAR(50))
returns Table (
    year            INTEGER,
    month           INTEGER,
    foodName        VARCHAR(50),
    totalqty        INTEGER) as $$
begin
    RETURN QUERY
        WITH RestaurantFoodMonthly AS (
            SELECT
                OD.year as year,
                OD.month as month, 
                FO.foodName as foodName,
                sum(FO.quantity)::INTEGER as totalqty
            FROM        parseOrdersDate() as OD LEFT JOIN FoodOrders as FO on (OD.id = FO.orderId)
            WHERE       OD.restaurantName = $1
            GROUP BY    (OD.year, OD.month, FO.foodName))
        SELECT  
            helper_query.year as year,
            helper_query.month as month,
            helper_query.foodName as foodName,
            helper_query.totalqty as totalqty
        FROM        (
            SELECT
                RFM.*,
                rank() OVER (
                    PARTITION BY    (RFM.year, RFM.month)
                    ORDER BY        RFM.totalqty DESC
                )
            FROM RestaurantFoodMonthly as RFM) as helper_query
        WHERE       RANK <= 5
        ORDER BY    year DESC, month DESC, totalqty DESC;
end
$$ language plpgsql;

CREATE OR REPLACE FUNCTION singleRestaurantPromotionsStats(VARCHAR(50))
returns Table (
    promoid         INTEGER,
    code            VARCHAR(10),
    runtime         INTERVAL,
    usecount        INTEGER
    ) as $$
begin
    RETURN QUERY 
        SELECT
            CP.id,
            CP.code,
            age(CP.enddate, CP.startdate),
            CP.usecount
        FROM        RestaurantPromotions as RP INNER JOIN CodePromotions as CP on (RP.id = CP.id)
        WHERE       RP.rname = $1
        ORDER BY    CP.startdate DESC;        
end
$$ language plpgsql;

-- ###############
-- ## Riders #####
-- ###############

CREATE OR REPLACE FUNCTION singleRiderOrdersStatsMonthly(VARCHAR(50))
returns Table (
    year            INTEGER,
    month           INTEGER,
    riderName       VARCHAR(50),
    countOrders     INTEGER,
    sumInterval     INTERVAL,
    avgInterval     INTERVAL,
    sumRating       INTEGER,
    avgRating       INTEGER,
    salary          MONEY) as $$
begin
    RETURN QUERY 
        SELECT      *
        FROM        ridersOrdersStatsMonthly() as ROSM
        WHERE       ROSM.riderName = $1
        ORDER BY    ROSM.year DESC, ROSM.month DESC, ROSM.riderName ASC;
end 
$$ language plpgsql;