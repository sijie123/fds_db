/* Consolidation of base tables for all user types */

CREATE TABLE Users (
    username        VARCHAR(50),
    password        VARCHAR(50),
    token           VARCHAR(50),
    creationDate    DATE DEFAULT CURRENT_DATE,
    PRIMARY KEY (username)
);

CREATE TABLE Customers (
    username        VARCHAR(50),
    rewardPoints    INTEGER DEFAULT 0,
    cardNumber      CHAR(16),
    PRIMARY KEY (username),
    FOREIGN KEY (username) REFERENCES Users ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Managers (
    username    VARCHAR(50),
    PRIMARY KEY (username),
    FOREIGN KEY (username) REFERENCES Users ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Staff (
    username        VARCHAR(50),
    restaurantName  VARCHAR(50) NOT NULL,
    PRIMARY KEY (username),
    FOREIGN KEY (username) REFERENCES Users ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Riders (
    username    VARCHAR(50),
    latitude    NUMERIC NOT NULL,
    longitude   NUMERIC NOT NULL,
    orderid     INTEGER,
    PRIMARY KEY (username),
    FOREIGN KEY (username) REFERENCES Users ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE OR REPLACE FUNCTION userTypeEnforcement()
returns TRIGGER as $$ 
declare
    ok  BOOLEAN;
begin
    IF TG_TABLE_NAME = 'customers' THEN
        SELECT true INTO ok
        FROM Managers NATURAL JOIN Staff NATURAL JOIN Riders
        WHERE username = NEW.username;
    ELSIF TG_TABLE_NAME = 'managers' THEN
        SELECT true INTO ok
        FROM Customers NATURAL JOIN Staff NATURAL JOIN Riders
        WHERE username = NEW.username;
    ELSIF TG_TABLE_NAME = 'staff' THEN
        SELECT true INTO ok
        FROM Customers NATURAL JOIN Managers NATURAL JOIN Riders
        WHERE username = NEW.username;
    ELSE -- riders
        SELECT true INTO ok
        FROM Customers NATURAL JOIN Staff NATURAL JOIN Managers
        WHERE username = NEW.username;
    END IF;

    IF FOUND THEN
        RAISE EXCEPTION 'User % has an existing user type', NEW.username;
    END IF;
    
    RETURN NEW;
end 
$$ language plpgsql;

CREATE TRIGGER userTypeEnforcement_trigger
    BEFORE INSERT OR UPDATE OF username
    ON Customers
    FOR EACH ROW
    EXECUTE PROCEDURE userTypeEnforcement();

CREATE TRIGGER userTypeEnforcement_trigger
    BEFORE INSERT OR UPDATE OF username
    ON Managers
    FOR EACH ROW
    EXECUTE PROCEDURE userTypeEnforcement();

CREATE TRIGGER userTypeEnforcement_trigger
    BEFORE INSERT OR UPDATE OF username
    ON Riders
    FOR EACH ROW
    EXECUTE PROCEDURE userTypeEnforcement();

CREATE TRIGGER userTypeEnforcement_trigger
    BEFORE INSERT OR UPDATE OF username
    ON Staff
    FOR EACH ROW
    EXECUTE PROCEDURE userTypeEnforcement();