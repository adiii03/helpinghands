import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatRoom extends StatefulWidget {
  final String currentUserEmail;
  final String selectedUserEmail;
  const ChatRoom({required this.currentUserEmail, required this.selectedUserEmail, Key? key}) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  late IO.Socket socket;
  List<Map<String, dynamic>> messages = [];
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    connectToSocket();
    fetchMessages();
  }

  void connectToSocket() {
    socket = IO.io('http://192.168.1.9:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'query': {'email': widget.currentUserEmail},
    });
    socket.connect();
    socket.onConnect((_) {
      print('Connected');
      socket.on('newMessage', (data) {
        if (mounted) {
          setState(() {
            messages.add({
              'sender': data['sender'],
              'message': data['message'],
              'timestamp': DateTime.parse(data['timestamp']),
            });
          });
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
    print(socket.connected);
  }

  void fetchMessages() async {
    final response = await http.get(
      Uri.parse('http://192.168.1.9:3000/messages?user1=${widget.currentUserEmail}&user2=${widget.selectedUserEmail}'),
    );
    if (response.statusCode == 200) {
      setState(() {
        messages = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      throw Exception('Failed to load messages');
    }
  }

  void sendMessage() {
    var message = _messageController.text.trim();
    if (message.isNotEmpty) {
      socket.emit('sendMessage', {
        'sender': widget.currentUserEmail,
        'receiver': widget.selectedUserEmail,
        'message': message,
        'timestamp': DateTime.now().toIso8601String(),
      });
      _messageController.text = ''; // Clear the message input after sending

      // Note: Do not add the message to the messages list here, it will be added when receiving the 'newMessage' event from the socket
    }
  }


  @override
  void dispose() {
    socket.off('newMessage');
    socket.disconnect();
    super.dispose();
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Enter message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.blue),
            onPressed: sendMessage,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selectedUserEmail),
        backgroundColor: Colors.lightBlue,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                bool isCurrentUser = messages[index]['sender'] == widget.currentUserEmail;
                return Align(
                  alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                      color: isCurrentUser ? Colors.lightBlue[200] : Colors.pink[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      messages[index]['message'],
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }
}
