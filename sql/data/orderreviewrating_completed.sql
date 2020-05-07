-- ORDERS, REVIEWS, RATINGS --

/* COMPLETED ORDERS */

begin;
	DO $$
	declare
		oid     INTEGER;
        rname   VARCHAR(50) := 'rider2';
        cname   VARCHAR(50) := 'customer3';
	begin
		INSERT INTO Orders (deliveryLocation, totalCost, paymentMethod, creation, restaurantName, customerName, riderName) VALUES
        ('Ridge View Residential College', 16.8, 'CASH', '2020-05-01 17:01', 'The Tea Party', cname, rname);
        SELECT MAX(id) INTO oid FROM Orders;
        PERFORM riderDeparture(rname);
        PERFORM riderArrival(rname);
        PERFORM riderCollection(rname);
        PERFORM riderDelivery(rname);
        INSERT INTO FoodOrders (orderId, restaurantName, foodName, quantity) VALUES
        (oid, 'The Tea Party', 'Carbonara', 2),
        (oid, 'The Tea Party', 'Aglio Olio', 1);
        INSERT INTO FoodReviews (orderId, restaurantName, foodName, customerName, rating, content) VALUES
        (oid, 'The Tea Party', 'Aglio Olio', cname, 0, 'Too garlicky >:('),
        (oid, 'The Tea Party', 'Carbonara', cname, 5, '');
        INSERT INTO DeliveryRatings (orderId, riderName, customerName, rating) VALUES
        (oid, rname, cname, 5);
        PERFORM updateRewardPoints(cname, oid);
	end
	$$;
commit;

begin;
	DO $$
	declare
		oid     INTEGER;
        rname   VARCHAR(50) := 'rider2';
        cname   VARCHAR(50) := 'customer5';
	begin
		INSERT INTO Orders (deliveryLocation, totalCost, paymentMethod, creation, restaurantName, customerName, riderName) VALUES
        ('COM1', 24, 'CARD', '2020-05-02 14:01', 'Maxx Coffee', cname, rname);
        SELECT MAX(id) INTO oid FROM Orders;
        PERFORM riderDeparture(rname);
        PERFORM riderArrival(rname);
        PERFORM riderCollection(rname);
        PERFORM riderDelivery(rname);
        INSERT INTO FoodOrders (orderId, restaurantName, foodName, quantity) VALUES
        (oid, 'Maxx Coffee', 'Flat White', 1),
        (oid, 'Maxx Coffee', 'Nitro Cold Brew', 1),
        (oid, 'Maxx Coffee', 'Lemon Meringue Pie', 2);
        INSERT INTO FoodReviews (orderId, restaurantName, foodName, customerName, rating, content) VALUES
        (oid, 'Maxx Coffee', 'Flat White', cname, 5, ''),
        (oid, 'Maxx Coffee', 'Nitro Cold Brew', cname, 3, 'Too acidic'),
        (oid, 'Maxx Coffee', 'Lemon Meringue Pie', cname, 5, 'Good');
        INSERT INTO DeliveryRatings (orderId, riderName, customerName, rating) VALUES
        (oid, rname, cname, 4);
        PERFORM updateRewardPoints(cname, oid);
	end
	$$;
commit;

begin;
	DO $$
	declare
		oid     INTEGER;
        rname   VARCHAR(50) := 'rider5';
        cname   VARCHAR(50) := 'customer1';
	begin
		INSERT INTO Orders (deliveryLocation, totalCost, paymentMethod, creation, restaurantName, customerName, riderName) VALUES
        ('Cinnamon College', 17.3, 'CASH', '2020-04-29 19:01', 'Uncle Penyet', cname, rname);
        SELECT MAX(id) INTO oid FROM Orders;
        PERFORM riderDeparture(rname);
        PERFORM riderArrival(rname);
        PERFORM riderCollection(rname);
        PERFORM riderDelivery(rname);
        INSERT INTO FoodOrders (orderId, restaurantName, foodName) VALUES
        (oid, 'Uncle Penyet', 'Nasi Ayam Penyet'),
        (oid, 'Uncle Penyet', 'Crispy Chicken Wings (4pcs)');
        INSERT INTO FoodReviews (orderId, restaurantName, foodName, customerName, rating, content) VALUES
        (oid, 'Uncle Penyet', 'Nasi Ayam Penyet', cname, 4, ''),
        (oid, 'Uncle Penyet', 'Crispy Chicken Wings (4pcs)', cname, 5, '');
        INSERT INTO DeliveryRatings (orderId, riderName, customerName, rating) VALUES
        (oid, rname, cname, 5);
        PERFORM updateRewardPoints(cname, oid);
	end
	$$;
