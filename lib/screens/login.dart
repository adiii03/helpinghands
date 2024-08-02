import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpinghands/screens/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register_page.dart'; // Import the RegisterPage
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:helpinghands/config.dart';

class MyLoginScreen extends StatefulWidget {
  const MyLoginScreen({Key? key}) : super(key: key);

  @override
  _MyLoginScreenState createState() => _MyLoginScreenState();
}

class _MyLoginScreenState extends State<MyLoginScreen> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  bool isEmailValid = true;

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }
  late SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    initSharedPref();
  }
  void initSharedPref() async{
    prefs = await SharedPreferences.getInstance();
  }
  void loginUser() async{
    if(_controllerEmail.text.isNotEmpty && _controllerPassword.text.isNotEmpty) {
      var reqBody = {
        "email": _controllerEmail.text,
        "password": _controllerPassword.text,
      };
      var response = await http.post(Uri.parse(login),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(reqBody)
      );
      var jsonResponse = jsonDecode(response.body);
      if(jsonResponse['status']){
        var myToken = jsonResponse['token'];
        prefs.setString('token', myToken);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Dashboard(token: myToken),
          ),
        );
      }else{
        print('Something went wrong');
      }
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -270,
            left: -50,
            right: 0,
            child: Material(
              elevation: 8,
              shape: CircleBorder(),
              child: Container(
                width: 760,
                height: 680,
                decoration: BoxDecoration(
                  color: Color(0xFFA2D5F2),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Positioned(
            top: -80,
            left: -80,
            child: Material(
              elevation: 8,
              shape: CircleBorder(),
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Color(0xFF07689F),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Positioned(
            top: 90,
            right: -90,
            child: Material(
              elevation: 8,
              shape: CircleBorder(),
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: Color(0xFFFF7E67),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Positioned(
            top: 150,
            left: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi,',
                  style: GoogleFonts.openSans(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                ),
                Text(
                  'Welcome back!',
                  style: GoogleFonts.openSans(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 150),
                  Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFCDE6F6),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _controllerEmail,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          prefixIcon: Icon(Icons.email),
                          border: InputBorder.none,
                          contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          labelStyle: GoogleFonts.openSans(),
                          errorText: isEmailValid ? null : 'Invalid email format',
                        ),
                        style: GoogleFonts.openSans(),
                        onChanged: (value) {
                          final emailRegex = RegExp(
                              r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
                          setState(() {
                            isEmailValid = emailRegex.hasMatch(value);
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFCDE6F6),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _controllerPassword,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                          border: InputBorder.none,
                          contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          labelStyle: GoogleFonts.openSans(),
                        ),
                        style: GoogleFonts.openSans(),
                      ),
                    ),
                  ),
                  SizedBox(height: 9),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => ForgotPasswordPage(),
                          //   ),
                          // );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: GoogleFonts.openSans(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: ()  {
                      loginUser();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFFF7E67),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      elevation: 4,
                    ),
                    child: Text(
                      'Login',
                      style: GoogleFonts.openSans(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not a member?',
                        style: GoogleFonts.openSans(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(showLoginPage: () {  },),
                            ),
                          );
                        },
                        child: Text(
                          'Register now',
                          style: GoogleFonts.openSans(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
