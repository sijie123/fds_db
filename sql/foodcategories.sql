CREATE TABLE FoodCategories (
    category        VARCHAR(50),
    foodName        VARCHAR(50),
    restaurantName  VARCHAR(50),
    PRIMARY KEY (restaurantName, foodName, category),
    FOREIGN KEY (restaurantName, foodName) REFERENCES Food(restaurantName, name) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (category) REFERENCES Categories(cname)
);
