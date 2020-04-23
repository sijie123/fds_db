/* Data for db population */

-- USERS --
INSERT INTO Users (username, password) VALUES
('admin', 'admin'),
('staff1', 'pwd1'),
('staff2', 'pwd2'),
('staff3', 'pwd3'),
('staff4', 'pwd4'),
('existinguser', 'pwd1234'),
('customer1', 'pwd1'),
('customer2', 'pwd2'),
('customer3', 'pwd3'),
('customer4', 'pwd4'),
('rider1', 'pwd1'),
('rider2', 'pwd2'),
('rider3', 'pwd3'),
('rider4', 'pwd4');

-- MANAGERS --
INSERT INTO Managers(username) VALUES
('admin');

-- CUSTOMERS --
INSERT INTO Customers(username, cardNumber) VALUES
('customer1', '1234567812345678'),
('customer2', '8765432187654321');

INSERT INTO Customers(username) VALUES
('customer3'),
('customer4');

-- RIDERS --
INSERT INTO Riders(username, latitude, longitude) VALUES
('rider1', 1.314982, 103.764652), -- Clementi
('rider2', 1.332999, 103.742237), -- Jurong
('rider3', 1.303842, 103.774817), -- NUS UTown
('rider4', 1.293599, 103.784325); -- KR MRT

INSERT INTO PartTimeRiders (username, ws) VALUES
('rider1', ARRAY[
-----1  2  3  4  5  6  7  8  9  A  B  C
    [1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0], -- M
    [0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1], -- T
    [1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1], -- W
    [0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], -- T
    [0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0], -- F
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], -- S
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]  -- S
    ]::BOOLEAN[]
), ('rider2', ARRAY[
-----1  2  3  4  5  6  7  8  9  A  B  C
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], -- M
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], -- T
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], -- W
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], -- T
    [0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 1], -- F
    [1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1], -- S
    [0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0]  -- S
    ]::BOOLEAN[]
);

INSERT INTO FullTimeRiders (username, ws) VALUES
('rider3', ARRAY[
-----1  2  3  4  5  6  7  8  9  A  B  C
    [1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0], -- M
    [0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0], -- T
    [0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0], -- W
    [0, 0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1], -- T
    [0, 0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1], -- F
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], -- S
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]  -- S
    ]::BOOLEAN[]
), ('rider4', ARRAY[
-----1  2  3  4  5  6  7  8  9  A  B  C
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], -- M
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], -- T
    [1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0], -- W
    [0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0], -- T
    [0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0], -- F
    [0, 0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1], -- S
    [0, 0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1]  -- S
    ]::BOOLEAN[]
);

-- LOCATIONS --
INSERT INTO Locations (name, latitude, longitude) VALUES
('PGP', 1.290987, 103.781139),
('Frontier', 1.2966888,103.7783332),
('COM1', 1.294926, 103.773822),
('The Deck', 1.294467, 103.772557),
('Utown', 1.3038885, 103.7715356),
('Ridge View Residential College', 1.297763, 103.776997),
('Tembusu College', 1.306221, 103.773741);


-- RESTAURANTS --
INSERT INTO Restaurants (name, location) VALUES -- no minOrder
('Ma La Xiang Guo', 'PGP'),
('Pasta Express', 'Frontier'),
('OMO Store', 'COM1');
INSERT INTO Restaurants (name, location, minOrder) VALUES
('Uncle Penyet', 'The Deck', 10),
('Gongcha', 'Utown', 5);

-- STAFF --
INSERT INTO Staff (username, restaurantName) VALUES
('staff1', 'Ma La Xiang Guo'),
('staff2', 'Pasta Express'),
('staff3', 'Uncle Penyet'),
('staff4', 'Gongcha');

-- FOOD AND CATEGORIES--
INSERT INTO Food (name, restaurantName, price, maxQty, currQty) VALUES 
('Mala', 'Ma La Xiang Guo', 5, 100, 100),
('Carbonara', 'Pasta Express', 4.80, 150, 0),
('Aglio Olio', 'Pasta Express', 4.80, 150, 1),
('Shin Ramyun', 'OMO Store', 2.20, 50, 0),
('Nasi Ayam Penyet', 'Uncle Penyet', 4.20, 100, 0),
('Nasi Dory Penyet', 'Uncle Penyet', 5.20, 75, 1),
('Earl Grey Milk Tea', 'Gongcha', 2.80, 300, 300),
('Green Milk Tea', 'Gongcha', 3.20, 80, 80),
('Taro Milk Tea', 'Gongcha', 3, 75, 75);

INSERT INTO Categories (cname) VALUES
('Chinese'),
('Asian'),
('Western'),
('Beverages'),
('Indonesian'),
('Italian');

