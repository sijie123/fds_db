CREATE OR REPLACE FUNCTION parseOrdersDate()
returns Table (
    id              INTEGER,
    customerName    VARCHAR(50),
    riderName       VARCHAR(50),
    year            INTEGER,
    month           INTEGER,
    totalCost       MONEY,
    deliveryFee     MONEY,
    riderhours      INTERVAL) as $$
begin
    RETURN QUERY
        SELECT  
            O.id, 
            O.customerName,
            O.riderName,
            DATE_PART('YEAR', O.creation)::INTEGER as year, 
            DATE_PART('MONTH', O.creation)::INTEGER as month,
            O.totalCost,
            O.deliveryFee,
            CASE
                WHEN O.delivery IS NOT NULL THEN AGE(O.delivery, O.departure)
                ELSE NULL END AS riderhours
        FROM    Orders as O;
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
            count(OD.id)::INTEGER, -- Change OD.id to OD.completed if wanna count completed orders only
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
            count(OD.id)::INTEGER, -- Change OD.id to OD.completed if wanna count completed orders only
            sum(OD.totalCost + OD.deliveryFee)
        FROM        parseOrdersDate() as OD
        GROUP BY    (OD.year, OD.month, OD.customerName)
        ORDER BY    OD.year DESC, OD.month DESC, OD.customerName ASC;
end 
$$ language plpgsql;