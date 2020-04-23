CREATE TABLE Locations (
    name        VARCHAR(100) NOT NULL,
    latitude    NUMERIC NOT NULL,
    longitude   NUMERIC NOT NULL,
    PRIMARY KEY (name)
);

ALTER TABLE Restaurants
ADD FOREIGN KEY (location) REFERENCES Locations(name);

ALTER TABLE Orders
ADD FOREIGN KEY (deliveryLocation) REFERENCES Locations(name);