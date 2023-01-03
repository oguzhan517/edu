import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../helpers/image_picker_helper.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class EditInfosScreen extends StatefulWidget {
  const EditInfosScreen({super.key});
  static const routeName = "/editprofile";
  @override
  State<EditInfosScreen> createState() => _EditInfosScreenState();
}

class _EditInfosScreenState extends State<EditInfosScreen> {
  final _formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  bool init = true;
  dynamic _storedImage = "not picked";
  bool updatePassword = false;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Map<String, String> initValues = {
    "name": "",
    "imageUrl": "",
    "description": "",
  };
  Map<String, String> newValues = {
    "name": "",
    "imageUrl": "",
    "description": "",
  };

  @override
  Future<void> didChangeDependencies() async {
    if (init == true) {
      String userId = auth.currentUser!.uid;
      var userData = await firestore.collection("Users").doc(userId).get();
      setState(() {
        initValues["name"] = userData["name"];
        initValues["description"] = userData["description"];
        initValues["imageUrl"] = userData["imageUrl"];
      });
      _nameController.text = initValues["name"]!;
      _descriptionController.text = initValues["description"]!;
    }

    super.didChangeDependencies();
    init = false;
  }

  Future<void> pickAnImage() async {
    dynamic selectedImage = await ImagePickerHelper.pickAnImage("camera");
    if (selectedImage != "not picked") {
      setState(() {
        _storedImage = File(selectedImage.path);
      });
    } else {
      return;
    }
  }

  Future<void> saveForm() async {
    final navigator = Navigator.of(context);
    final validated = _formKey.currentState!.validate();
    if (!validated) {
      return;
    } else {
      _formKey.currentState!.save();
    }
    if (_storedImage != "not picked") {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child("userImages")
          .child("${auth.currentUser!.uid}.jpg");
      await ref.putFile(_storedImage);
      newValues["imageUrl"] = await ref.getDownloadURL();
    }
    firestore.collection("Users").doc(auth.currentUser!.uid).update({
      "name": newValues["name"],
      "description": newValues["description"],
      "imageUrl": newValues["imageUrl"] == ""
          ? initValues["imageUrl"]
          : newValues["imageUrl"],
    });
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Sayfası"),
        actions: [
          IconButton(
              onPressed: saveForm,
              icon: const Icon(
                Icons.save,
                color: Colors.white,
              ))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(36),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                radius: 40,
                backgroundImage: _storedImage != "not picked"
                    ? FileImage(_storedImage!)
                    : initValues["imageUrl"] != ""
                        ? NetworkImage(initValues["imageUrl"]!) as ImageProvider
                        : null,
              ),
              TextButton.icon(
                  onPressed: pickAnImage,
                  icon: Icon(
                    Icons.camera,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  label: Text(
                    "Fotoğrafı güncelle",
                    style: TextStyle(color: Theme.of(context).primaryColorDark),
                  )),
              TextFormField(
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Bu alan boş bırakılamaz";
                  }
                  return null;
                },
                onSaved: (newValue) {
                  newValues["name"] = newValue.toString();
                },
              ),
              TextFormField(
                controller: _descriptionController,
                onSaved: (newValue) {
                  newValues["description"] = newValue.toString();
                },
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                  onPressed: () async {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Theme.of(context).primaryColorDark,
                        content: const Text(
                          "Şifre sıfırlama e postası gönderildi.",
                          style: TextStyle(color: Colors.white),
                        )));
                    await FirebaseAuth.instance.setLanguageCode("tr");
                    await FirebaseAuth.instance.sendPasswordResetEmail(
                        email: auth.currentUser!.email.toString());
                  },
                  child: const Text(
                    "Şifreyi güncelle",
                    style: TextStyle(color: Colors.white),
                  )),
              const Text(
                "Giriş yaptığınız e-postanıza gelen linke tıklayarak şifrenizi güncelleyebilirsiniz.",
                style: TextStyle(color: Colors.grey, fontSize: 12),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
