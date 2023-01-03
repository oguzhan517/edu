import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu/widgets/chat_widgets/single_user.dart';
import 'package:flutter/material.dart';

class PersonsScreen extends StatefulWidget {
  const PersonsScreen({super.key});
  static const routeName = "/Persons";

  @override
  State<PersonsScreen> createState() => _PersonsScreenState();
}

class _PersonsScreenState extends State<PersonsScreen> {
  bool init = true;

  @override

  // Bu kısımda image derhal gösterilmeli. Düzelt...

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Users").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: ((context, index) {
                  return SingleUser(user: snapshot.data!.docs[index]);
                }));
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
