import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FoodItemsScreen extends StatefulWidget {
  final String restaurantName;
  final String restaurantId;
  final Map<String, Map<String, dynamic>> cart;
  final Function(Map<String, Map<String, dynamic>>) updateCart;

  const FoodItemsScreen({
    Key? key,
    required this.restaurantName,
    required this.restaurantId,
    required this.cart,
    required this.updateCart,
  }) : super(key: key);

  @override
  _FoodItemsScreenState createState() => _FoodItemsScreenState();
}

class _FoodItemsScreenState extends State<FoodItemsScreen> {
  List<Map<String, dynamic>> foodItems = []; 
  bool isLoading = true; 

  @override
  void initState() {
    super.initState();
    _fetchMenuItems();
  }

  Future<void> _fetchMenuItems() async {
    try {
      final response = await http.get(
        Uri.parse("http://127.0.0.1:5000/menu/${widget.restaurantId}"), 
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse.containsKey("menu")) {
          setState(() {
            foodItems = List<Map<String, dynamic>>.from(jsonResponse["menu"]);
            isLoading = false;
          });
        }
      } else {
        throw Exception("Failed to load menu items");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching menu items: $e");
    }
  }

  // ✅ Function to Add Item to Cart (Restricts Mixing Restaurants)
  void _addToCart(String itemId, String itemName, double itemPrice) {
  if (widget.cart.isNotEmpty) {
    String existingRestaurantId = widget.cart.values.first["restaurantId"];
    
    if (existingRestaurantId != widget.restaurantId) {
      _showErrorDialog();
      return;
    }
  }

  setState(() {
    if (widget.cart.containsKey(itemId)) {
      widget.cart[itemId]!['quantity'] += 1;
    } else {
      widget.cart[itemId] = {
        "name": itemName,
        "quantity": 1,
        "price": itemPrice,
        "restaurantId": widget.restaurantId, // ✅ Store restaurant ID
        "restaurantName": widget.restaurantName, // ✅ Store restaurant name
      };
    }
  });

  widget.updateCart(widget.cart);
}

  void _removeFromCart(String itemId) {
    setState(() {
      if (widget.cart.containsKey(itemId) && widget.cart[itemId]!['quantity'] > 0) {
        widget.cart[itemId]!['quantity'] -= 1;
        if (widget.cart[itemId]!['quantity'] == 0) {
          widget.cart.remove(itemId);
        }
      }
    });

    widget.updateCart(widget.cart);
  }

  // ✅ Show Alert Dialog when user tries to add items from different restaurants
  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Order Restriction"),
        content: const Text("You can only order from one restaurant at a time."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.restaurantName)),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : foodItems.isEmpty
              ? Center(child: Text("No food items available"))
              : ListView.builder(
                  itemCount: foodItems.length,
                  itemBuilder: (context, index) {
                    final food = foodItems[index];

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: ListTile(
                        title: Text(food["Item_Name"] ?? "Unknown Item", style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(food["Description"] ?? "No description available"), 
                            SizedBox(height: 5),
                            Text("₹${food["Price"]?.toStringAsFixed(2) ?? '0.00'}", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove_circle, color: Colors.red),
                              onPressed: () => _removeFromCart(food["Item_ID"] ?? ""),
                            ),
                            Text(widget.cart[food["Item_ID"]]?['quantity']?.toString() ?? "0"),
                            IconButton(
                              icon: Icon(Icons.add_circle, color: Colors.green),
                              onPressed: () => _addToCart(food["Item_ID"] ?? "", food["Item_Name"] ?? "", food["Price"] ?? 0.0),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}