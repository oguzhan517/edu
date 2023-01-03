import 'package:flutter/material.dart';
import '../link_preview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SingleComment extends StatelessWidget {
  const SingleComment({super.key, required this.comment});
  final QueryDocumentSnapshot<Map<String, dynamic>> comment;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColorLight,
      child: Stack(
        children: [
          Card(
            elevation: 5,
            child: Column(
              children: [
                if ((comment["messageType"] as List<dynamic>)
                        .contains("regular") &&
                    comment["commentText"].length > 0)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 35, bottom: 10),
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      comment["commentText"],
                      softWrap: true,
                      textAlign: TextAlign.right,
                    ),
                  ),
                if (((comment["messageType"]) as List).contains("image"))
                  Container(
                    alignment: Alignment.topRight,
                    padding: const EdgeInsets.only(top: 25),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Image.network(
                      comment["imageFromUser"],
                      fit: BoxFit.cover,
                      height: 200,
                      width: 250,
                    ),
                  ),
                if ((comment["messageType"] as List<dynamic>).contains("url"))
                  Container(
                    margin: const EdgeInsets.all(12),
                    child: LinkPreview(singleMessageLink: comment["link"]),
                  ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Row(
              children: [
                Text(comment["owner"],
                    style: const TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold)),
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(comment["userImage"]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
