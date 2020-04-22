CREATE TABLE Food (
    name            VARCHAR(50),
    restaurantName  VARCHAR(50),
    price           MONEY NOT NULL,
    maxQty          INTEGER NOT NULL   -- max qty sellable
                    CHECK (maxQty >= 0),
    currQty         INTEGER DEFAULT 0,  -- current qty sold
                    CHECK (currQty >= 0 AND currQty <= maxQty),
    PRIMARY KEY (restaurantName, name),
    FOREIGN KEY (restaurantName) REFERENCES Restaurants(name) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE OR REPLACE FUNCTION refresh_qty()
returns VOID as $$
begin
    UPDATE  Food
    SET     currQty = maxQty;
end
$$ language plpgsql;