import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu/helpers/add_new_entry.dart';
import 'package:edu/helpers/image_picker_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class NewPost extends StatefulWidget {
  const NewPost({super.key, required this.categoryName});
  final String categoryName;
  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  TextEditingController controllerPost = TextEditingController();
  var firestore = FirebaseFirestore.instance;
  var auth = FirebaseAuth.instance;
  dynamic imageFile = "not picked";
  Future<void> sendPost() async {
    // if (auth.currentUser!.emailVerified == true) {
    await AddNewEntry.addNewMessage(
        "", imageFile, false, controllerPost, "post", widget.categoryName, "");
    /* } 
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(" Bu özellik e-mail  ")));
    } */
    setState(() {
      imageFile = "not picked";
    });

    controllerPost.text = "";
    controllerPost.clear();
  }

  Future<void> pickAnImage() async {
    final newImage = await ImagePickerHelper.pickAnImage("camera");
    if (!mounted) return;
    if (newImage != "not picked") {
      setState(() {
        imageFile = File(newImage.path);
      });
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColorLight,
      child: Column(
        children: [
          if (imageFile != "not picked")
            Container(
              height: 150,
              margin: const EdgeInsets.all(8),
              child: Image.file(
                File(imageFile.path),
                fit: BoxFit.cover,
              ),
            ),
          Row(
            children: [
              Expanded(
                  child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: 2,
                controller: controllerPost,
                decoration: const InputDecoration(
                    labelText: " İlgili sorunuzu burada paylaşın."),
              )),
              IconButton(
                  onPressed: pickAnImage,
                  icon: Icon(
                    Icons.image,
                    color: Theme.of(context).primaryColor,
                  )),
              IconButton(
                  onPressed: sendPost,
                  icon: Icon(
                    Icons.send,
                    color: Theme.of(context).primaryColor,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
