import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpinghands/config.dart';



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
  bool _showContactSection = false;
  String errorMessage = '';
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllercnfpassword = TextEditingController();
  final TextEditingController _controllerContact = TextEditingController();
  bool isEmailValid = false;

  // Future<void> _pickImage() async {
  //   final picker = ImagePicker();
  //   final pickedImage = await picker.pickImage(source: ImageSource.gallery);
  //
  //   setState(() {
  //     _selectedImage = pickedImage;
  //   });
  // }
  void signUp() async{
  if(_controllerEmail.text.isNotEmpty && _controllerPassword.text.isNotEmpty && _controllerPassword.text.isNotEmpty && _controllerContact.text.isNotEmpty){
    var regBody = {
      "email":_controllerEmail.text,
      "password":_controllerPassword.text,
      "name" : _controllerName.text,
      "contact": _controllerContact.text,

    };
    var response = await http.post(Uri.parse(registration),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(regBody)
    );
    var jsonResponse = jsonDecode(response.body);
    print(response);

  } else {
    setState(() {
      isEmailValid = true;
    });
  }
  }

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    _controllercnfpassword.dispose();
    _controllerName.dispose();
    _controllerContact.dispose();
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
                    if (!_showContactSection)
                      Column(
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
                                controller: _controllerName,
                                decoration: InputDecoration(
                                  labelText: 'Name',
                                  prefixIcon: Icon(Icons.person),
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
                                  final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
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
                              child: TextField(
                                controller: _controllercnfpassword,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Confirm Password',
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

                          SizedBox(height: 24),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _showContactSection = true;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFFFF7E67), // Adjust the primary color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15), // Rounded corners
                                ),
                                padding: EdgeInsets.symmetric(vertical: 9, horizontal: 24), // Adjust padding
                                elevation: 4, // Add elevation for a raised effect
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Next ',
                                    style: GoogleFonts.openSans(
                                      fontSize: 15, // Adjust the font size
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white, // Text color
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white, // Icon color
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    SizedBox(height: 300),
                    if (_showContactSection)
                      Column(
                        children: [
                          Material(
                            elevation: 8,
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFFCDE6F6),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextField(
                                controller: _controllerContact,
                                decoration: InputDecoration(
                                  labelText: 'Contact',
                                  prefixIcon: Icon(Icons.phone), // Add the icon here (you can change it to a phone icon)
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  labelStyle: GoogleFonts.openSans(),
                                ),
                                style: GoogleFonts.openSans(),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          // ElevatedButton(
                          //   onPressed: _pickImage,
                          //   style: ElevatedButton.styleFrom(
                          //     primary: Color(0xFFCDE6F6),
                          //     elevation: 8,
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(10),
                          //     ),
                          //   ),
                          //   child: Container(
                          //     decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(10),
                          //     ),
                          //     child: Padding(
                          //       padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                          //       child: Row(
                          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //         children: [
                          //           Text(
                          //             'Select Image',
                          //             style: GoogleFonts.openSans(
                          //                 fontSize: 16,
                          //
                          //                 color: Colors.grey
                          //             ),
                          //           ),
                          //           Icon(
                          //             Icons.image,
                          //             color: Colors.grey,
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          SizedBox(height: 20),
                          // if (_selectedImage != null)
                          //   Container(
                          //     width: 200, // Set the width to your desired size
                          //     height: 200, // Set the height to your desired size
                          //     child: Image.file(File(_selectedImage!.path)),
                          //   ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              signUp();
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFFFF7E67), // Adjust the primary color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15), // Rounded corners
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24), // Adjust padding
                              elevation: 4, // Add elevation for a raised effect
                            ),
                            child: Text(
                              'Register',
                              style: TextStyle( // Use TextStyle instead of GoogleFonts
                                fontSize: 14, // Adjust the font size
                                fontWeight: FontWeight.bold,
                                color: Colors.white, // Text color
                              ),
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