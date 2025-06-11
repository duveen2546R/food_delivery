-- Create the restaurants table
CREATE TABLE restaurants_details (
    restaurant_id NUMBER PRIMARY KEY,
    restaurant_name VARCHAR2(100) NOT NULL
);

-- Create the menu_items table with a foreign key to restaurants
CREATE TABLE menu_items (
    menu_item_id NUMBER PRIMARY KEY,
    restaurant_id NUMBER NOT NULL,
    menu_item_name VARCHAR2(100) NOT NULL,
    price NUMBER(8,2) NOT NULL,
    CONSTRAINT fk_restaurant FOREIGN KEY (restaurant_id) REFERENCES restaurants_details(restaurant_id)
);

-- Create an index on restaurant_id in menu_items for better performance
CREATE INDEX idx_menu_items_restaurant_id ON menu_items(restaurant_id);
