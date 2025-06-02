import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'package:chat_app/widgets/message_bubble.dart';

final date = DateFormat.jm();

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance
              .collection('chat')
              .orderBy('createdAt', descending: true)
              .snapshots(),
      builder: (ctx, chatSnapshots) {
        if (chatSnapshots.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
          return const Center(child: Text('No messages found'));
        }

        if (chatSnapshots.hasError) {
          return const Center(child: Text('Something went wrong!'));
        }

        final loadedMessages = chatSnapshots.data!.docs;
        final newMessageList =
            loadedMessages.map((data) => data.data()).toList();

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 6, left: 10, right: 10),
          reverse: true,
          itemCount: newMessageList.length,
          itemBuilder: (ctx, index) {
            final chatMessage = newMessageList[index];
            final nextMessage =
                index + 1 < newMessageList.length
                    ? newMessageList[index + 1]
                    : null;

            final currentMessageUserId = chatMessage['userId'];
            final nextMessageUserId =
                nextMessage != null ? nextMessage['userId'] : null;

            final nextUserIsSame = currentMessageUserId == nextMessageUserId;

            final timestamp = chatMessage['createdAt'] as Timestamp;
            final convertedDate = timestamp.toDate();

            if (nextUserIsSame) {
              return MessageBubble.next(
                message: chatMessage['text'],
                createdAt: date.format(convertedDate),
                usernameColor: Color(chatMessage['usernameColor']),
                isMe: authenticatedUser.uid == currentMessageUserId,
              );
            } else {
              return MessageBubble.first(
                userImage: chatMessage['image_url'],
                username: chatMessage['username'],
                message: chatMessage['text'],
                createdAt: date.format(convertedDate),
                usernameColor: Color(chatMessage['usernameColor']),
                isMe: authenticatedUser.uid == currentMessageUserId,
              );
            }
          },
        );
      },
    );
  }
}
