CREATE TABLE DeliveryRatings (
    orderId         INTEGER,
    riderName       VARCHAR(50) NOT NULL,
    customerName    VARCHAR(50) NOT NULL,
    rating          INTEGER CHECK (rating <= 5),
    PRIMARY KEY (orderId),
    FOREIGN KEY (orderId) REFERENCES Orders(id),
    FOREIGN KEY (riderName) REFERENCES Riders(username),
    FOREIGN KEY (customerName) REFERENCES Customers(username)
);