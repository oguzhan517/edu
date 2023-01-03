import 'package:flutter/material.dart';
import '../helpers/image_picker_helper.dart';
import 'dart:io';

class ImagePickerCamera extends StatefulWidget {
  const ImagePickerCamera({super.key, required this.savePicker});
  final Function savePicker;
  @override
  State<ImagePickerCamera> createState() => _ImagePickerCameraState();
}

class _ImagePickerCameraState extends State<ImagePickerCamera> {
  File? _storedImage;
  Future<void> _pickanImage(String type) async {
    final selected = await ImagePickerHelper.pickAnImage(type);
    if (selected == "not picked") {
      return;
    } else {
      widget.savePicker(File(selected.path));
      setState(() {
        _storedImage = File(selected.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          radius: 40,
          backgroundImage:
              _storedImage != null ? FileImage(_storedImage!) : null,
        ),
        const SizedBox(
          height: 12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
                onPressed: () => _pickanImage("gallery"),
                icon: const Icon(Icons.forward),
                label: const Text("From Gallery")),
            TextButton.icon(
                onPressed: () => _pickanImage("camera"),
                icon: const Icon(Icons.forward),
                label: const Text("From Camera"))
          ],
        ),
      ],
    );
  }
}
