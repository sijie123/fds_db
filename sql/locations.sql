CREATE TABLE Locations (
    name        VARCHAR(100),
    latitude    NUMERIC NOT NULL,
    longitude   NUMERIC NOT NULL,
    PRIMARY KEY (name)
);

ALTER TABLE Restaurants
ADD FOREIGN KEY (location) REFERENCES Locations;

ALTER TABLE Orders
ADD FOREIGN KEY (deliveryLocation) REFERENCES Locations;