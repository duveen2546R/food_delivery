import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InvoiceScreen extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final double totalAmount;

  InvoiceScreen({required this.cartItems, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    DateTime deliveryTime = DateTime.now().add(Duration(minutes: 40));
    String formattedDeliveryTime = DateFormat('hh:mm a').format(deliveryTime);

    return Scaffold(
      appBar: AppBar(title: Text("Order Invoice")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order Summary", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

            SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return ListTile(
                    title: Text(item["name"], style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    subtitle: Text("₹${item["price"].toStringAsFixed(2)} x ${item["quantity"]}"),
                    trailing: Text("₹${(item["price"] * item["quantity"]).toStringAsFixed(2)}"),
                  );
                },
              ),
            ),

            Divider(),

            Text("Total: ₹${totalAmount.toStringAsFixed(2)}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            SizedBox(height: 10),

            Text("Estimated Delivery Time: $formattedDeliveryTime",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),

            SizedBox(height: 20),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: Text("Back to Home"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}