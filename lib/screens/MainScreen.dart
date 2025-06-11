import 'package:flutter/material.dart';
import 'package:savor_go1/screens/CartScreen.dart';
import 'package:savor_go1/screens/account_screen.dart';
import 'package:savor_go1/screens/homescreen.dart';
import 'package:savor_go1/screens/your_orders.dart';

class MainScreen extends StatefulWidget {
  final String userId;
  String selectedLocation;
  String enteredAddress;

  MainScreen({Key? key, required this.userId, required this.selectedLocation, required this.enteredAddress}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  Map<String, Map<String, dynamic>> cart = {}; 

  void _updateCart(Map<String, Map<String, dynamic>> updatedCart) {
    setState(() {
      cart = updatedCart;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack( 
        index: _selectedIndex,
        children: [
          HomeScreen(
            userId: widget.userId,
            selectedLocation: widget.selectedLocation,
            enteredAddress: widget.enteredAddress,
            cart: cart, 
            updateCart: _updateCart,
          ),
          YourOrdersScreen(),
          CartScreen(cartItems: cart), 
          AccountScreen(userId: widget.userId,),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "My Orders"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: _onItemTapped, 
      ),
    );
  }
}