// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './post.dart';

class QuestionFilterbyId extends StatelessWidget {
  QuestionFilterbyId({
    super.key,
    required this.selectedCategory,
  });
  final firestore = FirebaseFirestore.instance;
  final String selectedCategory;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: firestore
          .collection("postCollection")
          .doc(selectedCategory)
          .collection("posts")
          .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.size == 0) {
          return const Center(
            child: Text("Sorular eklendiğinde burada görüntülenecektir."),
          );
        }
        if (snapshot.hasData) {
          final categoryPosts = snapshot.data!.docs;
          return ListView.builder(
              shrinkWrap: true,
              itemCount: categoryPosts.length,
              physics: const ScrollPhysics(),
              itemBuilder: ((context, index) {
                return Post(
                  
                    postItem: categoryPosts[index],
                    categoryName: selectedCategory);
              }));
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
