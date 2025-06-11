import 'package:flutter/material.dart';
import 'package:savor_go1/screens/firstpage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String BASE_URL = "http://192.168.0.111:5000";

class AccountScreen extends StatefulWidget {
  final String userId;

  AccountScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String userName = "Loading...";
  String userEmail = "Loading...";
  String userPhone = "Loading...";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      final response = await http.get(Uri.parse('$BASE_URL/user/${widget.userId}'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          userName = data['name'] ?? "Unknown";
          userEmail = data['email'] ?? "Unknown";
          userPhone = data['phone'] ?? "Unknown";
          isLoading = false;
        });
      } else {
        setState(() {
          userName = "Error fetching data";
          userEmail = "Error fetching data";
          userPhone = "Error fetching data";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        userName = "Network Error";
        userEmail = "Network Error";
        userPhone = "Network Error";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text("My Account"),
        backgroundColor: isDarkMode ? Colors.black : Colors.orange,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage("assets/images/real/user_profile.png"),
                    ),
                  ),
                  SizedBox(height: 20),

                  Text("Name:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(userName, style: TextStyle(fontSize: 16)),

                  SizedBox(height: 10),

                  Text("Email:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(userEmail, style: TextStyle(fontSize: 16)),

                  SizedBox(height: 10),

                  Text("Phone:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(userPhone, style: TextStyle(fontSize: 16)),

                  SizedBox(height: 20),

                  Divider(),

                  ListTile(
                    leading: Icon(Icons.edit, color: Colors.blue),
                    title: Text("Edit Profile"),
                    onTap: () {
                    },
                  ),
                  
                  ListTile(
                    leading: Icon(Icons.history, color: Colors.blue),
                    title: Text("Order History"),
                    onTap: () {
                    },
                  ),

                  ListTile(
                    leading: Icon(Icons.settings, color: Colors.blue),
                    title: Text("Settings"),
                    onTap: () {
                    },
                  ),

                  Spacer(),

                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => FirstPage()),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      child: Text("Logout"),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}