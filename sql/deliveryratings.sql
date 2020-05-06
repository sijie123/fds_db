CREATE TABLE DeliveryRatings (
    orderId         INTEGER,
    riderName       VARCHAR(50) NOT NULL,
    customerName    VARCHAR(50) NOT NULL,
    rating          INTEGER CHECK (rating <= 5) NOT NULL,
    PRIMARY KEY (orderId),
    FOREIGN KEY (orderId) REFERENCES Orders,
    FOREIGN KEY (riderName) REFERENCES Riders,
    FOREIGN KEY (customerName) REFERENCES Customers
);