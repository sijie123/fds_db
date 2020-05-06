-- RESTAURANTS --
INSERT INTO Restaurants (name, location) VALUES -- no minOrder
('Arise & Shine @ E4', 'E4'),
('Arise & Shine @ S16', 'S16'),
('Central Square', 'Yusof Ishak House Level 2'),
('Li Ji Coffeehouse', 'Frontier'),
('Maxx Coffee', 'Central Library'),
('Nami', 'innovation4.0'),
('Salad Express X Pasta Express', 'The Deck Level 2'),
('Reedz Cafe', 'Shaw Foundation Alumni'),
('Ma La Xiang Guo', 'PGP'),
('Pasta Express', 'Frontier'),
('OMO Store', 'COM1'),
('Uncle Penyet', 'The Deck Level 2');

INSERT INTO Restaurants (name, location, minOrder) VALUES
('Atempo', 'Yong Siew Toh Conservatory of Music', 5),
('Bar Bar Black Sheep', 'Alice Lee Plaza', 15),
('Cafe Delight', 'Ventus', 8),
('Crave', 'Yusof Ishak House', 10),
('Gongcha', 'University Town', 8),
('Jewel Coffee', 'MD11', 10),
('Old Chang Kee', 'Yusof Ishak House', 5),
('Platypus Food Bar', 'S16', 10),
('Poke Theory','One@KentRidge', 20),
('The Tea Party', 'University Sports Centre', 15);

-- RESTAURANT STAFF --
INSERT INTO Staff (username, restaurantName) VALUES
('arise_e4', 'Arise & Shine @ E4'),
('arise_s16', 'Arise & Shine @ S16'),
('atempo_yst', 'Atempo'),
('sheeple', 'Bar Bar Black Sheep'),
('cafeD', 'Cafe Delight'),
('centralSq', 'Central Square'),
('crave', 'Crave'),
('jewel coffee', 'Jewel Coffee'),
('liji', 'Li Ji Coffeehouse'),
('maxx', 'Maxx Coffee'),
('nami', 'Nami'),
('old ck', 'Old Chang Kee'),
('saladxpasta', 'Salad Express X Pasta Express'),
('reedz', 'Reedz Cafe'),
('garytheplatypus', 'Platypus Food Bar'),
('mala', 'Ma La Xiang Guo'),
('teaparty', 'The Tea Party'),
('betterpasta', 'Pasta Express'),
('salmon', 'Poke Theory'),
('uncle', 'Uncle Penyet'),
('bbt', 'Gongcha');

