import 'package:edu/helpers/add_new_entry.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../helpers/image_picker_helper.dart';
import 'dart:io';

class NewMessage extends StatefulWidget {
  const NewMessage(
      {super.key,
      required this.chatId,
      required this.authId,
      required this.name});
  final String chatId;
  final String authId;
  final String name;

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  String type = "normal";

  var messageController = TextEditingController();

  var firestore = FirebaseFirestore.instance;

  var auth = FirebaseAuth.instance;

  String url = "";

  dynamic selectedA = "not picked";

  bool isLaunchMode = false;

  Future<dynamic> pickAnImage() async {
    type = "image";
    final dynamic selected = await ImagePickerHelper.pickAnImage("camera");
    if (!mounted) return;
    setState(() {
      selectedA = File(selected.path);
    });
  }

  Future<void> addNewMessage() async {
    await AddNewEntry.addNewMessage(widget.chatId, selectedA, isLaunchMode,
        messageController, "chat", "", "");
    setState(() {
      selectedA = "not picked";
    });
    messageController.text = "";
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        Row(
          children: [
            Expanded(
                child: TextField(
              controller: messageController,
            )),
            IconButton(
                onPressed: () => pickAnImage(), icon: const Icon(Icons.camera)),
            IconButton(
                color: isLaunchMode == true ? Colors.blue : Colors.black,
                onPressed: () {
                  setState(() {
                    isLaunchMode = !isLaunchMode;
                  });
                },
                icon: const Icon(Icons.launch)),
            IconButton(onPressed: addNewMessage, icon: const Icon(Icons.send)),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        if (selectedA != "not picked")
          SizedBox(
            height: 150,
            width: 150,
            child: Image.file(
              selectedA,
              fit: BoxFit.cover,
            ),
          ),
      ],
    );
  }
}
