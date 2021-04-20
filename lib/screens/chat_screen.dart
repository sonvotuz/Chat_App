import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chats/NJFtIhW0dxFA3FOWrswl/messages')
              .snapshots(),
          builder: (context, streamSnapshot) {
            if (streamSnapshot.hasError) {
              return Text('Something went wrong');
            }
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              Center(child: CircularProgressIndicator());
            }
            final documents = streamSnapshot.data.docs;
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) => Container(
                padding: const EdgeInsets.all(8),
                child: Text(documents[index]['text']),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          FirebaseFirestore.instance
              .collection('chats/NJFtIhW0dxFA3FOWrswl/messages')
              .add({'text': 'This was added by clicking the button'});
          // FirebaseFirestore.instance
          //     .collection('chats/NJFtIhW0dxFA3FOWrswl/messages')
          //     .snapshots()
          //     .listen((data) {
          //   data.docs.forEach((document) {
          //     print(document['text']);
          //   });
          // });
        },
      ),
    );
  }
}
