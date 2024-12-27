import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Handle_Images {
  Future<String> get_image_question_set(String filename) async {
    String url = await FirebaseStorage.instance
        .ref('question_set_image/$filename')
        .getDownloadURL();
    return url;
  }
}
