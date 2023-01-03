
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu/models/user_model.dart';

class StorageHelper {
  final fireStore = FirebaseFirestore.instance;
  Future<void> addData(UserModel user) async {
    fireStore.collection("Users").doc(user.id).set({
      "email": user.email,
      "description": user.description,
      "imageUrl": user.imageDownloadUrl,
      "name": user.name,
      "yetkinlik": user.isStudent == true ? "öğrenci" : "öğretmen"
    });
  }
}