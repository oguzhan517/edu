import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu/models/screen_arguments.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../screens/chat_screens/message_screen.dart';

class SingleUser extends StatefulWidget {
  const SingleUser({super.key, required this.user});
  final QueryDocumentSnapshot<Map<String, dynamic>> user;

  @override
  State<SingleUser> createState() => _SingleUserState();
}

class _SingleUserState extends State<SingleUser> {
  Future<void> onClick() async {
    final navigator = Navigator.of(context);
    String chatId = "";
    String authId = FirebaseAuth.instance.currentUser!.uid;
    if (authId.hashCode <= widget.user.id.hashCode) {
      chatId = "$authId - ${widget.user.id}";
    } else {
      chatId = "${widget.user.id} - $authId";
    }
    var ids = chatId.split(" - ");
    String otherId = ids.firstWhere((element) => element != authId);
    // ignore: use_build_context_synchronously
    navigator.pushNamed(MessageScreen.routeName,
        arguments: ScreenArguments(
            chatId: chatId, authId: authId, name: widget.user["name"], otherId: otherId));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.user.id == FirebaseAuth.instance.currentUser!.uid) {
      return const SizedBox.shrink();
    }
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(widget.user["imageUrl"]),
      ),
      title: Text(widget.user["name"]),
      subtitle: Text(widget.user["description"]),
      onTap: () => onClick(),
    );
  }
}
