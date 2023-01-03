import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddNewEntry {
  static Future<void> addNewMessage(
      String chatId,
      dynamic selectedA,
      bool isLaunchMode,
      TextEditingController messageController,
      String entryType,
      String categoryName,
      String postId) async {
    var firestore = FirebaseFirestore.instance;
    var auth = FirebaseAuth.instance;
    List<String> type = ["regular"];
    String url = "";
    String imageUrl = "";
    final ids = chatId.split(" - ");
    if (entryType == "chat") {
      firestore.collection("chat").doc(chatId).set({
        "createdAt": Timestamp.now(),
        "participants": ids,
      });
    }
    if (selectedA != "not picked") {
      type.add("image");
      var uuid = const Uuid();
      Reference ref = FirebaseStorage.instance
          .ref()
          .child(entryType == "post"
              ? "sharedUserImagesPost"
              : entryType == "comment"
                  ? "sharedUserImagesComments"
                  : "sharedUserImagesChat")
          .child(auth.currentUser!.uid)
          .child("${uuid.v4()}.jpg");
      await ref.putFile(selectedA);
      imageUrl = await ref.getDownloadURL();
    }

    List messageArray = messageController.text.split(" ");
    if (messageController.text.length == 1) {
      messageArray.add(messageController.text);
    }
    for (String element in messageArray) {
      if (element.startsWith("http")) {
        type.add("url");
        url = element;
        isLaunchMode = true;
      }
    }
    final currentUserData =
        await firestore.collection("Users").doc(auth.currentUser!.uid).get();
    Map<String, dynamic> entry = {
      entryType == "comment"
          ? "commentText"
          : entryType == "post"
              ? "postText"
              : "message": messageController.text,
      "link": url,
      "owner": currentUserData["name"],
      "userId": FirebaseAuth.instance.currentUser!.uid,
      "createdAt": Timestamp.now(),
      "userImage": currentUserData["imageUrl"],
      "imageFromUser": imageUrl,
      "messageType": type
    };
    if (entryType == "comment") {
      await FirebaseFirestore.instance
          .collection("postCollection")
          .doc(categoryName)
          .collection("posts")
          .doc(postId)
          .collection("comments")
          .doc()
          .set(entry);
    }
    if (entryType == "chat") {
      await firestore
          .collection("chat")
          .doc(chatId)
          .collection("chatMessages")
          .doc()
          .set(entry);
    }
    if (entryType == "post") {
      await firestore
          .collection("postCollection")
          .doc(categoryName)
          .collection("posts")
          .doc()
          .set(entry);
    }
  }
}
