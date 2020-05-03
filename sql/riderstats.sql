CREATE TABLE PartTimeRidersStats (
    riderName       VARCHAR(50),
    year            INTEGER
                    CHECK (year BETWEEN 2000 AND 2100),
    month           INTEGER
                    CHECK (month BETWEEN 1 AND 12),
    week            INTEGER
                    CHECK (month BETWEEN 1 AND 4),
    countOrders     INTEGER
                    CHECK (countOrders >= 0),
    sumInterval     INTERVAL,
    avgInterval     INTERVAL,
    sumRating       INTEGER,
    avgRating       FLOAT,
    salary          MONEY DEFAULT 0,
    PRIMARY KEY (riderName, year, month, week),
    FOREIGN KEY (riderName) REFERENCES Riders(username) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE FullTimeRidersStats (
    riderName       VARCHAR(50),
    year            INTEGER
                    CHECK (year BETWEEN 2000 AND 2100),
    month           INTEGER
                    CHECK (month BETWEEN 1 AND 12),
    countOrders     INTEGER
                    CHECK (countOrders >= 0),
    sumInterval     INTERVAL,
    avgInterval     INTERVAL,
    sumRating       INTEGER,
    avgRating       FLOAT,
    salary          MONEY DEFAULT 0,
    PRIMARY KEY (riderName, year, month),
    FOREIGN KEY (riderName) REFERENCES Riders(username) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Will insert into the PartTimeRidersStats
-- Uses CURRENT schedule to calculate the statistics (salary in particular)
-- If an update was already performed once, will throw a PRIMARY KEY constraint error 
CREATE OR REPLACE FUNCTION updatePartTimeRiderStats(
    updatetime  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)
returns VOID as $$
declare
    updateyear  INTEGER := DATE_PART('YEAR', updatetime)::INTEGER;
    updatemonth INTEGER := DATE_PART('MONTH', updatetime)::INTEGER;
    updateweek  INTEGER := (DATE_PART('DAY', updatetime)::INTEGER) / 7;
begin
    INSERT INTO PartTimeRidersStats(riderName, year, month, week, countOrders, sumInterval, avgInterval, sumRating, avgRating, salary)
        (SELECT
            OD.riderName as riderName,
            OD.year as year,
            OD.month as month, 
            OD.week as week,
            count(OD.delivery)::INTEGER as countOrders,
            sum(age(OD.delivery, OD.departure)) as sumInterval,
            sum(age(OD.delivery, OD.departure))/count(OD.delivery) as avgInterval,
            count(DR.rating)::INTEGER as sumRating,
            sum(DR.rating)::FLOAT/count(DR.rating)::FLOAT as avgRating,
            (SELECT weeksalary
            FROM    PartTimeRiders PTR
            WHERE   username = OD.riderName) as salary
        FROM        parseOrdersDate() as OD, DeliveryRatings as DR
        WHERE
            EXISTS (
                SELECT  1
                FROM    PartTimeRiders PTR
                WHERE   PTR.username = OD.riderName
            ) AND
            OD.year = updateyear AND
            OD.month = updatemonth AND
            OD.week = updateweek AND
            OD.delivery IS NOT NULL AND
            DR.orderId = OD.id
        GROUP BY    (OD.year, OD.month, OD.week, OD.riderName))
        UNION
        (SELECT      
            PTR.username as riderName,
            OD.year as year,
            OD.month as month, 
            OD.week as week,
            NULL::INTEGER as countOrders,
            NULL::INTERVAL as sumInterval,
            NULL::INTERVAL as avgInterval,
            NULL::INTEGER as sumRating,
            NULL::FLOAT as avgRating,
            (SELECT weeksalary
            FROM    PartTimeRiders
            WHERE   username = PTR.username) as salary
        FROM        parseOrdersDate() as OD, PartTimeRiders as PTR
        WHERE       
            OD.year = updateyear AND
            OD.month = updatemonth AND
            OD.week = updateweek AND
            NOT EXISTS (
                SELECT  1
                FROM    parseOrdersDate() as OD2
                WHERE   
                    OD2.year = OD.year AND
                    OD2.month = OD.month AND
                    OD2.week = OD.week AND
                    OD2.riderName = PTR.username)
        GROUP BY    (OD.year, OD.month, OD.week, PTR.username));
end
$$ language plpgsql;


-- Will insert into the FullTimeRidersStats
-- Uses CURRENT schedule to calculate the statistics (salary in particular)
-- If an update was already performed once, will throw a PRIMARY KEY constraint error 
CREATE OR REPLACE FUNCTION updateFullTimeRiderStats(
    updatetime  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)
returns VOID as $$
declare
    updateyear  INTEGER := DATE_PART('YEAR', updatetime)::INTEGER;
    updatemonth INTEGER := DATE_PART('MONTH', updatetime)::INTEGER;
begin
    INSERT INTO FullTimeRidersStats(riderName, year, month, countOrders, sumInterval, avgInterval, sumRating, avgRating, salary)
        (SELECT
            OD.riderName as riderName,
            OD.year as year,
            OD.month as month,
            count(OD.delivery)::INTEGER as countOrders,
            sum(age(OD.delivery, OD.departure)) as sumInterval,
            sum(age(OD.delivery, OD.departure))/count(OD.delivery) as avgInterval,
            count(DR.rating)::INTEGER as sumRating,
            sum(DR.rating)::FLOAT/count(DR.rating)::FLOAT as avgRating,
            (SELECT monthsalary
            FROM    FullTimeRiders FTR
            WHERE   username = OD.riderName) as salary
        FROM        parseOrdersDate() as OD, DeliveryRatings as DR
        WHERE
            EXISTS (
                SELECT  1
                FROM    FullTimeRiders FTR
                WHERE   FTR.username = OD.riderName
            ) AND
            OD.year = updateyear AND
            OD.month = updatemonth AND
            OD.delivery IS NOT NULL AND
            DR.orderId = OD.id
        GROUP BY    (OD.year, OD.month, OD.riderName))
        UNION
        (SELECT      
            FTR.username as riderName,
            OD.year as year,
            OD.month as month,
            NULL::INTEGER as countOrders,
            NULL::INTERVAL as sumInterval,
            NULL::INTERVAL as avgInterval,
            NULL::INTEGER as sumRating,
            NULL::FLOAT as avgRating,
            (SELECT monthsalary
            FROM    FullTimeRiders
            WHERE   username = FTR.username) as salary
        FROM        parseOrdersDate() as OD, FullTimeRiders as FTR
        WHERE       
            OD.year = updateyear AND
            OD.month = updatemonth AND
            NOT EXISTS (
                SELECT  1
                FROM    parseOrdersDate() as OD2
                WHERE   
                    OD2.year = OD.year AND
                    OD2.month = OD.month AND
                    OD2.riderName = FTR.username)
        GROUP BY    (OD.year, OD.month, OD.week, FTR.username));
end
$$ language plpgsql;

CREATE OR REPLACE FUNCTION ridersOrdersStatsMonthly()
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
        (SELECT     *
        FROM        FullTimeRidersStats FTRS
        GROUP BY    (FTRS.year, FTRS.month, FTRS.riderName))
        UNION
        (SELECT
            PTRS.riderName,
            PTRS.year,
            PTRS.month,
            sum(PTRS.countOrders)::INTEGER,
            sum(PTRS.sumInterval),
            sum(PTRS.sumInterval)/sum(PTRS.countOrders),
            sum(PTRS.sumRating)::INTEGER,
            sum(PTRS.sumRating)::FLOAT/sum(PTRS.countOrders)::FLOAT,
            sum(PTRS.salary)
        FROM        PartTimeRidersStats PTRS
        GROUP BY    (PTRS.year, PTRS.month, PTRS.riderName))
        ORDER BY    year DESC, month DESC, riderName ASC;
end 
$$ language plpgsql;
