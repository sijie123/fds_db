/* Tests */

-- TEST CASES FOR PART-TIME --
INSERT INTO Users (username, password) VALUES
('A', 'A'),
('B', 'B'),
('C', 'C'),
('D', 'D'),
('E', 'E'),
('F', 'F'),
('G', 'G');
INSERT INTO Riders (username, latitude, longitude) VALUES
('A', 0, 0),
('B', 0, 0),
('C', 0, 0),
('D', 0, 0),
('E', 0, 0),
('F', 0, 0),
('G', 0, 0);
-- SUCCEED --
SELECT 'Inserting A: Succeed';
INSERT INTO PartTimeRiders (username, ws) VALUES
('A', ARRAY[
-----1  2  3  4  5  6  7  8  9  A  B  C
    [1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0], -- 4
    [0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1], -- 4
    [1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1], -- 5
    [0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], -- 1
    [0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1], -- 8
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], -- 1
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]::BOOLEAN[]);
-- FAIL --
SELECT 'Inserting B: Fail';
INSERT INTO PartTimeRiders (username, ws) VALUES
('B', ARRAY[
-----1  2  3  4  5  6  7  8  9  A  B  C
    [1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0], -- BAD
    [1, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 0],
    [1, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]::BOOLEAN[]);  
SELECT 'Inserting C: Fail';
INSERT INTO PartTimeRiders (username, ws) VALUES
('C', ARRAY[
-----1  2  3  4  5  6  7  8  9  A  B  C
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0],
    [0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0],
    [0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 1],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1]]::BOOLEAN[]); -- BAD
SELECT 'Inserting D: Fail';
INSERT INTO PartTimeRiders (username, ws) VALUES
('D', ARRAY[
-----1  2  3  4  5  6  7  8  9  A  B  C
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0], -- BAD
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 1, 1],
    [0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 1, 1]]::BOOLEAN[]);
SELECT 'Inserting E: Fail';
INSERT INTO PartTimeRiders (username, ws) VALUES
('E', ARRAY[
-----1  2  3  4  5  6  7  8  9  A  B  C
    [1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0],
    [1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0],
    [1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0],
    [1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0],
    [1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0],
    [1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0],
    [1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0]]::BOOLEAN[]);
