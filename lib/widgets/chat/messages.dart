import 'package:chatapp/widgets/chat/message_bubble.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocuments = snapshot.data!.docs;
        return ListView.builder(
            reverse: true,
            itemCount: chatDocuments.length,
            itemBuilder: (ctx, index) {
              final chatDoc =
                  chatDocuments[index].data() as Map<String, dynamic>;
              return MessageBubble(chatDoc['username'], chatDoc['text'],
                  chatDoc['userImage'], chatDoc['userId'] == user!.uid,
                  key: ValueKey(chatDocuments[index].id));
            });
      },
    );
  }
}
