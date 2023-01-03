import 'package:edu/models/screen_arguments.dart';
import 'package:edu/widgets/chat_widgets/message_bubble.dart';
import 'package:flutter/material.dart';
import '../../widgets/chat_widgets/new_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});
  static const routeName = "/messageScreen";

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  var fireStore = FirebaseFirestore.instance;
  String name = "";
  bool init = true;

  @override
  Future<void> didChangeDependencies() async {
    if (init == true) {
      final args =
          ModalRoute.of(context)!.settings.arguments as ScreenArguments;
      final userData =
          await fireStore.collection("Users").doc(args.otherId).get();
      setState(() {
        name = userData["name"];
      });
    }
    init = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: Text(name),
        ),
        body: SingleChildScrollView(
          reverse: true,
          child: Column(
            children: [
              StreamBuilder(
                  stream: fireStore
                      .collection("chat")
                      .doc(args.chatId)
                      .collection("chatMessages")
                      .orderBy("createdAt", descending: true)
                      .snapshots(),
                  builder: ((context, snapshot) {
                    if (!snapshot.hasData) {
                      const Center(
                        child: Text("Henüz gönderilmiş bir mesaj yok."),
                      );
                    }

                    if (snapshot.hasData) {
                      return SizedBox(
                        height: deviceHeight - 100,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: ((context, index) {
                            final message = snapshot.data!.docs[index];
                            return MessageBubble(
                              singleMessage: message,
                            );
                          }),
                          reverse: true,
                        ),
                      );
                    }

                    return SizedBox(
                      height: deviceHeight - 100,
                      child: const Center(
                        child: Text("henüz bir mesaj gönderilmedi"),
                      ),
                    );
                  })),
              NewMessage(
                chatId: args.chatId,
                authId: args.authId,
                name: args.name,
              ),
            ],
          ),
        ));
  }
}
