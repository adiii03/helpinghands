import 'package:flutter/material.dart';
import 'package:helpinghands/screens/userlist.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'login.dart';
// import your login screen file
import 'chatroom.dart';
// import your chat room screen file

class Dashboard extends StatefulWidget {
  final token;

  const Dashboard({@required this.token, Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late String email;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    email = jwtDecodedToken['email'];
  }

  void _logout() {
    // Navigate back to the login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyLoginScreen()),
    );
  }

  void _navigateToChatRoom() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatRoom()),
    );
  }
  void _navigateToUserList() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserListPage()),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(email),
            ElevatedButton(
              onPressed: _navigateToChatRoom,
              child: Text('Go to Chat Room'),
            ),
            ElevatedButton(
              onPressed: _navigateToUserList,
              child: Text('Go to User list Page'),
            ),
          ],
        ),
      ),
    );
  }
}
