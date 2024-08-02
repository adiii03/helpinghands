import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  late IO.Socket socket;

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    connect();
  }

  void connect() {
    // Replace 'uri' with your actual socket server URI
    socket = IO.io('http://192.168.1.9:3000',<String, dynamic> {
      "transports" :["websocket"],
      "autoConnect":false,
    });
    socket.connect();
    socket.emit("/test","Hello world");
    socket.onConnect((data) => print("Connected"));
    print(socket.connected);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF07689F), // WhatsApp chat color
        title: Text('Chat Room'),
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: 0, // Replace with your actual item count
              itemBuilder: (context, index) => Container(), // Replace with your actual item builder
            ),
          ),

          // User input
          _buildMessageInput(),
        ],
      ),
    );
  }

  // Build message input
  Widget _buildMessageInput() {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200], // WhatsApp input area color
        borderRadius: BorderRadius.circular(24.0), // Round input container
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              // Handle send message logic here
              sendMessage();
            },
            icon: Icon(
              Icons.send,
              color: Color(0xFFA2D5F2), // WhatsApp send button color
            ),
          ),
        ],
      ),
    );
  }

  void sendMessage() {
    // Implement your message sending logic here
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }
}