SELECT 'Inserting F: Fail';
INSERT INTO PartTimeRiders (username, ws) VALUES
('F', ARRAY[
-----1  2  3  4  5  6  7  8  9  A  B  C
    [1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]::BOOLEAN[]);

-- TEST CASES FOR FULL TIME RIDERS --
-- SUCCEED --
SELECT 'Inserting A: Succeed';
INSERT INTO FullTimeRiders (username, ws) VALUES
('A', ARRAY[
-----1  2  3  4  5  6  7  8  9  A  B  C
    [1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0],
    [0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0],
    [0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0],
    [0, 0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1]]::BOOLEAN[]);
-- FAIL --
SELECT 'Inserting B: Fail';
INSERT INTO FullTimeRiders (username, ws) VALUES
('B', ARRAY[
-----1  2  3  4  5  6  7  8  9  A  B  C
    [1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0], -- BAD
    [0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0],
    [0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0],
    [0, 0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
    [0, 0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1]]::BOOLEAN[]);
SELECT 'Inserting C: Fail';
INSERT INTO FullTimeRiders (username, ws) VALUES
('C', ARRAY[
-----1  2  3  4  5  6  7  8  9  A  B  C
    [1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0],
    [0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0],
    [0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0],
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1], -- BAD
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
    [0, 0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1]]::BOOLEAN[]);
SELECT 'Inserting D: Fail';
INSERT INTO FullTimeRiders (username, ws) VALUES
('D', ARRAY[
-----1  2  3  4  5  6  7  8  9  A  B  C
    [1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0],
    [0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0],
    [0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0],
    [0, 0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1],
    [0, 0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1],
    [0, 0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1], -- BAD
    [0, 0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1]]::BOOLEAN[]);
SELECT 'Inserting E: Fail';
INSERT INTO FullTimeRiders (username, ws) VALUES
('E', ARRAY[
-----1  2  3  4  5  6  7  8  9  A  B  C
    [1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0],
    [1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0],
    [1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0],
    [1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0],
    [1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0],
    [1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0],
    [1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0]]::BOOLEAN[]);
SELECT 'Inserting F: Fail';
INSERT INTO FullTimeRiders (username, ws) VALUES
('F', ARRAY[
-----1  2  3  4  5  6  7  8  9  A  B  C
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]::BOOLEAN[]);
SELECT 'Inserting G: Fail';
INSERT INTO FullTimeRiders (username, ws) VALUES
('G', ARRAY[
-----1  2  3  4  5  6  7  8  9  A  B  C
    [1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0],
    [0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0],
    [0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0],
    [0, 0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]::BOOLEAN[]);

DELETE FROM Users
WHERE 
    username = 'A' OR
    username = 'B' OR
    username = 'C' OR
    username = 'D' OR
    username = 'E' OR
    username = 'F' OR
    username = 'G';

begin;
/* 
 * Testing maxQty contraint of Food table
 */
INSERT INTO Orders (deliveryLocation, totalCost, paymentMethod,
                    creation, departure, arrival, collection, delivery,
                    customerName, riderName) VALUES 
(
    'PGP', 2, 'CARD',
    '2020-03-21 17:01', '2020-03-21 18:02', '2020-03-21 18:03', '2020-03-21 18:04', '2020-03-21 18:05',
    'customer1', 'rider3');
INSERT INTO FoodOrders (orderId, restaurantName, foodName) VALUES
((SELECT MAX(id) FROM Orders), 'Pasta Express', 'Carbonara');
commit;

/* 
 * Testing timing contraints of Orders
 */
SELECT 'Tests for Orders timing';

SELECT 'Orders: creation <= departure';
begin;
INSERT INTO Orders (deliveryLocation, totalCost, paymentMethod,
                    creation, departure,
                    customerName, riderName) VALUES 
(
    'PGP', 2, 'CARD',
    '2020-03-21 17:00', '2020-03-21 16:00',
    'customer1', 'rider3');
commit;

SELECT 'Orders: departure <= arrival';
begin;
INSERT INTO Orders (deliveryLocation, totalCost, paymentMethod,
                    customerName, riderName) VALUES 
(
    'PGP', 2, 'CARD',
    'customer1', 'rider3');
SELECT riderArrival('rider3');
commit;

begin;
INSERT INTO Orders (deliveryLocation, totalCost, paymentMethod,
                    creation, departure,
                    customerName, riderName) VALUES 
(
    'PGP', 2, 'CARD',
    '2030-03-21 17:00', '2030-03-21 18:00',
    'customer1', 'rider3');
SELECT riderArrival('rider3');
commit;

SELECT 'Orders: arrival <= collection';
begin;
INSERT INTO Orders (deliveryLocation, totalCost, paymentMethod,
                    customerName, riderName) VALUES 
(
    'PGP', 2, 'CARD',
    'customer1', 'rider3');
SELECT riderDeparture('rider3');
SELECT riderCollection('rider3');
commit;

begin;
INSERT INTO Orders (deliveryLocation, totalCost, paymentMethod,
                    creation, departure, arrival,
                    customerName, riderName) VALUES 
(
    'PGP', 2, 'CARD',
    '2030-03-21 17:00', '2030-03-21 18:00', '2030-03-21 19:00',
    'customer1', 'rider3');
SELECT riderCollection('rider3');
commit;

SELECT 'Orders: collection <= delivery';
begin;
INSERT INTO Orders (deliveryLocation, totalCost, paymentMethod,
                    customerName, riderName) VALUES 
(
    'PGP', 2, 'CARD',
    'customer1', 'rider3');
SELECT riderDeparture('rider3');
SELECT riderArrival('rider3');
SELECT riderDelivery('rider3');
commit;

begin;
INSERT INTO Orders (deliveryLocation, totalCost, paymentMethod,
                    creation, departure, arrival, collection,
                    customerName, riderName) VALUES 
(
    'PGP', 2, 'CARD',
    '2030-03-21 17:00', '2030-03-21 18:00', '2030-03-21 19:00', '2030-03-21 20:00',
    'customer1', 'rider3');
SELECT riderDelivery('rider3');
commit;

SELECT 'Riders: orderid null after delivery';
begin;
INSERT INTO Orders (deliveryLocation, totalCost, paymentMethod,
                    customerName, riderName) VALUES 
(
    'PGP', 2, 'CARD',
    'customer1', 'rider3');
SELECT riderDeparture('rider3');
SELECT riderArrival('rider3');
SELECT riderCollection('rider3');
SELECT riderDelivery('rider3');
SELECT (SELECT 'orderid:'), orderid FROM Riders WHERE username = 'rider3';
ROLLBACK;


