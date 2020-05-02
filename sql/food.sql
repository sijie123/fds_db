CREATE TABLE Food (
    name            VARCHAR(50),
    restaurantName  VARCHAR(50),
    price           MONEY NOT NULL,
    maxQty          INTEGER NOT NULL   -- max qty sellable
                    CHECK (maxQty >= 0),
    currQty         INTEGER DEFAULT 0  -- current qty sold
                    CHECK (currQty BETWEEN 0 AND maxQty),
    PRIMARY KEY (restaurantName, name),
    FOREIGN KEY (restaurantName) REFERENCES Restaurants ON DELETE CASCADE ON UPDATE CASCADE
);
