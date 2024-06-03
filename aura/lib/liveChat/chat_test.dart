// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ChatScreen extends StatelessWidget {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final TextEditingController _chatController = TextEditingController();
//   String? name = '';

//   void _signOut() async {
//     await _auth.signOut();
//   }

//   void _sendMessage(String message) async {
//     _chatController.text = message;
//     name = _auth.currentUser!.displayName;
//     _chatController.clear();
//     try {
//       User? user = _auth.currentUser;
//       if (user != null) {
//         await _firestore.collection('messages').add({
//           'text': message,
//           'senderId': name,
//           'timestamp': DateTime.now(),
//         });
//       }
//     } catch (e) {
//       print('Error sending message: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chat'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: _signOut,
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder(
//               stream: _firestore.collection('messages').snapshots(),
//               builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                 if (!snapshot.hasData) {
//                   return CircularProgressIndicator();
//                 }
//                 final messages = snapshot.data!.docs;
//                 List<Widget> messageWidgets = [];
//                 for (var message in messages) {
//                   final messageText = message['text'];
//                   final messageSender = message['senderId'];
//                   final currentUser = _auth.currentUser!.uid;

//                   final messageWidget = ListTile(
//                     title: Text(messageText),
//                     subtitle: Text(messageSender),
//                     trailing:
//                         messageSender == currentUser ? Icon(Icons.check) : null,
//                   );
//                   messageWidgets.add(messageWidget);
//                 }
//                 return ListView(
//                   children: messageWidgets,
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _chatController,
//                     decoration: InputDecoration(
//                       hintText: 'Type a message...',
//                       border: OutlineInputBorder(),
//                     ),
//                     onSubmitted: _sendMessage,
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: () {
//                     _sendMessage(_chatController.text);
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
