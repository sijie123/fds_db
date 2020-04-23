CREATE TABLE Staff (
    username    VARCHAR(50),
    PRIMARY KEY (username),
    FOREIGN KEY (username) REFERENCES Users(username) ON DELETE CASCADE ON UPDATE CASCADE
);
