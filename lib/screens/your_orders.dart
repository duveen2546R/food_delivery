import 'package:flutter/material.dart';

class YourOrdersScreen extends StatelessWidget {
  final List<Map<String, dynamic>> pastOrders = [
    {"orderId": "#12345", "status": "Delivered", "total": "\$25.99"},
    {"orderId": "#67890", "status": "On the way", "total": "\$40.50"},
    {"orderId": "#13579", "status": "Pending", "total": "\$18.75"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Orders")),
      body: pastOrders.isEmpty
          ? Center(child: Text("No past orders found."))
          : ListView.builder(
              itemCount: pastOrders.length,
              itemBuilder: (context, index) {
                var order = pastOrders[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text("Order ${order["orderId"]}"),
                    subtitle: Text("Status: ${order["status"]}"),
                    trailing: Text("${order["total"]}"),
                  ),
                );
              },
            ),
    );
  }
}