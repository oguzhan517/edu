import 'package:flutter/material.dart';
import '../link_preview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostMessage extends StatelessWidget {
  const PostMessage({super.key, required this.postMessage});
  final QueryDocumentSnapshot<Map<String, dynamic>> postMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: Theme.of(context).primaryColorDark,
          child: Text(
            postMessage["owner"],
            textAlign: TextAlign.end,
            style: const TextStyle(color: Colors.white),
            softWrap: true,
          ),
        ),
        const SizedBox(
          height: 6,
        ),
        const Divider(),
        if (postMessage["postText"].trim().length > 0)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            margin: const EdgeInsets.symmetric(vertical: 15),
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text(
              postMessage["postText"],
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
        if (((postMessage["messageType"]) as List).contains("image"))
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Image.network(
              postMessage["imageFromUser"],
              fit: BoxFit.cover,
              height: 220,
              width: double.infinity,
            ),
          ),
        if ((postMessage["messageType"] as List).contains("url"))
          Container(
            margin: const EdgeInsets.all(12),
            child: LinkPreview(singleMessageLink: postMessage["link"]),
          ),
      ],
    );
  }
}
