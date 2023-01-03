import 'package:edu/widgets/social_platform_widgets/post_message.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './comments.dart';

class Post extends StatefulWidget {
  const Post({
    super.key,
    required this.postItem,
    required this.categoryName,
  });
  final QueryDocumentSnapshot<Map<String, dynamic>> postItem;
  final String categoryName;

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  int? commentLength;
  bool init = true;
  var firestore = FirebaseFirestore.instance;
  @override
  Future<void> didChangeDependencies() async {
    if (init == true) {
      var comments = await firestore
          .collection("postCollection")
          .doc(widget.categoryName)
          .collection("posts")
          .doc(widget.postItem.id)
          .collection("comments")
          .get();

      setState(() {
        commentLength = comments.size;
      });
    }
    super.didChangeDependencies();
    init = false;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
      elevation: 25,
      child: Column(
        children: [
          PostMessage(postMessage: widget.postItem),
          Row(
            children: [
              commentLength == null
                  ? const CircularProgressIndicator()
                  : TextButton.icon(
                      onPressed: () => showModalBottomSheet<dynamic>(
                            isScrollControlled: true,
                            context: context,
                            builder: (BuildContext bc) {
                              return Wrap(
                                children: [
                                  Comments(
                                      categoryName: widget.categoryName,
                                      id: widget.postItem.id),
                                ],
                              );
                            },
                          ),
                      icon: const Icon(Icons.comment),
                      label: Text(
                        "Yorumlar($commentLength)",
                        style: TextStyle(
                            color: Theme.of(context).primaryColorDark),
                      ))
            ],
          ),
        ],
      ),
    );
  }
}
