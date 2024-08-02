// import 'package:flutter/material.dart';
//
// import '../screens/chatroom.dart';
// import '../screens/dashboard.dart';
// import '../screens/userlist.dart';
//
//
//
// class BottomNav extends StatefulWidget {
//   @override
//   _BottomNavState createState() => _BottomNavState();
// }
//
// class _BottomNavState extends State<BottomNav> {
//   int _currentIndex = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: Text('Bottom Nav Bar'),
//       //   backgroundColor: Colors.blue, // Set the background color to transparent
//       //   elevation: 0, // Remove the elevation
//       // ),
//       extendBody: true, // Extend the body behind the bottom navigation bar
//       body: _getPage(_currentIndex),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         selectedItemColor: Color(0xFFFF7E67),
//         unselectedItemColor: Color(0xFFA2D5F2),
//         backgroundColor: Color(0xFF07689F),
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.chat),
//             label: 'Chat',
//           ),
//           BottomNavigationBarItem(
//             icon: _buildAddButton(),
//             label: '',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.bolt),
//             label: 'Posts',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.account_circle),
//             label: 'Account',
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAddButton() {
//     return Container(
//       width: 60.0,
//       height: 60.0,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: _currentIndex == 2 ? Colors.white : Color(0xFF07689F),
//       ),
//       child: IconButton(
//         icon: Icon(Icons.add, color: Colors.white),
//         onPressed: () {
//           // Handle the add button press
//           print('Add button pressed');
//         },
//       ),
//     );
//   }
//
//   Widget _getPage(int index) {
//     switch (index) {
//       case 0:
//         return Dashboard();
//       case 1:
//       // Navigate to the ChatRoom page
//         return ChatRoom();
//       case 2:
//         // return FeedbackPage(); // Empty container for the add button
//       case 3:
//         // return RequestNotification(donorUid: '',);
//       case 4:
//         // return ProfilePage();
//       default:
//         return Container();
//     }
//   }
//
// }
