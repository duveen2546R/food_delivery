import 'package:flutter/material.dart';
import 'package:savor_go1/screens/login_register.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: Column(
        children: [
          Expanded(
            flex: 60,
            child: SizedBox(
              width: double.infinity,
              child: Image.asset("assets/logo.png",fit: BoxFit.fill,),
            ),
          ),
          Expanded(
            flex: 10,
            child: Container(
                width: double.infinity,
                color: isDarkMode ? Colors.grey[900] : Colors.orange[100], // Background color
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Padding for spacing
                child: Center(
                  child: Text(
                    "Craving something delicious? Order your favorite meals from top restaurants and get them delivered fast!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Helvetica",
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: isDarkMode ? Colors.white : Colors.black, // Text color changes with theme
                    ),
                  ),
                ),
              ),
        ),
          Expanded(
            flex:30,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.6,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode ?   Colors.deepOrange: Colors.grey[800],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    textStyle: TextStyle(fontFamily:"Helventica",fontSize: 18, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 10,
                    shadowColor: Colors.orangeAccent.withOpacity(0.5),
                  ), child: Text("Login"),),
                ),
                SizedBox(height: 30,),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.6,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
                    },
                    style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode ?   Colors.deepOrange: Colors.grey[800],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 10,
                    shadowColor: Colors.orangeAccent.withOpacity(0.5),
                  ), child: Text("Register"),),
                ),
                SizedBox(height: 20,),
              ],
            ),
          )
        ],
      ),
    );
  }
}