INSERT INTO FoodCategories(foodName, restaurantName, category) VALUES
('Mala', 'Ma La Xiang Guo', 'Chinese'),
('Mala', 'Ma La Xiang Guo', 'Asian'),
('Carbonara', 'Pasta Express', 'Western'),
('Carbonara', 'Pasta Express', 'Italian'),
('Aglio Olio', 'Pasta Express', 'Italian'),
('Aglio Olio', 'Pasta Express', 'Western'),
('Nasi Ayam Penyet', 'Uncle Penyet', 'Indonesian'),
('Nasi Ayam Penyet', 'Uncle Penyet', 'Asian'),
('Nasi Dory Penyet', 'Uncle Penyet', 'Indonesian'),
('Nasi Dory Penyet', 'Uncle Penyet', 'Asian'),
('Earl Grey Milk Tea', 'Gongcha', 'Beverages'),
('Earl Grey Milk Tea', 'Gongcha', 'Asian'),
('Green Milk Tea', 'Gongcha', 'Beverages'),
('Green Milk Tea', 'Gongcha', 'Asian'),
('Taro Milk Tea', 'Gongcha', 'Beverages'),
('Taro Milk Tea', 'Gongcha', 'Asian');

-- PROMOTIONS --

/*
 * FDS Promotion
 * 10% off total order for first-time customers
 */
SELECT addPromotion(
    promocode=>'FIRSTTIME',
    promodescription=>'10% off your first order with us!',
    promostartdate=>'2010-03-29');
SELECT implementPromotion(
    promocode=>'FIRSTTIME',
    functioncode=>'
CREATE OR REPLACE FUNCTION %s(orderid INTEGER)
returns BOOLEAN as $$
declare
    cname   VARCHAR(50);
begin
    cname   := (
        SELECT  O.customerName
        FROM    Orders O
        WHERE   O.id = orderid
    );
    IF (SELECT  count(*)
        FROM    Orders O
        WHERE   O.customerName = cname) = 1 THEN
        UPDATE  Orders
        SET     totalCost = totalCost * 0.9
        WHERE   id = orderid;
        return 1::BOOLEAN;
    END IF;
    return 0::BOOLEAN;
end 
$$ language plpgsql;
    '
);

/*
 * FDS Promotion
 * 20% off if total order is more than $100
 */
SELECT addPromotion(
    promocode=>'EATMORE',
    promodescription=>'20% off if you spend more than $100!',
    promostartdate=>'2020-04-01',
    promoenddate=>'2020-05-01');
SELECT implementPromotion(
    promocode=>'EATMORE',
    functioncode=>'
CREATE OR REPLACE FUNCTION %s(orderid INTEGER)
returns BOOLEAN as $$
begin
    IF (SELECT  O.totalCost
        FROM    Orders O
        WHERE   O.oid = $1) >= 100 THEN
        UPDATE  Orders
        SET     totalCost = totalCost * 0.8
        WHERE   id = orderid;
        return 1::BOOLEAN;
    END IF;
    return 0::BOOLEAN;
end 
$$ language plpgsql;
    '
);

/*
 * FDS Promotion
 * Free delivery during these trying times
 */
SELECT addPromotion(
    promocode=>'STAYHOME',
    promodescription=>'Free delivery so stay the * home!',
    promostartdate=>'2020-04-01',
    promoenddate=>'2020-05-01');
SELECT implementPromotion(
    promocode=>'STAYHOME',
    functioncode=>'
CREATE OR REPLACE FUNCTION %s(orderid INTEGER)
returns BOOLEAN as $$
begin
    UPDATE  Orders
    SET     deliveryFee = 0
    WHERE   id = orderid;
    return 1::BOOLEAN;
end 
$$ language plpgsql;
    '
);

/*
 * Restaurant (Gongcha) Promotion
 * 50% off Taro Milk Tea
 */
SELECT addPromotion(
    promocode=>'TAROMT',
    promodescription=>'50% Taro Milk Tea!',
    promostartdate=>'2020-01-29',
    promoenddate=>'2020-12-29',
    rname=>'Gongcha');
SELECT implementPromotion(
    promocode=>'TAROMT',
    functioncode=>'
CREATE OR REPLACE FUNCTION %s(oid INTEGER)
returns BOOLEAN as $$
declare
    orderrname  VARCHAR(50) := (
        SELECT  FO.restaurantName
        FROM    FoodOrders FO
        WHERE   FO.orderid = oid
        LIMIT   1);
    qty         INTEGER := 0;
    discountacc MONEY := 0;
begin
    qty := (
        SELECT  sum(FO.quantity)
        FROM    FoodOrders FO
        WHERE   FO.orderId = oid AND FO.foodName = ''Taro Milk Tea'');

    discountacc := (
        SELECT  F.price
        FROM    Food F
        WHERE   F.restaurantName = orderrname AND F.name = ''Taro Milk Tea'') * 0.5 * qty;

    UPDATE  Orders
    SET     totalCost = totalCost - discountacc
    WHERE   id = oid;

    return 1::BOOLEAN;
end 
$$ language plpgsql;
    '
);

