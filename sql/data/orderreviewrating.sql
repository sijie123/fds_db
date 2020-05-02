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
