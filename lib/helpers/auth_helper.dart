import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:edu/models/user_model.dart';
import 'storage_helper.dart';

class AuthHelper {
  final auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;

  Future<String> signIn(String email, String password) async {
    final credentials =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    return credentials.user!.uid;
  }

  Future<void> signUp(String email, String password, File image, String name,
      bool isStudent) async {
    final credentials = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    Reference ref = storage
        .ref()
        .child("users")
        .child(credentials.user!.uid)
        .child("profilePicture.png");
    await ref.putFile(image);
    String url = await ref.getDownloadURL();
    UserModel user = UserModel(
        id: credentials.user!.uid,
        email: email,
        imageDownloadUrl: url,
        name: name,
        isStudent: isStudent);
    StorageHelper().addData(user);
  }

  Future<void> signout() async {
    await auth.signOut();
  }
}
