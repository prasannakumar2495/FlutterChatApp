import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterchatapp/widgets/chat/message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = snapshot.data!.docs;
        return ListView.builder(
          reverse: true,
          itemBuilder: (context, index) => MessageBubble(
            //as we know Flutter makes mistakes at updating, as we can see in the login screen.
            key: ValueKey(chatDocs[index].id),
            message: chatDocs[index]['text'],
            isMe: chatDocs[index]['userID'] ==
                FirebaseAuth.instance.currentUser!.uid,
            userName: chatDocs[index]['userName'],
          ),
          itemCount: chatDocs.length,
        );
      },
    );
  }
}
