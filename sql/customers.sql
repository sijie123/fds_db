CREATE TABLE Customers (
    username        VARCHAR(50),
    rewardPoints    INTEGER DEFAULT 0,
    cardNumber      CHAR(16),
    PRIMARY KEY (username),
    FOREIGN KEY (username) REFERENCES Users(username) ON DELETE CASCADE ON UPDATE CASCADE
);