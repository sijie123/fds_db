CREATE TABLE Customers (
    username        VARCHAR(50),
    rewardPoints    INTEGER DEFAULT 0,
    cardNumber      CHAR(16),
    PRIMARY KEY (username),
    FOREIGN KEY (username) REFERENCES Users(username) ON DELETE CASCADE ON UPDATE CASCADE
);

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