-- Insert into Address
INSERT INTO Address (Address_ID, Address, Latitude, Longitude) VALUES
('001', '123 Marina Beach Road, Chennai', 13.0500, 80.2824),
('002', '456 Anna Salai, Chennai', 13.0635, 80.2605),
('003', '789 T Nagar, Chennai', 13.0433, 80.2337),
('004', '12 Velachery Main Road, Chennai', 12.9823, 80.2197),
('005', '88 Mylapore, Chennai', 13.0331, 80.2668),
('006', '25 OMR IT Park, Chennai', 12.9164, 80.2279),
('007', '77 Adyar, Chennai', 13.0067, 80.2554),
('008', '19 Perambur, Chennai', 13.1184, 80.2547),
('009', '36 Chrompet, Chennai', 12.9502, 80.1411),
('010', '55 Kilpauk, Chennai', 13.0835, 80.2461);

INSERT INTO Restaurant (Restaurant_ID, Restaurant_Name, Address_ID, Opening_Hours, Closing_Hours) VALUES
('001', 'Spicy Biryani House', '001', '10:00 AM', '11:00 PM'),
('002', 'Tandoori Flames', '002', '09:00 AM', '10:00 PM'),
('003', 'Minute by Tuk Tuk', '003', '08:00 AM', '09:00 PM'),
('004', 'Velachery BBQ Nation', '004', '12:00 PM', '11:00 PM'),
('005', 'Mylai Masala', '005', '07:00 AM', '10:30 PM'),
('006', 'OMR Thalapakatti', '006', '11:00 AM', '11:30 PM'),
('007', 'Adyar Chettinad', '007', '10:00 AM', '10:00 PM'),
('008', 'Perambur Grill', '008', '11:30 AM', '11:00 PM'),
('009', 'Chrompet Parotta Corner', '009', '05:00 PM', '01:00 AM'),
('010', 'Kilpauk Sangeetha', '010', '07:30 AM', '10:30 PM');

