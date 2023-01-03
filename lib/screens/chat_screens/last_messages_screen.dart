import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'message_screen.dart';
import '../../models/screen_arguments.dart';

class LastMessagesScreen extends StatefulWidget {
  const LastMessagesScreen({super.key});

  @override
  State<LastMessagesScreen> createState() => _LastMessagesScreenState();
}

class _LastMessagesScreenState extends State<LastMessagesScreen> {
  bool init = true;
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: firestore
            .collection("chat")
            .orderBy("createdAt", descending: true)
            .where("participants", arrayContains: auth.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshotChat) {
          if (snapshotChat.hasData && snapshotChat.data!.size == 0) {
            return const Center(
              child: Text("Son görüşmeler burada yer alacaktır"),
            );
          }
          if (snapshotChat.hasData) {
            return ListView.builder(
                physics: const ScrollPhysics(),
                itemCount: snapshotChat.data!.docs.length,
                itemBuilder: (context, index) {
                    List<String> ids =
                        snapshotChat.data!.docs[index].id.split(" - ");
                    final otherUserId = ids.firstWhere(
                      (element) => element != auth.currentUser!.uid,
                    );
                    return StreamBuilder(
                      stream: firestore
                          .collection("chat")
                          .doc(snapshotChat.data!.docs[index].id)
                          .collection("chatMessages")
                          .orderBy("createdAt", descending: false)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final lastMessage = snapshot
                              .data!.docs[snapshot.data!.docs.length - 1];
                          return ListTile(
                            leading: CircleAvatar(
                              radius: 22,
                              backgroundImage:
                                  NetworkImage(lastMessage["userImage"]),
                            ),
                            title: Text(
                              "${lastMessage["owner"]} :",
                              style: TextStyle(
                                  color: lastMessage["userId"] ==
                                          FirebaseAuth.instance.currentUser!.uid
                                      ? Colors.black
                                      : Colors.blue),
                            ),
                            subtitle: (lastMessage["messageType"]
                                    .contains("image"))
                                ? Text(
                                    "Ekran görüntüsü paylaşıldı.",
                                    style: TextStyle(
                                        color:
                                            Theme.of(context).primaryColorDark),
                                  )
                                : Text(
                                    lastMessage["message"],
                                    overflow: TextOverflow.ellipsis,
                                  ),
                            onTap: (() async {
                              Navigator.of(context).pushNamed(
                                  MessageScreen.routeName,
                                  arguments: ScreenArguments(
                                    chatId: snapshotChat.data!.docs[index].id,
                                    authId:
                                        FirebaseAuth.instance.currentUser!.uid,
                                    name: "hey",
                                    otherId: otherUserId,
                                  ));

                              await firestore
                                  .collection("chat")
                                  .doc(snapshotChat.data!.docs[index].id)
                                  .update({"createdAt": Timestamp.now()});
                            }),
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );
                  
                
                });
          }
          if (snapshotChat.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return const Center(
              child: Text("Son mesajlaşma eklendiğinde burada yer alır."));
        });
  }
}
