import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mental_health_app/controllers/authController.dart';
import 'package:mental_health_app/utils/widgets/personInfo_form.dart';

import '../../services/userService.dart';
import '../../utils/widgets/image_picker.dart';

final AuthController authController = Get.put(AuthController());
class ProfileScreen extends StatelessWidget {
   ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F0FE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Profile",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(context),
                const SizedBox(height: 20),
               _buildPersonalInfoSection(),
                const SizedBox(height: 20),
                _buildSettingsSection(),
                const SizedBox(height: 20),
                _buildLogoutButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Center(
      child: Column(
        children: [
        Obx(() => CircleAvatar(
          radius: 50,
          backgroundImage: authController.profileImage.value.isEmpty
              ? const AssetImage('assets/images/avatar_person.png')
              : FileImage(File(authController.profileImage.value)) as ImageProvider,
                ),
        ),
          const SizedBox(height: 10),
          Text(
            "${authController.userName.value}",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Obx(() {
            if (authController.isGoogleSignIn.value) {
              return Image.asset('assets/images/google_sign.png', height: 20);
            }
            return Text(
              "${authController.email.value}",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            );
          }),
        ],
      ),
    );
  }

   Widget _buildPersonalInfoSection() {

     return Obx(() {
       return Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           const Text(
             "Personal Information",
             style: TextStyle(
               fontSize: 18,
               fontWeight: FontWeight.bold,
               color: Colors.black,
             ),
           ),
           const SizedBox(height: 10),
           _buildInfoTile(Icons.cake, "Date of Birth", authController.dateOfBirth.value),
           const Divider(color: Colors.grey),
           _buildInfoTile(Icons.male, "Gender", authController.gender.value),
           const Divider(color: Colors.grey),
           _buildInfoTile(Icons.phone, "Phone Number", authController.phoneNumber.value),
         ],
       );
     });
   }

   Widget _buildInfoTile(IconData icon, String title, String value) {
     return ListTile(
       contentPadding: EdgeInsets.zero,
       leading: Icon(icon, color: Colors.blue),
       title: Text(
         title,
         style: const TextStyle(
           fontSize: 16,
           fontWeight: FontWeight.bold,
           color: Colors.black,
         ),
       ),
       subtitle: Text(
         value,
         style: const TextStyle(
           fontSize: 14,
           color: Colors.grey,
         ),
       ),
     );
   }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Settings",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        _buildSettingTile(CupertinoIcons.profile_circled, "Update Profile", Colors.purple, ()=> Get.to((UpdateProfileScreen()))),
        _buildSettingTile(Icons.palette, "Appearance", Colors.orange,  ()=> Get.to((UpdateProfileScreen()))),
        _buildSettingTile(Icons.notifications, "Notifications", Colors.green, ()=> Get.to((UpdateProfileScreen()))),
        _buildSettingTile(Icons.privacy_tip, "Privacy Policy", Colors.red, ()=> Get.to((UpdateProfileScreen()))),
      ],
    );
  }

   Widget _buildSettingTile(IconData icon, String title, Color iconColor, VoidCallback onTap) {
     return ListTile(
       contentPadding: EdgeInsets.zero,
       leading: Icon(icon, color: iconColor),
       title: Text(
         title,
         style: const TextStyle(
           fontSize: 16,
           fontWeight: FontWeight.bold,
           color: Colors.black,
         ),
       ),
       trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
       onTap: onTap, // Passing the onTap action
     );
   }


  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: Colors.red[50],
                title: const Text("Logout"),
                content: const Text("Are you sure you want to logout?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      authController.logoutUser();
                    },
                    child: const Text("Logout"),
                  ),
                ],
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[100],
            minimumSize: Size(300, 50),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: const Text(
            "Logout",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
