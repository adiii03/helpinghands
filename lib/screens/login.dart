import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpinghands/screens/registration.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;

  const LoginPage({
    Key? key,
    required this.showRegisterPage,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String errorMessage = '';
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();
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
                    'Welcome back,',
                    style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                  Text(
                    'Log in to continue!',
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
                    ElevatedButton(
                      onPressed: () {
                        // Perform login
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
                            'Log In ',
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
                    SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(
                              showLoginPage: () {
                                // Define callback if needed
                              },
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
