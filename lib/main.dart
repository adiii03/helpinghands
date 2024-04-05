import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpinghands/screens/login.dart';

void main() {
  runApp(MyApp()); // Remove const keyword here
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginPage(showRegisterPage: () {}),
    );
  }
}