-- FOOD --
INSERT INTO Food (name, restaurantName, price, maxQty, currQty) VALUES
('Curry Puff','Arise & Shine @ E4', 1.5, 50, 50),
('Fishballs','Arise & Shine @ E4', 1.2, 20, 20),
('Seaweed Chicken','Arise & Shine @ E4', 1.2, 20,20),
('Waffle','Arise & Shine @ E4', 1.8, 100, 100),
('Fishcake','Arise & Shine @ E4', 1.2, 15, 15),
('Curry Puff','Arise & Shine @ S16', 1.5, 50, 50),
('Fishballs','Arise & Shine @ S16', 1.2, 30, 30),
('Seaweed Chicken','Arise & Shine @ S16', 1.2, 40, 40),
('Waffle','Arise & Shine @ S16', 1.8, 150, 150),
('Fishcake','Arise & Shine @ S16', 1.2, 10, 10),
('Flat White','Atempo', 5.6, 15, 15),
('Latte', 'Atempo', 5.6, 15,15),
('Iced Mocha','Atempo', 6.1, 15,15),
('Tiger Beer (half-dozen)', 'Bar Bar Black Sheep', 20, 10, 10),
('Asahi (half-dozen)', 'Bar Bar Black Sheep', 25, 10,10),
('Carlsberg (half-dozen)', 'Bar Bar Black Sheep', 25, 10,10),
('Tiger Beer Radler (half-dozen)', 'Bar Bar Black Sheep', 20, 10,10),
('Tuna Sandwich', 'Cafe Delight', 3.5, 10,10),
('Egg Sandwich', 'Cafe Delight', 2.8, 15,15),
('Chicken Sandwich', 'Cafe Delight', 3.5, 15,15),
('Octopus Takoyaki (3pcs)','Central Square', 1.5, 40,40),
('Octopus Takoyaki (4pcs)','Central Square', 2, 40, 40),
('Octopus Takoyaki (5pcs)','Central Square', 2.5, 35, 35),
('Prawn Takoyaki (3pcs)','Central Square', 1.5, 40,40),
('Prawn Takoyaki (4pcs)','Central Square', 2, 40, 40),
('Prawn Takoyaki (5pcs)','Central Square', 2.5, 35, 35),
('Ham Takoyaki (3pcs)','Central Square', 1.5, 40, 40),
('Ham Takoyaki (4pcs)','Central Square', 2, 40, 40),
('Ham Takoyaki (5pcs)','Central Square', 2.5, 35,35),
('Nasi Lemak', 'Crave', 5.5, 20, 20),
('Mee Soto', 'Crave', 5, 20, 20),
('Flat White','Jewel Coffee', 5, 30, 30),
('Matcha Latte', 'Jewel Coffee', 5.5, 25, 25),
('Iced Mocha','Jewel Coffee', 5.5, 25, 25),
('Cold-Brew Iced Tea', 'Jewel Coffee', 4.5, 15, 15),
('Breakfast Set A', 'Li Ji Coffeehouse', 4.5, 20, 20),
('Breakfast Set B', 'Li Ji Coffeehouse', 4.5, 20, 20),
('Breakfast Set C', 'Li Ji Coffeehouse', 4.5, 20, 20),
('Flat White','Maxx Coffee', 4.5, 30, 30),
('Nitro Cold Brew', 'Maxx Coffee', 6.5, 20, 20),
('Lemon Meringue Pie', 'Maxx Coffee', 6.5, 10, 10),
('Flat White','Nami', 5.6, 15, 15),
('Latte', 'Nami', 5.6, 15, 15),
('Iced Mocha','Nami', 6.1, 15, 15),
('Curry ''O','Old Chang Kee', 1.5, 100, 100),
('Chicken Mushroom ''O','Old Chang Kee', 1.5, 80, 80),
('Sardine ''O','Old Chang Kee', 1.5, 50, 50),
('Chicken Wing','Old Chang Kee', 1.8, 100, 100),
('Gyoza OnStik','Old Chang Kee', 1.6, 75, 75),
('Carbonara', 'Salad Express X Pasta Express', 4.80, 150, 150),
('Aglio Olio', 'Salad Express X Pasta Express', 4.80, 150, 150),
('Bolognese', 'Salad Express X Pasta Express', 4.80, 150, 150),
('Caesar Salad', 'Salad Express X Pasta Express', 3.2, 100, 100),
('Fish and Chips', 'Reedz Cafe', 5.5, 50, 50),
('Grilled Chicken', 'Reedz Cafe', 5.5, 50, 50),
('Milk Coffee (M)', 'Platypus Food Bar', 2.8, 50, 50),
('Milk Coffee (L)', 'Platypus Food Bar', 3.5, 50, 50),
('Red Velvet Coffee (M)', 'Platypus Food Bar', 2.8, 20, 20),
('Butterscotch Coffee (M)', 'Platypus Food Bar', 2.8, 15, 15),
('Mala', 'Ma La Xiang Guo', 5, 100, 100),
('Carbonara', 'The Tea Party', 5.6, 80, 80),
('Aglio Olio', 'The Tea Party', 5.6, 80, 80),
('Bolognese', 'The Tea Party', 5.6, 80, 80),
('Carbonara', 'Pasta Express', 4.80, 150, 150),
('Aglio Olio', 'Pasta Express', 4.80, 150, 150),
('Bolognese', 'Pasta Express', 4.80, 150, 150),
('Light Bowl', 'Poke Theory', 9.9, 150, 150),
('Regular Bowl', 'Poke Theory', 12.9, 200, 200),
('Large Bowl', 'Poke Theory', 15.9, 100, 100),
('Nasi Bebek Penyet', 'Uncle Penyet', 13.8, 50, 50),
('Nasi Ayam Penyet', 'Uncle Penyet', 8.5, 70, 70),
('Nasi Kari Ayam', 'Uncle Penyet', 6.9, 70, 70),
('Nasi Dory Penyet', 'Uncle Penyet', 7.8, 80, 80),
('Nasi Udang Penyet', 'Uncle Penyet', 7.5, 50, 50),
('Crispy Chicken Wings (2pcs)', 'Uncle Penyet', 4.6, 40, 40),
('Crispy Chicken Wings (4pcs)', 'Uncle Penyet', 8.8, 30, 30),
('Crispy Chicken Wings (6pcs)', 'Uncle Penyet', 12, 20, 20),
('Crispy Golden Udang (3pcs)', 'Uncle Penyet', 6, 20, 20),
('Shin Ramyun', 'OMO Store', 2.20, 20, 20),
('Kang Shi Fu Roast Beef Noodle', 'OMO Store', 2.20, 20, 20),
('Original Tauhuay', 'OMO Store', 1.20, 20, 20),
('Earl Grey Milk Tea', 'Gongcha', 3, 0, 0),
('Green Milk Tea', 'Gongcha', 3, 0, 0),
('Taro Milk Tea', 'Gongcha', 3.6, 0, 0),
('Milk Tea w Herbal Jelly', 'Gongcha', 3.7, 0, 0),
('Earl Grey Milk Tea w 3J', 'Gongcha', 4.4, 0, 0),
('Pearl Milk Tea', 'Gongcha', 3.4, 0, 0),
('QQ Passion Fruit Green Tea', 'Gongcha', 4.2, 0, 0),
('Caramel Milk Tea', 'Gongcha', 3.5, 0, 0)
;

