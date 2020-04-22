CREATE TABLE Restaurants (
    name        VARCHAR(50),
    location    VARCHAR(100) NOT NULL,
    minOrder    MONEY DEFAULT 0,
    PRIMARY KEY (name)
);

ALTER TABLE Staff 
ADD restaurantName  VARCHAR(50) NOT NULL, -- restaurant staff works at
ADD FOREIGN KEY (restaurantName) REFERENCES Restaurants(name);
