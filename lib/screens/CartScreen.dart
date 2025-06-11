import 'package:flutter/material.dart';
import 'package:savor_go1/screens/paymentScreen.dart';

class CartScreen extends StatefulWidget {
  final Map<String, Map<String, dynamic>> cartItems;

  const CartScreen({Key? key, required this.cartItems}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double getTotalPrice() {
    double total = 0;
    widget.cartItems.forEach((key, value) {
      total += value['price'] * value['quantity'];
    });
    return total;
  }

  String getRestaurantName() {
    if (widget.cartItems.isNotEmpty) {
      return widget.cartItems.values.first["restaurantName"] ?? "Unknown Restaurant";
    }
    return "Your Cart";
  }

  void _removeItem(String itemId) {
    setState(() {
      widget.cartItems.remove(itemId);
    });
  }

  void _updateQuantity(String itemId, int change) {
    setState(() {
      if (widget.cartItems.containsKey(itemId)) {
        widget.cartItems[itemId]!['quantity'] += change;
        if (widget.cartItems[itemId]!['quantity'] <= 0) {
          widget.cartItems.remove(itemId);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cart")),
      body: widget.cartItems.isEmpty
          ? const Center(
              child: Text("Your cart is empty!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            )
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.white38,
                  child: Text(
                    getRestaurantName(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.yellowAccent),
                  ),
                ),
                
                Expanded(
                  child: ListView(
                    children: widget.cartItems.entries.map((entry) {
                      final itemId = entry.key;
                      final itemDetails = entry.value;
                      final itemName = itemDetails["name"] ?? "Unknown Item";
                      final itemPrice = itemDetails["price"];
                      final itemQuantity = itemDetails["quantity"];

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          title: Text(
                            itemName,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text("₹${itemPrice.toStringAsFixed(2)} x $itemQuantity"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle, color: Colors.red),
                                onPressed: () => _updateQuantity(itemId, -1),
                              ),
                              Text(itemQuantity.toString(), style: const TextStyle(fontSize: 16)),
                              IconButton(
                                icon: const Icon(Icons.add_circle, color: Colors.green),
                                onPressed: () => _updateQuantity(itemId, 1),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text("Total: ₹${getTotalPrice().toStringAsFixed(2)}", 
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          double total = getTotalPrice();
                          if (total > 0) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentScreen(
                                  cartItems: widget.cartItems.values.toList(), 
                                  totalAmount: total,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Your cart is empty!")),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          backgroundColor: Colors.blueGrey,
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        child: const Text("Proceed to Checkout"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}