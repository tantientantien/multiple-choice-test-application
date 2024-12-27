import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class HandleImage {
  Image AutoRenderImageDefault(String backGround) {
    try {
      if (backGround.isEmpty) {
        return Image.asset(
          'assets/images/background/sub_bgr_3.png',
          fit: BoxFit.cover,
        );
      } else {
        return Image.network(
          backGround,
          fit: BoxFit.cover,
        );
      }
    } catch (e) {
      print('Lỗi khi tải hình từ Firebase: $e');

      return Image.asset(
        'assets/images/background/sub_bgr_3.png',
        fit: BoxFit.cover,
      );
    }
  }

  Future<String?> pickMedia(bool isVideo) async {
    final picker = ImagePicker();
    try {
      final media = isVideo
          ? await picker.pickVideo(source: ImageSource.gallery)
          : await picker.pickImage(source: ImageSource.gallery);

      if (media != null) {
        return media.path;
      } else {
        return null;
      }
    } catch (e) {
      print('Error picking media: $e');
      return null;
    }
  }

  Future<String?> uploadImageToFirebase(
      String imagePath, String folderRef) async {
    Reference storageReference = FirebaseStorage.instance.ref().child(
        '$folderRef/${DateTime.now().millisecondsSinceEpoch.toString()}_${FirebaseAuth.instance.currentUser?.uid}');
    UploadTask uploadTask = storageReference.putFile(File(imagePath));
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
