import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImageFromGallery() async {
    var permissionStatus = await Permission.photos.request();
    if (permissionStatus.isGranted) {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
    }
    return null;
  }

  Future<File?> takePicture() async {
    var cameraPermissionStatus = await Permission.camera.request();
    if (cameraPermissionStatus.isGranted) {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
    }
    return null;
  }
}