-- CATEGORIES --
INSERT INTO Categories (cname) VALUES
('Asian'), ('Chinese'), ('Korean'), ('Malay'), ('Indonesian'), ('Japanese'),
('Western'), ('Italian'),
('Beverage'), ('Alcohol'),
('Snack'), ('Dessert');

INSERT INTO FoodCategories(foodName, restaurantName, category) VALUES
('Curry Puff','Arise & Shine @ E4', 'Snack'),
('Fishballs','Arise & Shine @ E4', 'Snack'),
('Seaweed Chicken','Arise & Shine @ E4', 'Snack'),
('Waffle','Arise & Shine @ E4', 'Snack'),
('Fishcake','Arise & Shine @ E4', 'Snack'),
('Curry Puff','Arise & Shine @ S16', 'Snack'),
('Fishballs','Arise & Shine @ S16', 'Snack'),
('Seaweed Chicken','Arise & Shine @ S16', 'Snack'),
('Waffle','Arise & Shine @ S16', 'Snack'),
('Fishcake','Arise & Shine @ S16', 'Snack'),
('Flat White','Atempo', 'Beverage'),
('Latte', 'Atempo', 'Beverage'),
('Iced Mocha','Atempo', 'Beverage'),
('Tiger Beer (half-dozen)', 'Bar Bar Black Sheep', 'Beverage'),
('Tiger Beer (half-dozen)', 'Bar Bar Black Sheep', 'Alcohol'),
('Asahi (half-dozen)', 'Bar Bar Black Sheep', 'Beverage'),
('Asahi (half-dozen)', 'Bar Bar Black Sheep', 'Alcohol'),
('Carlsberg (half-dozen)', 'Bar Bar Black Sheep', 'Beverage'),
('Carlsberg (half-dozen)', 'Bar Bar Black Sheep', 'Alcohol'),
('Tiger Beer Radler (half-dozen)', 'Bar Bar Black Sheep', 'Beverage'),
('Tiger Beer Radler (half-dozen)', 'Bar Bar Black Sheep', 'Alcohol'),
('Tuna Sandwich', 'Cafe Delight', 'Snack'),
('Egg Sandwich', 'Cafe Delight', 'Snack'),
('Chicken Sandwich', 'Cafe Delight', 'Snack'),
('Octopus Takoyaki (3pcs)','Central Square', 'Snack'),
('Octopus Takoyaki (3pcs)','Central Square', 'Japanese'),
('Octopus Takoyaki (4pcs)','Central Square', 'Snack'),
('Octopus Takoyaki (4pcs)','Central Square', 'Japanese'),
('Octopus Takoyaki (5pcs)','Central Square', 'Snack'),
('Octopus Takoyaki (5pcs)','Central Square', 'Japanese'),
('Prawn Takoyaki (3pcs)','Central Square', 'Snack'),
('Prawn Takoyaki (3pcs)','Central Square', 'Japanese'),
('Prawn Takoyaki (4pcs)','Central Square', 'Snack'),
('Prawn Takoyaki (4pcs)','Central Square', 'Japanese'),
('Prawn Takoyaki (5pcs)','Central Square', 'Snack'),
('Prawn Takoyaki (5pcs)','Central Square', 'Japanese'),
('Ham Takoyaki (3pcs)','Central Square', 'Snack'),
('Ham Takoyaki (3pcs)','Central Square', 'Japanese'),
('Ham Takoyaki (4pcs)','Central Square', 'Snack'),
('Ham Takoyaki (4pcs)','Central Square', 'Japanese'),
('Ham Takoyaki (5pcs)','Central Square', 'Snack'),
('Ham Takoyaki (5pcs)','Central Square', 'Japanese'),
('Nasi Lemak', 'Crave', 'Malay'),
('Nasi Lemak', 'Crave', 'Asian'),
('Mee Soto', 'Crave', 'Malay'),
('Mee Soto', 'Crave', 'Asian'),
('Flat White','Jewel Coffee', 'Beverage'),
('Matcha Latte', 'Jewel Coffee', 'Beverage'),
('Iced Mocha','Jewel Coffee', 'Beverage'),
('Cold-Brew Iced Tea', 'Jewel Coffee', 'Beverage'),
('Breakfast Set A', 'Li Ji Coffeehouse', 'Asian'),
('Breakfast Set B', 'Li Ji Coffeehouse', 'Asian'),
('Breakfast Set C', 'Li Ji Coffeehouse', 'Asian'),
('Flat White','Maxx Coffee', 'Beverage'),
('Nitro Cold Brew', 'Maxx Coffee', 'Beverage'),
('Lemon Meringue Pie', 'Maxx Coffee', 'Dessert'),
('Flat White','Nami', 'Beverage'),
('Latte', 'Nami', 'Beverage'),
('Iced Mocha','Nami', 'Beverage'),
('Curry ''O','Old Chang Kee', 'Snack'),
('Curry ''O','Old Chang Kee', 'Asian'),
('Chicken Mushroom ''O','Old Chang Kee', 'Snack'),
('Chicken Mushroom ''O','Old Chang Kee', 'Asian'),
('Sardine ''O','Old Chang Kee', 'Snack'),
('Sardine ''O','Old Chang Kee', 'Asian'),
('Chicken Wing','Old Chang Kee', 'Snack'),
('Chicken Wing','Old Chang Kee', 'Asian'),
('Gyoza OnStik','Old Chang Kee', 'Snack'),
('Gyoza OnStik','Old Chang Kee', 'Asian'),
('Carbonara', 'Salad Express X Pasta Express', 'Western'),
('Carbonara', 'Salad Express X Pasta Express', 'Italian'),
('Aglio Olio', 'Salad Express X Pasta Express', 'Western'),
('Aglio Olio', 'Salad Express X Pasta Express', 'Italian'),
('Bolognese', 'Salad Express X Pasta Express', 'Western'),
('Bolognese', 'Salad Express X Pasta Express', 'Italian'),
('Caesar Salad', 'Salad Express X Pasta Express', 'Western'),
('Fish and Chips', 'Reedz Cafe', 'Western'),
('Grilled Chicken', 'Reedz Cafe', 'Western'),
('Milk Coffee (M)', 'Platypus Food Bar', 'Beverage'),
('Milk Coffee (L)', 'Platypus Food Bar', 'Beverage'),
('Red Velvet Coffee (M)', 'Platypus Food Bar', 'Beverage'),
('Butterscotch Coffee (M)', 'Platypus Food Bar', 'Beverage'),
('Mala', 'Ma La Xiang Guo', 'Chinese'),
('Mala', 'Ma La Xiang Guo', 'Asian'),
('Carbonara', 'The Tea Party', 'Western'),
('Carbonara', 'The Tea Party', 'Italian'),
('Aglio Olio', 'The Tea Party', 'Western'),
('Aglio Olio', 'The Tea Party', 'Italian'),
('Bolognese', 'The Tea Party', 'Western'),
('Bolognese', 'The Tea Party', 'Italian'),
('Carbonara', 'Pasta Express', 'Western'),
('Carbonara', 'Pasta Express', 'Italian'),
('Aglio Olio', 'Pasta Express', 'Western'),
('Aglio Olio', 'Pasta Express', 'Italian'),
('Bolognese', 'Pasta Express', 'Western'),
('Bolognese', 'Pasta Express', 'Italian'),
('Light Bowl', 'Poke Theory', 'Japanese'),
('Light Bowl', 'Poke Theory', 'Western'),
('Regular Bowl', 'Poke Theory', 'Japanese'),
('Regular Bowl', 'Poke Theory', 'Western'),
('Large Bowl', 'Poke Theory', 'Japanese'),
('Large Bowl', 'Poke Theory', 'Western'),
('Nasi Bebek Penyet', 'Uncle Penyet', 'Asian'),
('Nasi Bebek Penyet', 'Uncle Penyet', 'Indonesian'),
('Nasi Ayam Penyet', 'Uncle Penyet', 'Asian'),
('Nasi Ayam Penyet', 'Uncle Penyet', 'Indonesian'),
('Nasi Kari Ayam', 'Uncle Penyet', 'Asian'),
('Nasi Kari Ayam', 'Uncle Penyet', 'Indonesian'),
('Nasi Dory Penyet', 'Uncle Penyet', 'Asian'),
('Nasi Dory Penyet', 'Uncle Penyet', 'Indonesian'),
('Nasi Udang Penyet', 'Uncle Penyet', 'Asian'),
('Nasi Udang Penyet', 'Uncle Penyet', 'Indonesian'),
('Crispy Chicken Wings (2pcs)', 'Uncle Penyet', 'Asian'),
('Crispy Chicken Wings (2pcs)', 'Uncle Penyet', 'Indonesian'),
('Crispy Chicken Wings (4pcs)', 'Uncle Penyet', 'Asian'),
('Crispy Chicken Wings (4pcs)', 'Uncle Penyet', 'Indonesian'),
('Crispy Chicken Wings (6pcs)', 'Uncle Penyet', 'Asian'),
('Crispy Chicken Wings (6pcs)', 'Uncle Penyet', 'Indonesian'),
('Crispy Golden Udang (3pcs)', 'Uncle Penyet', 'Asian'),
('Crispy Golden Udang (3pcs)', 'Uncle Penyet', 'Indonesian'),
('Shin Ramyun', 'OMO Store', 'Asian'),
('Shin Ramyun', 'OMO Store', 'Snack'),
('Shin Ramyun', 'OMO Store', 'Korean'),
('Kang Shi Fu Roast Beef Noodle', 'OMO Store', 'Asian'),
('Kang Shi Fu Roast Beef Noodle', 'OMO Store', 'Snack'),
('Kang Shi Fu Roast Beef Noodle', 'OMO Store', 'Chinese'),
('Original Tauhuay', 'OMO Store', 'Asian'),
('Original Tauhuay', 'OMO Store', 'Snack'),
('Original Tauhuay', 'OMO Store', 'Dessert'),
('Earl Grey Milk Tea', 'Gongcha', 'Beverage'),
('Earl Grey Milk Tea', 'Gongcha', 'Asian'),
('Green Milk Tea', 'Gongcha', 'Beverage'),
('Green Milk Tea', 'Gongcha', 'Asian'),
('Taro Milk Tea', 'Gongcha', 'Beverage'),
('Taro Milk Tea', 'Gongcha', 'Asian'),
('Milk Tea w Herbal Jelly', 'Gongcha', 'Beverage'),
('Milk Tea w Herbal Jelly', 'Gongcha', 'Asian'),
('Earl Grey Milk Tea w 3J', 'Gongcha', 'Beverage'),
('Earl Grey Milk Tea w 3J', 'Gongcha', 'Asian'),
('Pearl Milk Tea', 'Gongcha', 'Beverage'),
('Pearl Milk Tea', 'Gongcha', 'Asian'),
('QQ Passion Fruit Green Tea', 'Gongcha', 'Beverage'),
('QQ Passion Fruit Green Tea', 'Gongcha', 'Asian'),
('Caramel Milk Tea', 'Gongcha', 'Beverage');