commit;

begin;
	DO $$
	declare
		oid     INTEGER;
        rname   VARCHAR(50) := 'rider5';
        cname   VARCHAR(50) := 'customer2';
	begin
		INSERT INTO Orders (deliveryLocation, totalCost, paymentMethod, creation, restaurantName, customerName, riderName) VALUES
        ('Cinnamon College', 16.6, 'CASH', '2020-05-03 19:30', 'Uncle Penyet', cname, rname);
        SELECT MAX(id) INTO oid FROM Orders;
        PERFORM riderDeparture(rname);
        PERFORM riderArrival(rname);
        PERFORM riderCollection(rname);
        PERFORM riderDelivery(rname);
        INSERT INTO FoodOrders (orderId, restaurantName, foodName) VALUES
        (oid, 'Uncle Penyet', 'Nasi Dory Penyet'),
        (oid, 'Uncle Penyet', 'Crispy Chicken Wings (4pcs)');
        INSERT INTO FoodReviews (orderId, restaurantName, foodName, customerName, rating, content) VALUES
        (oid, 'Uncle Penyet', 'Nasi Dory Penyet', cname, 5, ''),
        (oid, 'Uncle Penyet', 'Crispy Chicken Wings (4pcs)', cname, 5, '');
        INSERT INTO DeliveryRatings (orderId, riderName, customerName, rating) VALUES
        (oid, rname, cname, 5);
        PERFORM updateRewardPoints(cname, oid);
	end
	$$;
commit;

begin;
	DO $$
	declare
		oid     INTEGER;
        rname   VARCHAR(50) := 'rider7';
        cname   VARCHAR(50) := 'customer5';
	begin
		INSERT INTO Orders (deliveryLocation, totalCost, paymentMethod, creation, restaurantName, customerName, riderName) VALUES
        ('COM1', 11, 'CARD', '2020-05-03 14:01', 'Maxx Coffee', cname, rname);
        SELECT MAX(id) INTO oid FROM Orders;
        PERFORM riderDeparture(rname);
        PERFORM riderArrival(rname);
        PERFORM riderCollection(rname);
        PERFORM riderDelivery(rname);
        INSERT INTO FoodOrders (orderId, restaurantName, foodName, quantity) VALUES
        (oid, 'Maxx Coffee', 'Flat White', 1),
        (oid, 'Maxx Coffee', 'Lemon Meringue Pie', 1);
        PERFORM updateRewardPoints(cname, oid);
	end
	$$;
commit;

begin;
	DO $$
	declare
		oid     INTEGER;
        rname   VARCHAR(50) := 'rider7';
        cname   VARCHAR(50) := 'customer4';
	begin
		INSERT INTO Orders (deliveryLocation, totalCost, paymentMethod, creation, restaurantName, customerName, riderName) VALUES
        ('COM1', 11, 'CARD', '2020-05-03 14:01', 'Maxx Coffee', cname, rname);
        SELECT MAX(id) INTO oid FROM Orders;
        PERFORM riderDeparture(rname);
        PERFORM riderArrival(rname);
        PERFORM riderCollection(rname);
        PERFORM riderDelivery(rname);
        INSERT INTO FoodOrders (orderId, restaurantName, foodName, quantity) VALUES
        (oid, 'Maxx Coffee', 'Flat White', 1),
        (oid, 'Maxx Coffee', 'Lemon Meringue Pie', 1);
        PERFORM updateRewardPoints(cname, oid);
	end
	$$;
