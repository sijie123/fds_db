-- ORDERS, REVIEWS, RATINGS --

/* ONGOING ORDERS (fixed) */
begin;
	DO $$
	declare
		oid     INTEGER;
        rname   VARCHAR(50) := 'rider1';
        cname   VARCHAR(50) := 'customer1';
	begin
		INSERT INTO Orders (deliveryLocation, totalCost, paymentMethod, creation, restaurantName, customerName, riderName) VALUES
        ('PGP', 5, 'CARD', '2020-05-02 17:01', 'Ma La Xiang Guo', cname, rname);
        SELECT MAX(id) INTO oid FROM Orders;
        PERFORM riderDeparture(rname);
        PERFORM riderArrival(rname);
        INSERT INTO FoodOrders (orderId, restaurantName, foodName) VALUES
        (oid, 'Ma La Xiang Guo', 'Mala');
        PERFORM updateRewardPoints(cname, oid);
	end
	$$;
commit;

begin;
	DO $$
	declare
		oid     INTEGER;
        rname   VARCHAR(50) := 'rider2';
        cname   VARCHAR(50) := 'customer1';
	begin
		INSERT INTO Orders (deliveryLocation, totalCost, paymentMethod, creation, restaurantName, customerName, riderName) VALUES
        ('COM1', 18.5, 'CARD', '2020-05-02 17:01', 'Central Square', 'customer1', rname);
        SELECT MAX(id) INTO oid FROM Orders;
        INSERT INTO FoodOrders (orderId, restaurantName, foodName, quantity) VALUES
        (oid, 'Central Square', 'Octopus Takoyaki (5pcs)', 3),
        (oid, 'Central Square', 'Prawn Takoyaki (3pcs)', 2),
        (oid, 'Central Square', 'Ham Takoyaki (4pcs)', 4);
        PERFORM updateRewardPoints(cname, oid);
	end
	$$;
commit;

/* ONGOING ORDERS (dynamic) */
-- Order assigned, rname hasn't departed
begin;
	DO $$
	declare
		oid     INTEGER;
	begin
		INSERT INTO Orders (deliveryLocation, totalCost, paymentMethod, creation, restaurantName, customerName, riderName) VALUES
        ('COM1', 18.5, 'CARD', NOW(), 'Central Square', 'customer1', findNearestAvailableRider('Central Square', NOW()));
        SELECT MAX(id) INTO oid FROM Orders;
        INSERT INTO FoodOrders (orderId, restaurantName, foodName, quantity) VALUES
        (oid, 'Central Square', 'Octopus Takoyaki (5pcs)', 3),
        (oid, 'Central Square', 'Prawn Takoyaki (3pcs)', 2),
        (oid, 'Central Square', 'Ham Takoyaki (4pcs)', 4);
        PERFORM updateRewardPoints('customer1', oid);
	end
	$$;
commit;

-- Order assigned, rname waiting at restaurant
begin;
	DO $$
	declare
		oid     INTEGER;
        rname   VARCHAR(50);
	begin
		INSERT INTO Orders (deliveryLocation, totalCost, paymentMethod, creation, restaurantName, customerName, riderName) VALUES
        ('PGP', 52.5, 'CASH', NOW(), 'Jewel Coffee', 'customer2', findNearestAvailableRider('Jewel Coffee', NOW()));
        SELECT MAX(id) INTO oid FROM Orders;
        SELECT riderName INTO rname from Orders where id = oid;
        INSERT INTO FoodOrders (orderId, restaurantName, foodName, quantity) VALUES
        (oid, 'Jewel Coffee', 'Flat White', 3),
        (oid, 'Jewel Coffee', 'Matcha Latte', 5),
        (oid, 'Jewel Coffee', 'Iced Mocha', 1),
        (oid, 'Jewel Coffee', 'Cold-Brew Iced Tea', 1);
        PERFORM riderDeparture(rname);
        PERFORM riderArrival(rname);
        PERFORM updateRewardPoints('customer2', oid);
	end
	$$;
commit;

-- Order assigned, rname otw to customer
begin;
	DO $$
	declare
		oid     INTEGER;
        rname   VARCHAR(50);
	begin
		INSERT INTO Orders (deliveryLocation, totalCost, paymentMethod, creation, restaurantName, customerName, riderName) VALUES
        ('PGP', 11, 'CASH', NOW(), 'Reedz Cafe', 'customer2', findNearestAvailableRider('Reedz Cafe', NOW()));
        SELECT MAX(id) INTO oid FROM Orders;
        SELECT riderName INTO rname from Orders where id = oid;
        INSERT INTO FoodOrders (orderId, restaurantName, foodName, quantity) VALUES
        (oid, 'Reedz Cafe', 'Fish and Chips', 1),
        (oid, 'Reedz Cafe', 'Grilled Chicken', 1);
        PERFORM riderDeparture(rname);
        PERFORM riderArrival(rname);
        PERFORM riderCollection(rname);
        PERFORM updateRewardPoints('customer2', oid);
	end
	$$;
commit;
