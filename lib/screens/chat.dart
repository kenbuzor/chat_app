import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:chat_app/widgets/chat_messages.dart';
import 'package:chat_app/widgets/new_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? username;

  void setPushNotifications() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();

    //To target a certain group of users. They are subscribed to a particular topic
    await fcm.subscribeToTopic('chat');

    // To target individual devices
    // final token = await fcm.getToken();
  }

  @override
  void initState() {
    super.initState();
    setPushNotifications();
    getUsername();
  }

  void getUsername() async {
    final auth = FirebaseAuth.instance;
    final db = FirebaseFirestore.instance;
    final userId = auth.currentUser!.uid;

    final userData = await db.collection('users').doc(userId).get();

    setState(() {
      username = userData.data()!['username'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 233, 231, 231),
      appBar: AppBar(
        title: Text(username ?? '', style: const TextStyle(fontSize: 18)),
        leading: Icon(Icons.person, color: Colors.grey[500], size: 36),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.video_camera_back_outlined,
              color: Colors.grey[700],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.call_outlined, color: Colors.grey[700]),
          ),

          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.logout, color: Colors.grey[700]),
          ),
        ],
      ),
      body: const Column(
        children: [Expanded(child: ChatMessages()), NewMessage()],
      ),
    );
  }
}
