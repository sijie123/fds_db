-- MANAGERS --
INSERT INTO Users (username, password) VALUES
('admin', 'admin');

INSERT INTO Managers(username) VALUES
('admin');

-- CUSTOMERS --
INSERT INTO Users (username, password, creationdate) VALUES
('oldbird', 'oldbirdpass', timestamptz '2020-03-15 12:34:56+08');

INSERT INTO Users (username, password) VALUES
('customer1', 'password'),
('customer2', 'password'),
('customer3', 'password'),
('customer4', 'password'),
('customer5', 'password'),
('customer6', 'password'),
('customer7', 'password'),
('customer8', 'password'),
('testuser', 'password');

INSERT INTO Customers(username, cardNumber) VALUES
('customer1', '1234567812345678'),
('customer2', '8765432187654321'),
('customer3', '1234567812345678'),
('customer4', '8765432187654321'),
('testuser', '0000111122223333');

INSERT INTO Customers(username) VALUES
('customer5'),
('customer6'),
('customer7'),
('customer8'),
('oldbird');

-- RIDERS --
INSERT INTO Users (username, password) VALUES
('rider1', 'password'),
('rider2', 'password'),
('rider3', 'password'),
('rider4', 'password'),
('rider5', 'password'),
('rider6', 'password'),
('rider7', 'password'),
('rider8', 'password'),
('rider9', 'password'),
('rider10', 'password'),
('ridera', 'password'),
('riderb', 'password'),
('riderc', 'password');

INSERT INTO Riders(username, latitude, longitude) VALUES
('rider1', 1.314982, 103.764652),    -- Clementi
('rider2', 1.332999, 103.742237),    -- Jurong
('rider3', 1.303842, 103.774817),    -- NUS University Town
('rider4', 1.293599, 103.784325),    -- KR MRT
('rider5', 1.295538, 103.780417),    -- MD1
('rider6', 1.293446, 103.773358),    -- KR Guild House
('rider7', 1.292738, 103.774227),    -- Mocthar Riady Building
('rider8', 1.298534, 103.773948),    -- Near YIH
('rider9', 1.294345, 103.770830),    -- Outside AS7
('rider10', 1.292804, 103.7743488),  -- NUS Hon Sui Sen Memorial Library
('ridera', 1.2911406, 103.776854),   -- NUS Institute of Systems Science
('riderb', 1.2910274, 103.7798208),  -- PGP Terminal
('riderc', 1.2917251, 103.7827324)   -- National University Health System
;

-- STAFF --
/* Added to restaurants in restaurantfooddata.sql */
INSERT INTO Users (username, password) VALUES
('arise_e4', 'password'),       -- Arise & Shine @ E4
('arise_s16', 'password'),      -- Arise & Shine @ S16
('atempo_yst', 'password'),     -- Atempo
('sheeple', 'password'),        -- Bar Bar Black Sheep
('cafeD', 'password'),          -- Cafe Delight
('centralSq', 'password'),      -- Central Square
('crave', 'password'),          -- Crave
('jewel coffee', 'password'),   -- Jewel Coffee
('liji', 'password'),           -- Li Ji Coffeehouse
('maxx', 'password'),           -- Maxx Coffee
('nami', 'password'),           -- Nami
('old ck', 'password'),         -- Old Chang Kee
('saladxpasta', 'password'),    -- Salad Express X Pasta Express
('reedz', 'password'),          -- Reedz Cafe
('garytheplatypus', 'password'),  -- Platypus Food Bar
('mala', 'password'),           -- Ma La Xiang Guo
('teaparty', 'password'),       -- The Tea Party
('betterpasta', 'password'),    -- Pasta Express
('salmon', 'password'),         -- Poke Theory
('uncle', 'password'),          -- Uncle Penyet
('bbt', 'password')             -- Gongcha
;