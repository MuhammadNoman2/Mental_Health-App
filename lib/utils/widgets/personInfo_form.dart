import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mental_health_app/screens/Profile/profile.dart';
import 'package:mental_health_app/utils/widgets/custom_button.dart';

import 'image_picker.dart';

class UpdateProfileScreen extends StatefulWidget {
  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final ImagePickerService _imagePickerService = ImagePickerService();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Add Scaffold here
      appBar: AppBar(
        title: const Text("Update Profile"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Optional padding for better spacing
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Obx(() {
                    return CircleAvatar(
                      radius: 65,
                      backgroundImage: authController.profileImage.value.isEmpty
                          ? const AssetImage('assets/images/avatar_person.png')
                          : FileImage(File(authController.profileImage.value)) as ImageProvider,
                    );
                  }),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => _showImagePickerBottomSheet(context),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Date of Birth Field
              _buildInputField(
                controller: dateOfBirthController,
                icon: Icons.cake,
                label: "Date of Birth",
                hint: "Enter your date of birth",
              ),

              const SizedBox(height: 10),
              // Gender Field
              _buildInputField(
                controller: genderController,
                icon: Icons.male,
                label: "Gender",
                hint: "Enter your gender",
              ),
              const SizedBox(height: 10),

              // Phone Number Field
              _buildInputField(
                controller: phoneNumberController,
                icon: Icons.phone,
                label: "Phone Number",
                hint: "Enter your phone number",
              ),
              const SizedBox(height: 30),


              CustomButton(
                onPressed: () {
                  // Save updated personal info
                  authController.savePersonalInfo(
                    dateOfBirthController.text.trim(),
                    genderController.text.trim(),
                    phoneNumberController.text.trim(),
                  );
                },
                isLoading: authController.isLoading.value,
                text: 'Save',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    required String hint,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.blue),
      title: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const UnderlineInputBorder(),
        ),
      ),
    );
  }

  Future<void> _showImagePickerBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Upload from Gallery"),
                onTap: () async {
                  File? image = await _imagePickerService.pickImageFromGallery();
                  if (image != null) {
                    authController.updateProfileImage(image.path);
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Take a Picture"),
                onTap: () async {
                  File? image = await _imagePickerService.takePicture();
                  if (image != null) {
                    authController.updateProfileImage(image.path);
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