/*
 * EXPIRED
 * Restaurant (Gongcha) Promotion
 * 50% off Taro Milk Tea
 */
SELECT addPromotion(
    promocode=>'TAROMTEXP',
    promodescription=>'50% Taro Milk Tea!',
    promostartdate=>'2010-01-29',
    promoenddate=>'2010-12-29',
    rname=>'Gongcha');
SELECT implementPromotion(
    promocode=>'TAROMTEXP',
    functioncode=>'
CREATE OR REPLACE FUNCTION %s(oid INTEGER)
returns BOOLEAN as $$
declare
    orderrname  VARCHAR(50) := (
        SELECT  FO.restaurantName
        FROM    FoodOrders FO
        WHERE   FO.orderid = oid
        LIMIT   1);
    qty         INTEGER := 0;
    discountacc MONEY := 0;
begin
    qty := (
        SELECT  sum(FO.quantity)
        FROM    FoodOrders FO
        WHERE   FO.orderId = oid AND FO.foodName = ''Taro Milk Tea'');

    discountacc := (
        SELECT  F.price
        FROM    Food F
        WHERE   F.restaurantName = orderrname AND F.name = ''Taro Milk Tea'') * 0.5 * qty;

    UPDATE  Orders
    SET     totalCost = totalCost - discountacc
    WHERE   id = oid;

    return 1::BOOLEAN;
end 
$$ language plpgsql;
    '
);

-- ORDERS, REVIEWS, RATINGS --

/* 
 * customer3 ordered 2x green milk tea, 1x taro milk tea from Gongcha. Paid by CASH.
 * Delivered by rider2.
 * Very upset with green milk tea (rated 0), happy with taro milk tea, happy with delivery (rated 5).
 */
INSERT INTO Orders (deliveryLocation, totalCost, paymentMethod,
                    creation,
                    restaurantName, customerName, riderName) VALUES 
(
    'Ridge View Residential College', 9.40, 'CASH',
    '2020-04-21 17:01',
    'Gongcha', 'customer3', 'rider2');
SELECT riderDeparture('rider2');
SELECT riderArrival('rider2');
SELECT riderCollection('rider2');
SELECT riderDelivery('rider2');
INSERT INTO FoodOrders (orderId, restaurantName, foodName, quantity) VALUES
((SELECT MAX(id) FROM Orders), 'Gongcha', 'Green Milk Tea', 2);
INSERT INTO FoodOrders (orderId, restaurantName, foodName, quantity) VALUES
((SELECT MAX(id) FROM Orders), 'Gongcha', 'Taro Milk Tea', 1);
INSERT INTO FoodReviews (orderId, restaurantName, foodName, customerName, rating, content) VALUES
((SELECT MAX(id) FROM Orders), 'Gongcha', 'Green Milk Tea', 'customer3', 0, 'Too diluted >:(');
INSERT INTO FoodReviews (orderId, restaurantName, foodName, customerName, rating, content) VALUES
((SELECT MAX(id) FROM Orders), 'Gongcha', 'Taro Milk Tea', 'customer3', 5, 'Nice >:(');
INSERT INTO DeliveryRatings (orderId, riderName, customerName, rating) VALUES 
((SELECT MAX(id) FROM Orders), 'rider2', 'customer3', 5);

/* 
 * customer1 ordered 1x Mala from Ma La Xiang Guo. Paid by CARD.
 * Delivered by rider4.
 * Did not leave review or rating.
 */
INSERT INTO Orders (deliveryLocation, totalCost, paymentMethod,
                    creation, departure, arrival, collection, delivery,
                    restaurantName, customerName, riderName) VALUES 
(
    'PGP', 5, 'CARD',
    '2020-03-21 17:01', '2020-03-21 18:02', '2020-03-21 18:03', '2020-03-21 18:04', '2020-03-21 18:05',
    'Ma La Xiang Guo', 'customer1', 'rider4');
INSERT INTO FoodOrders (orderId, restaurantName, foodName) VALUES
((SELECT MAX(id) FROM Orders), 'Ma La Xiang Guo', 'Mala');
INSERT INTO FoodReviews (orderId, restaurantName, foodName, customerName) VALUES
((SELECT MAX(id) FROM Orders), 'Ma La Xiang Guo', 'Mala', 'customer1');
INSERT INTO DeliveryRatings (orderId, riderName, customerName) VALUES 
((SELECT MAX(id) FROM Orders), 'rider4', 'customer1');