commit;

begin;
	DO $$
	declare
		oid     INTEGER;
        rname   VARCHAR(50) := 'rider3';
        cname   VARCHAR(50) := 'customer4';
	begin
		INSERT INTO Orders (deliveryLocation, totalCost, paymentMethod, creation, restaurantName, customerName, riderName) VALUES
        ('COM1', 11.9, 'CASH', '2020-05-05 18:32', 'Platypus Food Bar', cname, rname);
        SELECT MAX(id) INTO oid FROM Orders;
        PERFORM riderDeparture(rname);
        PERFORM riderArrival(rname);
        PERFORM riderCollection(rname);
        PERFORM riderDelivery(rname);
        INSERT INTO FoodOrders (orderId, restaurantName, foodName, quantity) VALUES
        (oid, 'Platypus Food Bar', 'Milk Coffee (M)', 1),
        (oid, 'Platypus Food Bar', 'Milk Coffee (L)', 1),
        (oid, 'Platypus Food Bar', 'Red Velvet Coffee (M)', 1),
        (oid, 'Platypus Food Bar', 'Butterscotch Coffee (M)', 1);
        PERFORM updateRewardPoints(cname, oid);
	end
	$$;
commit;

begin;
	DO $$
	declare
		oid     INTEGER;
        rname   VARCHAR(50) := 'rider2';
        cname   VARCHAR(50) := 'testuser';
	begin
		INSERT INTO Orders (deliveryLocation, totalCost, paymentMethod, creation, restaurantName, customerName, riderName) VALUES
        ('Ridge View Residential College', 16.8, 'CASH', '2020-05-01 17:01', 'The Tea Party', cname, rname);
        SELECT MAX(id) INTO oid FROM Orders;
        PERFORM riderDeparture(rname);
        PERFORM riderArrival(rname);
        PERFORM riderCollection(rname);
        PERFORM riderDelivery(rname);
        INSERT INTO FoodOrders (orderId, restaurantName, foodName, quantity) VALUES
        (oid, 'The Tea Party', 'Carbonara', 2),
        (oid, 'The Tea Party', 'Aglio Olio', 1);
        INSERT INTO FoodReviews (orderId, restaurantName, foodName, customerName, rating, content) VALUES
        (oid, 'The Tea Party', 'Aglio Olio', cname, 0, 'Too garlicky >:('),
        (oid, 'The Tea Party', 'Carbonara', cname, 5, '');
        INSERT INTO DeliveryRatings (orderId, riderName, customerName, rating) VALUES
        (oid, rname, cname, 5);
        PERFORM updateRewardPoints(cname, oid);
	end
	$$;
commit;

begin;
	DO $$
	declare
		oid     INTEGER;
        rname   VARCHAR(50) := 'rider2';
        cname   VARCHAR(50) := 'testuser';
	begin
		INSERT INTO Orders (deliveryLocation, totalCost, paymentMethod, creation, restaurantName, customerName, riderName) VALUES
        ('COM1', 24, 'CARD', '2020-05-02 14:01', 'Maxx Coffee', cname, rname);
        SELECT MAX(id) INTO oid FROM Orders;
        PERFORM riderDeparture(rname);
        PERFORM riderArrival(rname);
        PERFORM riderCollection(rname);
        PERFORM riderDelivery(rname);
        INSERT INTO FoodOrders (orderId, restaurantName, foodName, quantity) VALUES
        (oid, 'Maxx Coffee', 'Flat White', 1),
        (oid, 'Maxx Coffee', 'Nitro Cold Brew', 1),
        (oid, 'Maxx Coffee', 'Lemon Meringue Pie', 2);
        INSERT INTO FoodReviews (orderId, restaurantName, foodName, customerName, rating, content) VALUES
        (oid, 'Maxx Coffee', 'Flat White', cname, 5, ''),
        (oid, 'Maxx Coffee', 'Nitro Cold Brew', cname, 3, 'Too acidic'),
        (oid, 'Maxx Coffee', 'Lemon Meringue Pie', cname, 5, 'Good');
        INSERT INTO DeliveryRatings (orderId, riderName, customerName, rating) VALUES
        (oid, rname, cname, 4);
        PERFORM updateRewardPoints(cname, oid);
	end
	$$;
