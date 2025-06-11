import 'package:flutter/material.dart';
import 'package:savor_go1/screens/firstpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Savor Go',
      themeMode: ThemeMode.system,  
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Helvetica', 
      ),      
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Helvetica', 
      ),
      home: FirstPage(),
    );
  }
}

