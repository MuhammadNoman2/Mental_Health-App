import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImageFromGallery() async {
    var storagePermissionStatus = await Permission.storage.request(); // Request storage permission
    if (storagePermissionStatus.isGranted) {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
    } else {
      Get.snackbar('Error', 'Permission Denied');
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
