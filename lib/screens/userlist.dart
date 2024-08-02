import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'message_interface.dart';

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  List<dynamic> users = [];
  String currentUserEmail = '';

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final List<String> parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid token format');
    }

    final String payload = parts[1];
    final String decodedPayload =
    utf8.decode(base64Url.decode(payload.padRight((payload.length + 3) ~/ 4 * 4, '=')));

    final Map<String, dynamic> payloadMap = json.decode(decodedPayload);

    if (payloadMap.containsKey('email')) {
      currentUserEmail = payloadMap['email'];

      final response = await http.get(
        Uri.parse('http://192.168.1.9:3000/users'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> fetchedUsers = json.decode(response.body);

        setState(() {
          users = fetchedUsers.where((user) => user['email'] != currentUserEmail).toList();
        });
      } else {
        throw Exception('Failed to load users');
      }
    } else {
      throw Exception('Token does not contain email');
    }
  }

  void navigateToMessageInterface(dynamic user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatRoom(
          currentUserEmail: currentUserEmail,
          selectedUserEmail: user['email'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(users[index]['name']),
            subtitle: Text(users[index]['email']),
            onTap: () => navigateToMessageInterface(users[index]),
          );
        },
      ),
    );
  }
}