commit;

begin;
	DO $$
	declare
		oid     INTEGER;
        rname   VARCHAR(50) := 'rider5';
        cname   VARCHAR(50) := 'testuser';
	begin
		INSERT INTO Orders (deliveryLocation, totalCost, paymentMethod, creation, restaurantName, customerName, riderName) VALUES
        ('Cinnamon College', 17.3, 'CASH', '2020-04-29 19:01', 'Uncle Penyet', cname, rname);
        SELECT MAX(id) INTO oid FROM Orders;
        PERFORM riderDeparture(rname);
        PERFORM riderArrival(rname);
        PERFORM riderCollection(rname);
        PERFORM riderDelivery(rname);
        INSERT INTO FoodOrders (orderId, restaurantName, foodName) VALUES
        (oid, 'Uncle Penyet', 'Nasi Ayam Penyet'),
        (oid, 'Uncle Penyet', 'Crispy Chicken Wings (4pcs)');
        INSERT INTO FoodReviews (orderId, restaurantName, foodName, customerName, rating, content) VALUES
        (oid, 'Uncle Penyet', 'Nasi Ayam Penyet', cname, 4, ''),
        (oid, 'Uncle Penyet', 'Crispy Chicken Wings (4pcs)', cname, 5, '');
        INSERT INTO DeliveryRatings (orderId, riderName, customerName, rating) VALUES
        (oid, rname, cname, 5);
        PERFORM updateRewardPoints(cname, oid);
	end
	$$;
commit;

begin;
	DO $$
	declare
		oid     INTEGER;
        rname   VARCHAR(50) := 'rider5';
        cname   VARCHAR(50) := 'testuser';
	begin
		INSERT INTO Orders (deliveryLocation, totalCost, paymentMethod, creation, restaurantName, customerName, riderName) VALUES
        ('Cinnamon College', 16.6, 'CASH', '2020-05-03 19:30', 'Uncle Penyet', cname, rname);
        SELECT MAX(id) INTO oid FROM Orders;
        PERFORM riderDeparture(rname);
        PERFORM riderArrival(rname);
        PERFORM riderCollection(rname);
        PERFORM riderDelivery(rname);
        INSERT INTO FoodOrders (orderId, restaurantName, foodName) VALUES
        (oid, 'Uncle Penyet', 'Nasi Dory Penyet'),
        (oid, 'Uncle Penyet', 'Crispy Chicken Wings (4pcs)');
        INSERT INTO FoodReviews (orderId, restaurantName, foodName, customerName, rating, content) VALUES
        (oid, 'Uncle Penyet', 'Nasi Dory Penyet', cname, 5, ''),
        (oid, 'Uncle Penyet', 'Crispy Chicken Wings (4pcs)', cname, 5, '');
        INSERT INTO DeliveryRatings (orderId, riderName, customerName, rating) VALUES
        (oid, rname, cname, 5);
        PERFORM updateRewardPoints(cname, oid);
	end
	$$;
commit;

begin;
	DO $$
	declare
		oid     INTEGER;
        rname   VARCHAR(50) := 'rider7';
        cname   VARCHAR(50) := 'testuser';
	begin
		INSERT INTO Orders (deliveryLocation, totalCost, paymentMethod, creation, restaurantName, customerName, riderName) VALUES
        ('COM1', 11, 'CARD', '2020-05-03 14:01', 'Maxx Coffee', cname, rname);
        SELECT MAX(id) INTO oid FROM Orders;
        PERFORM riderDeparture(rname);
        PERFORM riderArrival(rname);
        PERFORM riderCollection(rname);
        PERFORM riderDelivery(rname);
        INSERT INTO FoodOrders (orderId, restaurantName, foodName, quantity) VALUES
        (oid, 'Maxx Coffee', 'Flat White', 1),
        (oid, 'Maxx Coffee', 'Lemon Meringue Pie', 1);
        PERFORM updateRewardPoints(cname, oid);
	end
	$$;
