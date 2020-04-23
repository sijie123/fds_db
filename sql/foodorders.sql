CREATE TABLE FoodOrders (
    orderId         INTEGER,
    restaurantName  VARCHAR(50),
    foodName        VARCHAR(50),
    quantity        INTEGER DEFAULT 1,
    PRIMARY KEY (orderId, restaurantName, foodName),
    FOREIGN KEY (orderId, restaurantName) REFERENCES Orders(id, restaurantName),
    FOREIGN KEY (foodName, restaurantName) REFERENCES Food(name, restaurantName)
);

CREATE OR REPLACE FUNCTION decrease_qty() 
returns TRIGGER AS $$
begin
    UPDATE  Food
    SET     currQty = currQty - NEW.quantity -- Will automatically fail check in Food if not enough
    WHERE   restaurantName = NEW.restaurantName AND name = NEW.foodName;
    return NEW;
end
$$ language plpgsql;

CREATE TRIGGER decrease_qty_trigger
    BEFORE UPDATE OR INSERT
    ON FoodOrders
    FOR EACH ROW
    EXECUTE PROCEDURE decrease_qty();