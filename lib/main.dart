import 'package:flutter/material.dart';
import 'package:helpinghands/screens/dashboard.dart';
import 'package:helpinghands/screens/login.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import the MyLoginScreen widget

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(token : prefs.getString('token')));
}

class MyApp extends StatelessWidget {
  final String? token; // Add '?' to make token nullable

  const MyApp({Key? key, this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: (token != null && !JwtDecoder.isExpired(token!))
          ? Dashboard(token: token!)
          : MyLoginScreen(),
    );
  }
}

