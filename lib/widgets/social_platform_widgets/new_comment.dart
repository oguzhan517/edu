import 'package:edu/helpers/image_picker_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../helpers/add_new_entry.dart';
import 'dart:io';

class NewComment extends StatefulWidget {
  const NewComment(
      {super.key, required this.postId, required this.categoryName});
  final String categoryName;
  final String postId;

  @override
  State<NewComment> createState() => _NewCommentState();
}

class _NewCommentState extends State<NewComment> {
  final controllerComment = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  dynamic imageFile = "not picked";

  bool isLaunchMode = false;

  Future<void> addNewComment() async {
    await AddNewEntry.addNewMessage("", imageFile, isLaunchMode,
        controllerComment, "comment", widget.categoryName, widget.postId);
    setState(() {
      imageFile = "not picked";
    });
    controllerComment.text = "";
    controllerComment.clear();
  }

  Future<void> imagePick() async {
    final pickedImage = await ImagePickerHelper.pickAnImage("camera");
    if (!mounted) return;
    setState(() {
      imageFile = File(pickedImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        Row(children: [
          Expanded(
            child: TextField(
              controller: controllerComment,
              decoration: const InputDecoration(labelText: "Yorum yaz..."),
            ),
          ),
          IconButton(onPressed: imagePick, icon: const Icon(Icons.image)),
          IconButton(onPressed: addNewComment, icon: const Icon(Icons.check))
        ]),
        if (imageFile != "not picked")
          const SizedBox(
            height: 10,
          ),
        if (imageFile != "not picked")
          SizedBox(
            height: 60,
            width: 60,
            child: Image.file(
              imageFile,
              fit: BoxFit.cover,
            ),
          ),
      ],
    );
  }
}