commit;

begin;
	DO $$
	declare
		oid     INTEGER;
        rname   VARCHAR(50) := 'rider7';
        cname   VARCHAR(50) := 'testuser';
	begin
		INSERT INTO Orders (deliveryLocation, totalCost, paymentMethod, creation, restaurantName, customerName, riderName) VALUES
        ('COM1', 11, 'CARD', '2020-05-03 14:01', 'Maxx Coffee', cname, rname);
        SELECT MAX(id) INTO oid FROM Orders;
        PERFORM riderDeparture(rname);
        PERFORM riderArrival(rname);
        PERFORM riderCollection(rname);
        PERFORM riderDelivery(rname);
        INSERT INTO FoodOrders (orderId, restaurantName, foodName, quantity) VALUES
        (oid, 'Maxx Coffee', 'Flat White', 1),
        (oid, 'Maxx Coffee', 'Nitro Cold Brew', 1);
        PERFORM updateRewardPoints(cname, oid);
	end
	$$;
commit;

begin;
	DO $$
	declare
		oid     INTEGER;
        rname   VARCHAR(50) := 'rider3';
        cname   VARCHAR(50) := 'testuser';
	begin
		INSERT INTO Orders (deliveryLocation, totalCost, paymentMethod, creation, restaurantName, customerName, riderName) VALUES
        ('COM1', 11.9, 'CASH', '2020-05-05 20:32', 'Platypus Food Bar', cname, rname);
        SELECT MAX(id) INTO oid FROM Orders;
        PERFORM riderDeparture(rname);
        PERFORM riderArrival(rname);
        PERFORM riderCollection(rname);
        PERFORM riderDelivery(rname);
        INSERT INTO FoodOrders (orderId, restaurantName, foodName, quantity) VALUES
        (oid, 'Platypus Food Bar', 'Milk Coffee (M)', 1),
        (oid, 'Platypus Food Bar', 'Milk Coffee (L)', 1),
        (oid, 'Platypus Food Bar', 'Red Velvet Coffee (M)', 1),
        (oid, 'Platypus Food Bar', 'Butterscotch Coffee (M)', 1);
        PERFORM updateRewardPoints(cname, oid);
	end
	$$;
commit;

begin;
	DO $$
	declare
		oid     INTEGER;
        rname   VARCHAR(50) := 'rider3';
        cname   VARCHAR(50) := 'testuser';
	begin
		INSERT INTO Orders (deliveryLocation, totalCost, paymentMethod, creation, restaurantName, customerName, riderName) VALUES
        ('COM1', 4.5, 'CARD', '2020-05-05 10:00', 'Li Ji Coffeehouse', cname, rname);
        SELECT MAX(id) INTO oid FROM Orders;
        PERFORM riderDeparture(rname);
        PERFORM riderArrival(rname);
        PERFORM riderCollection(rname);
        PERFORM riderDelivery(rname);
        INSERT INTO FoodOrders (orderId, restaurantName, foodName, quantity) VALUES
        (oid, 'Li Ji Coffeehouse', 'Breakfast Set B', 1);
        INSERT INTO FoodReviews (orderId, restaurantName, foodName, customerName, rating, content) VALUES
        (oid, 'Li Ji Coffeehouse', 'Breakfast Set B', cname, 0, 'Eggshell in my food');
        INSERT INTO DeliveryRatings (orderId, riderName, customerName, rating) VALUES
        (oid, rname, cname, 2);
        PERFORM updateRewardPoints(cname, oid);
	end
	$$;
commit;