INSERT INTO Menu_Item (Item_ID, Restaurant_ID, Item_Name, Description, Price) VALUES
('M001', '001', 'Chicken Biryani', 'Authentic spicy biryani served with raita', 249.99),
('M002', '001', 'Mutton Biryani', 'Fragrant basmati rice with tender mutton pieces', 299.99),
('M003', '001', 'Paneer Butter Masala', 'Delicious paneer cooked in butter masala', 199.99),
('M004', '001', 'Tandoori Roti', 'Freshly baked in a clay oven', 49.99),
('M005', '001', 'Dal Tadka', 'Lentils tempered with garlic and spices', 149.99),
('M006', '001', 'Gulab Jamun', 'Sweet dumplings soaked in sugar syrup', 99.99),
('M007', '002', 'Tandoori Chicken', 'Grilled chicken with smoky flavor', 299.99),
('M008', '002', 'Mutton Seekh Kebab', 'Juicy mutton kebabs served with chutney', 349.99),
('M009', '002', 'Butter Naan', 'Soft Indian bread with butter', 59.99),
('M010', '002', 'Chicken Tikka', 'Marinated chicken pieces grilled to perfection', 249.99),
('M011', '002', 'Tandoori Prawns', 'Grilled prawns with Indian spices', 399.99),
('M012', '002', 'Gajar Halwa', 'Sweet carrot pudding', 119.99),
('M013', '003', 'Veg Burger', 'Crispy veggie patty with fresh lettuce and mayo', 149.99),
('M014', '003', 'Peri Peri Fries', 'Spicy crispy fries with Peri Peri seasoning', 99.99),
('M015', '003', 'Chicken Wrap', 'Grilled chicken wrapped in soft bread', 199.99),
('M016', '003', 'Veg Pizza', 'Classic cheese and veggie pizza', 249.99),
('M017', '003', 'Chocolate Brownie', 'Rich chocolate dessert', 149.99),
('M018', '003', 'Cold Coffee', 'Iced coffee with a creamy texture', 129.99),
('M019', '004', 'BBQ Chicken Wings', 'Smoked chicken wings with BBQ sauce', 259.99),
('M020', '004', 'Prawns Tikka', 'Grilled prawns with Indian spices', 399.99),
('M021', '004', 'Tandoori Mushroom', 'Grilled mushrooms with spicy marinade', 199.99),
('M022', '004', 'Lamb Chops', 'Slow-cooked lamb with BBQ glaze', 349.99),
('M023', '004', 'Paneer BBQ Skewers', 'Cottage cheese grilled to perfection', 199.99),
('M024', '004', 'Mango Lassi', 'Refreshing yogurt-based mango drink', 119.99),
('M025', '005', 'Masala Dosa', 'Crispy dosa stuffed with spicy potato filling', 119.99),
('M026', '005', 'Idli Sambar', 'Steamed rice cakes with lentil soup', 89.99),
('M027', '005', 'Vada', 'Deep-fried lentil doughnut', 79.99),
('M028', '005', 'Pongal', 'Rice and lentil dish with ghee', 149.99),
('M029', '005', 'Rava Kesari', 'Sweet semolina pudding', 99.99),
('M030', '005', 'Filter Coffee', 'Strong South Indian coffee', 59.99),
('M031', '006', 'Thalapakatti Biryani', 'Famous Dindigul-style biryani', 279.99),
('M032', '006', 'Chicken 65', 'Crispy fried spicy chicken', 189.99),
('M033', '006', 'Mutton Kola Urundai', 'Deep-fried mutton meatballs', 249.99),
('M034', '006', 'Egg Parotta', 'Layered parotta with egg masala', 129.99),
('M035', '006', 'Chettinad Chicken', 'Spicy chicken curry with coconut', 229.99),
('M036', '006', 'Nannari Sarbath', 'Traditional herbal drink', 99.99),
('M037', '007', 'Chettinad Chicken Curry', 'Spicy chicken curry with coconut', 229.99),
('M038', '007', 'Mutton Chukka', 'Spicy dry-fried mutton', 349.99),
('M039', '007', 'Fish Fry', 'Shallow fried fish with spices', 299.99),
('M040', '007', 'Kothu Parotta', 'Shredded parotta mixed with egg & chicken', 149.99),
('M041', '007', 'Pepper Rasam', 'Tangy pepper soup', 99.99);

INSERT INTO Menu_Item (Item_ID, Restaurant_ID, Item_Name, Description, Price) VALUES
('M042', '008', 'Grilled Chicken', 'Tender grilled chicken with herbs', 259.99),
('M043', '008', 'Paneer Tikka', 'Grilled paneer cubes with spices', 199.99),
('M044', '008', 'Garlic Naan', 'Indian flatbread with garlic flavor', 59.99),
('M045', '008', 'Mixed Grill Platter', 'Assorted grilled meats and veggies', 349.99),
('M046', '008', 'Lemonade', 'Freshly squeezed lemonade', 79.99);

INSERT INTO Menu_Item (Item_ID, Restaurant_ID, Item_Name, Description, Price) VALUES
('M047', '009', 'Chicken Parotta', 'Flaky layered bread served with chicken curry', 149.99),
('M048', '009', 'Mutton Parotta', 'Layered bread with spicy mutton curry', 179.99),
('M049', '009', 'Egg Parotta', 'Parotta served with egg curry', 129.99),
('M050', '009', 'Vegetable Kurma', 'Mixed vegetable curry in coconut gravy', 139.99),
('M051', '009', 'Filter Coffee', 'Traditional South Indian coffee', 59.99);

INSERT INTO Menu_Item (Item_ID, Restaurant_ID, Item_Name, Description, Price) VALUES
('M052', '010', 'Idli', 'Steamed rice cakes served with chutney and sambar', 89.99),
('M053', '010', 'Dosa', 'Crispy rice crepes with potato filling', 99.99),
('M054', '010', 'Vada', 'Deep fried lentil doughnuts', 79.99),
('M055', '010', 'Sambar', 'Lentil-based vegetable stew', 59.99),
('M056', '010', 'South Indian Thali', 'Assortment of dishes served with rice and breads', 249.99);

COMMIT;