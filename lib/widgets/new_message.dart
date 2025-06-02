import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final firestoreInstance = FirebaseFirestore.instance;

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  void _submitMessage() async {
    final enteredMessage = _messageController.text;

    if (enteredMessage.trim().isEmpty) return;

    // FocusScope.of(context).unfocus();
    _messageController.clear();

    try {
      final user = FirebaseAuth.instance.currentUser!;

      final userData =
          await firestoreInstance.collection('users').doc(user.uid).get();

      await firestoreInstance.collection('chat').add({
        'text': enteredMessage,
        'createdAt': Timestamp.now(),
        'userId': user.uid,
        'username': userData.data()!['username'],
        'usernameColor': userData.data()!['usernameColor'],
        'image_url': userData.data()!['image_url'],
      });
    } on FirebaseException catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context.mounted ? context : context,
        ).clearSnackBars();
        ScaffoldMessenger.of(
          context.mounted ? context : context,
        ).showSnackBar(SnackBar(content: Text(error.message!)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 4, bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 120, minHeight: 48),
              child: TextField(
                controller: _messageController,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.multiline,
                style: const TextStyle(fontSize: 16),
                autocorrect: true,
                minLines: 1,
                maxLines: null,
                enableSuggestions: true,
                cursorHeight: 16,
                decoration: InputDecoration(
                  hintText: 'Message',
                  fillColor: const Color.fromARGB(255, 255, 255, 255),
                  filled: true,
                  contentPadding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: const Color.fromARGB(255, 4, 181, 95),
            ),
            child: IconButton(
              onPressed: _submitMessage,
              icon: const Icon(Icons.send),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
