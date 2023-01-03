import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  static Future<dynamic> pickAnImage(String type) async {
    final ImagePicker picker = ImagePicker();
    XFile? pickedImage = await picker.pickImage(
        source: type == "gallery" ? ImageSource.gallery : ImageSource.camera);
    if (pickedImage == null) {
      return "not picked";
    } else {
      return pickedImage;
    }
  }
}
