CREATE TABLE FoodReviews (
    orderId         INTEGER,
    foodName        VARCHAR(50) NOT NULL,
    restaurantName  VARCHAR(50) NOT NULL,
    customerName    VARCHAR(50) NOT NULL,
    rating          INTEGER CHECK (rating <= 5) NOT NULL,
    content         TEXT,
    PRIMARY KEY (orderId, restaurantName, foodName),
    FOREIGN KEY (orderId) REFERENCES Orders(id),
    FOREIGN KEY (foodName, restaurantName) REFERENCES Food(name, restaurantName),
    FOREIGN KEY (customerName) REFERENCES Customers(username)
);
