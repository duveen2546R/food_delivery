from flask import Flask, request, jsonify
import oracledb
import random

app = Flask(__name__)

DB_CONFIG = {
    "user": "SYSTEM",
    "password": "duveen2546",  
    "dsn": "localhost:1521/free"
}

def get_db_connection():
    """Establish a database connection."""
    return oracledb.connect(user=DB_CONFIG["user"], password=DB_CONFIG["password"], dsn=DB_CONFIG["dsn"])

def generate_unique_id():
    """Generate a unique ID for any table."""
    return str(random.randint(1000, 9999))

@app.route('/register', methods=['POST'])
def register_user():
    data = request.json
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute("SELECT 1 FROM Customer WHERE Email = :email", {"email": data["email"]})
        if cursor.fetchone():
            return jsonify({"error": "Email already registered"}), 400

        user_id = generate_unique_id()

        cursor.execute("""
            INSERT INTO Customer (Customer_ID, Name, Email, Phone_Number, Password) 
            VALUES (:cust_id, :name, :email, :phone, :password)
        """, {
            "cust_id": user_id, "name": data["name"], "email": data["email"], 
            "phone": data["phone"], "password": data["password"]
        })

        conn.commit()
        return jsonify({"message": "User registered successfully", "User_ID": user_id}), 201

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@app.route('/login', methods=['POST'])
def login_user():
    data = request.json
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute("""
            SELECT Customer_ID, Name, Email, Password 
            FROM Customer 
            WHERE Email = :email
        """, {"email": data["email"]})
        
        user = cursor.fetchone()

        if user and user[3] == data["password"]:  
            return jsonify({"message": "Login successful", "User_ID": user[0], "name": user[1], "email": user[2]}), 200
        else:
            return jsonify({"error": "Invalid email or password"}), 401

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()


@app.route('/add_address', methods=['POST'])
def add_address():
    data = request.json

    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        user_id = data.get("User_ID") 
        address = data.get("address")
        latitude = data.get("latitude")
        longitude = data.get("longitude")

        if not user_id or not address:
            return jsonify({"error": "User_ID or address is missing"}), 400

        print(f"🔍 Checking if Address_ID {user_id} exists...")

        cursor.execute("SELECT COUNT(*) FROM Address WHERE Address_ID = :addr_id", {"addr_id": user_id})
        address_exists = cursor.fetchone()[0] > 0
        print(f"✅ Address exists: {address_exists}")

        if address_exists:
            query = """
                UPDATE Address 
                SET Address = :address, Latitude = :latitude, Longitude = :longitude
                WHERE Address_ID = :addr_id
            """
            print(f"🛠 Updating address for User_ID {user_id}...")
        else:
            query = """
                INSERT INTO Address (Address_ID, Address, Latitude, Longitude) 
                VALUES (:addr_id, :address, :latitude, :longitude)
            """
            print(f"Inserting new address for User_ID {user_id}...")

        cursor.execute(query, {"addr_id": user_id, "address": address, "latitude": latitude, "longitude": longitude})

        query_update = "UPDATE Customer SET Address_ID = :addr_id WHERE Customer_ID = :cust_id"
        cursor.execute(query_update, {"addr_id": user_id, "cust_id": user_id})

        conn.commit()
        print(" Address stored successfully!")
        return jsonify({"message": "Address updated successfully"}), 200

    except Exception as e:
        print(f"Error storing address: {str(e)}")
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()

@app.route('/restaurants', methods=['GET'])
def get_restaurants():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT Restaurant_ID, Restaurant_Name, Address_ID FROM Restaurant")
        restaurants = [{"id": row[0], "name": row[1], "address_id": row[2]} for row in cursor.fetchall()]
        return jsonify({"restaurants": restaurants})
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@app.route('/menu/<restaurant_id>', methods=['GET'])
def get_menu(restaurant_id):
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute("SELECT Item_ID, Item_Name, Description, Price FROM Menu_Item WHERE Restaurant_ID = :restaurant_id", 
                       {"restaurant_id": restaurant_id})
        
        menu_items = [{"Item_ID": row[0], "Item_Name": row[1], "Description": row[2], "Price": row[3]} for row in cursor.fetchall()]

        return jsonify({"menu": menu_items})

    except Exception as e:
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()


