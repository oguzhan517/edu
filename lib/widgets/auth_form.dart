import 'package:edu/helpers/auth_helper.dart';
import 'package:edu/widgets/chat_widgets/bottom_navigation.dart';
import 'package:edu/widgets/image_picker_camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';


class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  bool signinMode = false;
  final _formKey = GlobalKey<FormState>();
  File? _storedImage;
  String email = "";
  String password = "";
  String name = "";
  bool isStudent = true;

  void saveFromPicker(File image) {
    _storedImage = image;
  }

  Future<void> saveForm() async {
    final navigator = Navigator.of(context);
    final validate = _formKey.currentState!.validate();
    if (!validate) return;
    _formKey.currentState!.save();
    if (signinMode == false) {
      await AuthHelper()
          .signUp(email, password, _storedImage!, name, isStudent);
    } else {
      await AuthHelper().signIn(email, password);
    }
    navigator.pushReplacementNamed(BottomNavigation.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            width: deviceSize.width,
            height: deviceSize.height,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
            margin: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30,
                ),
                if (signinMode == false)
                  ImagePickerCamera(savePicker: saveFromPicker),
                const SizedBox(
                  height: 26,
                ),
                if (signinMode == false)
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: "İsim soy isim"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Bu alan boş bırakılamaz";
                      }

                      return null;
                    },
                    onSaved: (newValue) {
                      name = newValue!;
                    },
                  ),
                if (signinMode == false)
                  Row(
                    children: [
                      Switch(
                        inactiveThumbColor: Theme.of(context).primaryColorDark,
                        inactiveTrackColor: Theme.of(context).primaryColor,
                        value: isStudent,
                        onChanged: (value) => setState(() {
                          isStudent = value;
                        }),
                      ),
                      Text(isStudent == true ? "Öğrenci" : "Öğretmen")
                    ],
                  ),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: "Email adresinizi giriniz."),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Bu alan boş bırakılamaz";
                    }

                    return null;
                  },
                  onSaved: (newValue) {
                    email = newValue!;
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: "Şifrenizi giriniz."),
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Bu alan boş bırakılamaz";
                    }
                    if (value.length < 5) {
                      return "Şifre en az 5 karakter olmalıdır.";
                    }

                    return null;
                  },
                  onSaved: (newValue) {
                    password = newValue!;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    TextButton.icon(
                        onPressed: () {
                          setState(() {
                            signinMode = !signinMode;
                          });
                        },
                        icon: const Icon(Icons.arrow_forward),
                        label: Text(signinMode == false
                            ? "Zaten hesabım var"
                            : "Yeni hesap")),
                    const Spacer(),
                    ElevatedButton.icon(
                        onPressed: saveForm,
                        icon: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                        label: Text(
                          signinMode == true ? "Giriş yap" : "Kayıt ol",
                          style: const TextStyle(color: Colors.white),
                        )),
                    const SizedBox(
                      width: 4,
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
