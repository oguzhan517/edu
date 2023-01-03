import 'package:edu/widgets/social_platform_widgets/new_comment.dart';
import 'package:edu/widgets/social_platform_widgets/single_comment.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Comments extends StatefulWidget {
  const Comments({
    super.key,
    required this.categoryName,
    required this.id,
  });
  final String id;
  final String categoryName;

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      reverse: true,
      child: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("postCollection")
                  .doc(widget.categoryName)
                  .collection("posts")
                  .doc(widget.id)
                  .collection("comments")
                  .orderBy("createdAt", descending: false)
                  .snapshots(),
              builder: ((context, snapshot) {
                if (snapshot.hasData && snapshot.data!.size == 0) {
                  return const Center(
                    child: Text("Henüz hiçbir yorum yapılmadı."),
                  );
                }
                if (snapshot.hasData) {
                  return SizedBox(
                    height: 600 - MediaQuery.of(context).viewInsets.bottom,
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      physics: const ScrollPhysics(),
                      itemBuilder: (context, index) {
                        return SingleComment(
                            comment: snapshot.data!.docs[index]);
                      },
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return const Text("Herhangi bir yorum eklenmedi");
              })),
          NewComment(postId: widget.id, categoryName: widget.categoryName),
          SizedBox(
            height: MediaQuery.of(context).viewInsets.bottom,
          )
        ],
      ),
    );
  }
}