@app.route('/cart/add', methods=['POST'])
def add_to_cart():
    data = request.json
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        customer_id = data["Customer_ID"]
        item_id = data["Item_ID"]
        quantity = data["Quantity"]

        cursor.execute("""
            SELECT Quantity FROM Cart WHERE Customer_ID = :customer_id AND Item_ID = :item_id
        """, {"customer_id": customer_id, "item_id": item_id})
        
        existing_item = cursor.fetchone()

        if existing_item:
            new_quantity = existing_item[0] + quantity
            cursor.execute("""
                UPDATE Cart SET Quantity = :quantity WHERE Customer_ID = :customer_id AND Item_ID = :item_id
            """, {"quantity": new_quantity, "customer_id": customer_id, "item_id": item_id})
        else:
            cart_id = generate_unique_id()
            cursor.execute("""
                INSERT INTO Cart (Cart_ID, Customer_ID, Item_ID, Quantity) 
                VALUES (:cart_id, :customer_id, :item_id, :quantity)
            """, {
                "cart_id": cart_id, 
                "customer_id": customer_id, 
                "item_id": item_id, 
                "quantity": quantity
            })

        conn.commit()
        return jsonify({"message": "Item added to cart"}), 201

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@app.route('/cart/<customer_id>', methods=['GET'])
def get_cart(customer_id):
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("""
            SELECT c.Item_ID, m.Item_Name, m.Price, c.Quantity 
            FROM Cart c 
            JOIN Menu_Item m ON c.Item_ID = m.Item_ID 
            WHERE c.Customer_ID = :customer_id
        """, {"customer_id": customer_id})
        cart_items = [{"item_id": row[0], "name": row[1], "price": row[2], "quantity": row[3]} for row in cursor.fetchall()]
        return jsonify({"cart": cart_items})
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@app.route('/order/place', methods=['POST'])
def place_order():
    data = request.json
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        order_id = generate_unique_id()
        order_item_id = generate_unique_id()  # ✅ One Order_Item_ID for all items

        cursor.execute("""
            INSERT INTO Order_Details (Order_ID, Customer_ID, Restaurant_ID, Order_Status, Total_Amount)
            SELECT :order_id, :customer_id, m.Restaurant_ID, 'Pending', SUM(m.Price * c.Quantity)
            FROM Cart c 
            JOIN Menu_Item m ON c.Item_ID = m.Item_ID
            WHERE c.Customer_ID = :customer_id
            GROUP BY m.Restaurant_ID
        """, {"order_id": order_id, "customer_id": data["Customer_ID"]})

        cursor.execute("""
            INSERT INTO Order_Item (Order_Item_ID, Order_ID, Item_ID, Quantity, Price)
            SELECT :order_item_id, :order_id, c.Item_ID, c.Quantity, m.Price
            FROM Cart c
            JOIN Menu_Item m ON c.Item_ID = m.Item_ID
            WHERE c.Customer_ID = :customer_id
        """, {
            "order_item_id": order_item_id, 
            "order_id": order_id, 
            "customer_id": data["Customer_ID"]
        })

        cursor.execute("DELETE FROM Cart WHERE Customer_ID = :customer_id", {"customer_id": data["Customer_ID"]})

        conn.commit()
        return jsonify({"message": "Order placed successfully", "Order_ID": order_id, "Order_Item_ID": order_item_id}), 201

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@app.route('/payment', methods=['POST'])
def process_payment():
    data = request.json
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        payment_id = generate_unique_id()
        cursor.execute("""
            INSERT INTO Payment (Payment_ID, Order_ID, Payment_Status)
            VALUES (:payment_id, :order_id, 'Success')
        """, {"payment_id": payment_id, "order_id": data["Order_ID"]})
        
        cursor.execute("UPDATE Order_Details SET Order_Status = 'Completed' WHERE Order_ID = :order_id", {"order_id": data["Order_ID"]})

        conn.commit()
        return jsonify({"message": "Payment successful"}), 201

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()


@app.route('/user/<user_id>', methods=['GET'])
def get_user_details(user_id):
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("""
            SELECT Name, Email, Phone_Number FROM Customer WHERE Customer_ID = :user_id
        """, {"user_id": user_id})

        user = cursor.fetchone()

        if user:
            return jsonify({"name": user[0], "email": user[1], "phone": user[2]}), 200
        else:
            return jsonify({"error": "User not found"}), 404

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()

        
if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)