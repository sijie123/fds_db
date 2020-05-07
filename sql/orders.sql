CREATE TYPE PAYMENT_METHOD AS ENUM ('CARD', 'CASH');

CREATE TABLE Orders (
    id                  INTEGER GENERATED ALWAYS AS IDENTITY,
    deliveryLocation    VARCHAR(100) NOT NULL,
    totalCost           MONEY NOT NULL,
    deliveryFee         MONEY DEFAULT 2, -- flat rate of $2
    paymentMethod       PAYMENT_METHOD NOT NULL,
    promocode           VARCHAR(10) NOT NULL DEFAULT '', -- Will NOT be foreign key-ed into CodePromotions for simplicity. Just don't change promo codes in CodePromotions :/

    creation        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,  -- date and time order was created
    departure       TIMESTAMP   -- date and time rider departed for restaurant
                    CHECK (departure IS NULL OR departure >= creation),
    arrival         TIMESTAMP   -- date and time rider arrived at restaurant
                    CHECK (arrival IS NULL OR (departure IS NOT NULL AND arrival >= departure)),
    collection      TIMESTAMP   -- date and time rider collected from restaurant
                    CHECK (collection IS NULL OR (arrival IS NOT NULL AND collection >= arrival)),
    delivery        TIMESTAMP   -- date and time food was delivered
                    CHECK (delivery IS NULL OR (collection IS NOT NULL AND delivery >= collection)),

    restaurantName      VARCHAR(50) NOT NULL,
    customerName        VARCHAR(50) NOT NULL,
    riderName           VARCHAR(50) NOT NULL, -- NOTE: order can only be made after rider is found

    PRIMARY KEY (id),
    FOREIGN KEY (restaurantName) REFERENCES Restaurants(name),
    CONSTRAINT foodorder_key UNIQUE (id, restaurantName),
    FOREIGN KEY (customerName) REFERENCES Customers(username),
    FOREIGN KEY (riderName) REFERENCES Riders(username)
);

ALTER TABLE Riders
ADD FOREIGN KEY (orderid) REFERENCES Orders(id);

-- When an order is added, we verify the order satisfies the minimum order
CREATE OR REPLACE FUNCTION verify_minimum()
returns TRIGGER AS $$
declare
    restaurantMinOrder  MONEY := (
        SELECT  R.minOrder
        FROM    Restaurants R
        WHERE   R.name = NEW.restaurantName);
begin
    IF NEW.totalCost < restaurantMinOrder THEN
        RAISE EXCEPTION 'Order does not meet the minimum order! (% < %)', NEW.totalCost, restaurantMinOrder;
    END IF;
    return NEW;
end
$$ language plpgsql;

CREATE TRIGGER verify_minimum_trigger
    BEFORE INSERT
    ON Orders
    FOR EACH ROW
    EXECUTE PROCEDURE verify_minimum();

-- When an order is added, we update the assigned rider's current order to this one
CREATE OR REPLACE FUNCTION assign_order_to_rider() RETURNS trigger AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM Riders WHERE username = NEW.riderName AND orderid IS NULL
    )
    THEN
        RAISE EXCEPTION 'Selected rider % is already busy with order %',
        NEW.riderName, ( SELECT orderid FROM Riders WHERE username = NEW.riderName );
    END IF;

    UPDATE Riders
    SET orderid = NEW.id
    WHERE username = NEW.riderName;
    return NEW;
end
$$ language plpgsql;

CREATE TRIGGER assign_order_to_rider_trigger
    AFTER INSERT
    ON Orders
    FOR EACH ROW
    EXECUTE PROCEDURE assign_order_to_rider();

-- DEPRECATED, SEE updateRewardPoints()
-- When an order is added, we add reward points for the customer
--CREATE OR REPLACE FUNCTION add_points()
--returns TRIGGER AS $$
--begin
--    UPDATE  Customers
--    SET     rewardPoints = rewardPoints + NEW.totalCost::NUMERIC::FLOAT::INTEGER
--    WHERE   username = NEW.customerName;
--    return NEW;
--end
--$$ language plpgsql;

-- DEPRECATED
--CREATE TRIGGER add_points_trigger
--    AFTER INSERT
--    ON Orders
--    FOR EACH ROW
--    EXECUTE PROCEDURE add_points();

CREATE OR REPLACE FUNCTION addOrderBonus()
returns TRIGGER as $$
declare
    ok      BOOLEAN;
    bonus   MONEY := 1;
begin
    SELECT true INTO ok FROM PartTimeRiders WHERE username = NEW.riderName;
    IF FOUND THEN
        -- part time rider
        UPDATE PartTimeRiders
        SET weeksalary = weeksalary + bonus
        WHERE username = NEW.riderName;
    ELSE
        -- full time rider
        UPDATE FullTimeRiders
        SET monthsalary = monthsalary + bonus
        WHERE username = NEW.riderName;
    END IF;
    RETURN NULL;
end
$$ language plpgsql;

CREATE TRIGGER addOrderBonus_trigger
    AFTER UPDATE OF delivery
    ON Orders
    FOR EACH ROW
    EXECUTE PROCEDURE addOrderBonus();