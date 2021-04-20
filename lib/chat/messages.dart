import 'package:chat_app/chat/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User currentUser = FirebaseAuth.instance.currentUser;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting ||
              !chatSnapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final chatDocs = chatSnapshot.data.docs;

          return ListView.builder(
            reverse: true,
            itemCount: chatDocs.length,
            itemBuilder: (context, index) => MessageBubble(
                chatDocs[index]['text'],
                chatDocs[index]['username'],
                chatDocs[index]['userImage'],
                chatDocs[index]['userId'] == currentUser.uid,
                key: ValueKey(chatSnapshot.data.docs[index])),
          );
        });
    // });
  }
}
