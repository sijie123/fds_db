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
    week            INTEGER,
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
            CASE
                WHEN ((DATE_PART('DAY', O.creation)::INTEGER - 1) / 7) >= 4 THEN 4
                ELSE ((DATE_PART('DAY', O.creation)::INTEGER - 1) / 7) + 1 
            END as week,
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

-- Special case where we store statistics history, since past salary is determined by past work schedule, which may be different
\i riderstats.sql;

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
    riderName       VARCHAR(50),
    year            INTEGER,
    month           INTEGER,
    countOrders     INTEGER,
    sumInterval     INTERVAL,
    avgInterval     INTERVAL,
    sumRating       INTEGER,
    avgRating       FLOAT,
    salary          MONEY) as $$
begin
    RETURN QUERY
        SELECT      ROSM.riderName, ROSM.year, ROSM.month, ROSM.countOrders, ROSM.sumInterval, ROSM.avgInterval, ROSM.sumRating, ROSM.avgRating, ROSM.salary
        FROM        ridersOrdersStatsMonthly() as ROSM
        WHERE       ROSM.riderName = $1
        ORDER BY    ROSM.year DESC, ROSM.month DESC, ROSM.riderName ASC;
end
$$ language plpgsql;

-- ###############
-- ## Customers ##
-- ###############

CREATE OR REPLACE FUNCTION singleCustomerOrdersStatsMonthly(VARCHAR(50))
returns Table (
    year            INTEGER,
    month           INTEGER,
    customerName    VARCHAR(50),
    count           INTEGER,
    sum             MONEY) as $$
begin
    RETURN QUERY
        SELECT      *
        FROM        customersOrdersStatsMonthly() as COSM
        WHERE       COSM.customerName = $1
        ORDER BY    COSM.year DESC, COSM.month DESC, COSM.customerName ASC;
end
$$ language plpgsql;
