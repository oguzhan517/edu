import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../link_preview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.singleMessage});
  final QueryDocumentSnapshot<Map<String, dynamic>> singleMessage;

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return Stack(
      children: [
        Row(
          mainAxisAlignment: userId == singleMessage["userId"]
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 20),
              width: singleMessage["messageType"].contains("url") ? 260 : 150,
              child: Column(
                children: [
                  if (singleMessage["message"].trim().length > 0)
                    Container(
                      width: 180,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: userId == singleMessage["userId"]
                              ? Theme.of(context).primaryColorDark
                              : Theme.of(context).primaryColorLight),
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 12),
                      child: Text(
                        singleMessage["message"],
                        softWrap: true,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  if (((singleMessage["messageType"]) as List)
                      .contains("image"))
                    Image.network(
                      singleMessage["imageFromUser"],
                      fit: BoxFit.cover,
                      height: 200,
                      width: 200,
                    ),
                  if ((singleMessage["messageType"] as List).contains("url"))
                    Container(
                      margin: const EdgeInsets.all(12),
                      child:
                          LinkPreview(singleMessageLink: singleMessage["link"]),
                    ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          right: userId == singleMessage["userId"] ? 95 : null,
          left: userId == singleMessage["userId"] ? null : 95,
          child: Row(
            children: [
              if ((userId == singleMessage["userId"]))
                Text(singleMessage["owner"],
                    style: const TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold)),
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(singleMessage["userImage"]),
              ),
              if (!(userId == singleMessage["userId"]))
                Text(
                  singleMessage["owner"],
                  style: const TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
