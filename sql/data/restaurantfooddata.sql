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
('platypupsgary', 'Platypus Food Bar'),
('mala', 'Ma La Xiang Guo'),
('teaparty', 'The Tea Party'),
('betterpasta', 'Pasta Express'),
('salmon', 'Poke Theory'),
('uncle', 'Uncle Penyet'),
('bbt', 'Gongcha')
;

-- FOOD --
INSERT INTO Food (name, restaurantName, price, maxQty, currQty) VALUES
('Curry Puff','Arise & Shine @ E4', 1.5, 50, 3),
('Fishballs','Arise & Shine @ E4', 1.2, 20, 1),
('Seaweed Chicken','Arise & Shine @ E4', 1.2, 20, 20),
('Waffle','Arise & Shine @ E4', 1.8, 100, 20),
('Fishcake','Arise & Shine @ E4', 1.2, 15, 0),
('Curry Puff','Arise & Shine @ S16', 1.5, 50, 23),
('Fishballs','Arise & Shine @ S16', 1.2, 30, 12),
('Seaweed Chicken','Arise & Shine @ S16', 1.2, 40, 39),
('Waffle','Arise & Shine @ S16', 1.8, 150, 90),
('Fishcake','Arise & Shine @ S16', 1.2, 10, 3),
('Flat White','Atempo', 5.6, 15, 2),
('Latte', 'Atempo', 5.6, 15, 6),
('Iced Mocha','Atempo', 6.1, 15, 8),
('Tiger Beer (half-dozen)', 'Bar Bar Black Sheep', 20, 10, 0),
('Asahi (half-dozen)', 'Bar Bar Black Sheep', 25, 10, 2),
('Carlsberg (half-dozen)', 'Bar Bar Black Sheep', 25, 10, 4),
('Tiger Beer Radler (half-dozen)', 'Bar Bar Black Sheep', 20, 10, 6),
('Tuna Sandwich', 'Cafe Delight', 3.5, 10, 4),
('Egg Sandwich', 'Cafe Delight', 2.8, 15, 12),
('Chicken Sandwich', 'Cafe Delight', 3.5, 15, 15),
('Octopus Takoyaki (3pcs)','Central Square', 1.5, 40, 40),
('Octopus Takoyaki (4pcs)','Central Square', 2, 40, 24),
('Octopus Takoyaki (5pcs)','Central Square', 2.5, 35, 23),
('Prawn Takoyaki (3pcs)','Central Square', 1.5, 40, 32),
('Prawn Takoyaki (4pcs)','Central Square', 2, 40, 23),
('Prawn Takoyaki (5pcs)','Central Square', 2.5, 35, 23),
('Ham Takoyaki (3pcs)','Central Square', 1.5, 40, 26),
('Ham Takoyaki (4pcs)','Central Square', 2, 40, 23),
('Ham Takoyaki (5pcs)','Central Square', 2.5, 35, 35),
('Crave', , ,),
('Flat White','Jewel Coffee', 5, 30, 25),
('Matcha Latte', 'Jewel Coffee', 5.5, 25, 13),
('Iced Mocha','Jewel Coffee', 5.5, 25, 9),
('Cold-Brew Iced Tea', 'Jewel Coffee', 4.5, 15, 3),
('Breakfast Set A', 'Li Ji Coffeehouse', 4.5, 20, 19),
('Breakfast Set B', 'Li Ji Coffeehouse', 4.5, 20, 13),
('Breakfast Set C', 'Li Ji Coffeehouse', 4.5, 20, 8),
('Flat White','Maxx Coffee', 4.5, 30, 17),
('Nitro Cold Brew', 'Maxx Coffee', 6.5, 20, 4),
('Lemon Meringue Pie', 'Maxx Coffee', 6.5, 5, 2),
('Nami', , ,),
("Curry 'O",'Old Chang Kee', 1.5, 100, 12),
("Chicken Mushroom 'O",'Old Chang Kee', 1.5, 80, 2),
("Sardine 'O",'Old Chang Kee', 1.5, 50, 6),
('Chicken Wing','Old Chang Kee', 1.8, 100, 43),
('Gyoza OnStik','Old Chang Kee', 1.6, 75, 23),
('Salad Express X Pasta Express', , ,),
('Fish and Chips', 'Reedz Cafe', 5.5, 50, 23),
('Grilled Chicken', 'Reedz Cafe', 5.5, 50, 22),
('Platypus Food Bar', , ,),
('Mala', 'Ma La Xiang Guo', 5, 100, 100),
('Carbonara', 'The Tea Party', 5.6, 80, 27),
('Aglio Olio', 'The Tea Party', 5.6, 80, 37),
('Bolognese', 'The Tea Party', 5.6, 80, 23),
('Carbonara', 'Pasta Express', 4.80, 150, 57),
('Aglio Olio', 'Pasta Express', 4.80, 150, 67),
('Bolognese', 'Pasta Express', 4.80, 150, 83),
('Light Bowl', 'Poke Theory', 9.9, 150, 100),
('Regular Bowl', 'Poke Theory', 12.9, 200, 132),
('Large Bowl', 'Poke Theory', 15.9, 100, 89),
('Nasi Bebek Penyet', 'Uncle Penyet', 13.8, 50, 13),
('Nasi Ayam Penyet', 'Uncle Penyet', 8.5, 70, 20),
('Nasi Kari Ayam', 'Uncle Penyet', 6.9, 70, 23),
('Nasi Dory Penyet', 'Uncle Penyet', 7.8, 80, 34),
('Nasi Udang Penyet', 'Uncle Penyet', 7.5, 50, 23),
('Crispy Chicken Wings (2pcs)', 'Uncle Penyet', 4.6, 40, 40),
('Crispy Chicken Wings (4pcs)', 'Uncle Penyet', 8.8, 30, 26),
('Crispy Chicken Wings (6pcs)', 'Uncle Penyet', 12, 20, 1),
('Crispy Golden Udang (3pcs)', 'Uncle Penyet', 6, 20, 13),
('Earl Grey Milk Tea', 'Gongcha', 3, 0, 0),
('Green Milk Tea', 'Gongcha', 3, 0, 0),
('Taro Milk Tea', 'Gongcha', 3.6, 0, 0),
('Milk Tea w Herbal Jelly', 'Gongcha', 3.7, 0, 0),
('Earl Grey Milk Tea w 3J', 'Gongcha', 4.4, 0, 0),
('Pearl Milk Tea', 'Gongcha', 3.4, 0, 0),
('QQ Passion Fruit Green Tea', 'Gongcha', 4.2, 0, 0),
('Caramel Milk Tea', 'Gongcha', 3.5, 0, 0),
('Shin Ramyun', 'OMO Store', 2.20, 50, 0)
;

-- CATEGORIES --
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