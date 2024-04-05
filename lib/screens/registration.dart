import 'dart:convert';
import 'package:helpinghands/config.dart';
import 'package:flutter/material.dart';
import 'package:helpinghands/screens/donorreg.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';


class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;

  const RegisterPage({
    Key? key,
    required this.showLoginPage,
  }) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String errorMessage = '';
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  // final TextEditingController _controllercnfpassword = TextEditingController();
  bool isEmailValid = true;
  bool _isNotValidate = false;
  Map<String, String> userData = {};

  Future<void> registerUser() async {
    if (_controllerEmail.text.isNotEmpty && _controllerPassword.text.isNotEmpty) {
      var regBody = {
        "email": _controllerEmail.text,
        "password": _controllerPassword.text
      };

      var response = await http.post(
        Uri.parse(registration),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody),
      );

      if (response.statusCode == 200) {
        // Registration successful, navigate to donor registration screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DonorRegistrationScreen()),
        );
      } else {
        // Registration failed, handle error
        // You can show a snackbar or dialog to inform the user about the failure
        print('Registration failed: ${response.statusCode}');
      }
    } else {
      setState(() {
        _isNotValidate = true;
      });
    }
  }

  //
  // bool passwordsMatch() {
  //   return _controllerPassword.text.trim() == _controllercnfpassword.text.trim();
  // }

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    // _controllercnfpassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
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
                    color: Color(0xFFFF7E67),
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
                    color: Color(0xFF07689F),
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
                    'New User!',
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
                    SizedBox(height: 300),
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
                    SizedBox(height: 16),
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
                    SizedBox(height: 16),
                    Material(
                      elevation: 8,
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFCDE6F6),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: errorMessage.isNotEmpty
                          ? Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(
                          errorMessage,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                      )
                          : SizedBox.shrink(),
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFFF7E67),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 9, horizontal: 24),
                            elevation: 4,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              Text(
                                ' Back',
                                style: GoogleFonts.openSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            registerUser();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFFF7E67),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 9, horizontal: 24),
                            elevation: 4,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Register ',
                                style: GoogleFonts.openSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
