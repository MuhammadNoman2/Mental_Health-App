import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
                // Profile Header
                _buildProfileHeader(),
                const SizedBox(height: 20),
                // Personal Info Section
                _buildPersonalInfoSection(),
                const SizedBox(height: 20),
                // Settings Section
                _buildSettingsSection(),
                const SizedBox(height: 20),
                // Logout Button
                _buildLogoutButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          // Profile Picture
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blue, width: 2),
              image: const DecorationImage(
                image: AssetImage('assets/images/img_7.png'), // Replace with your asset
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 10),
          // User Name
          const Text(
            "Muhammad Umair",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          // User Email
          const Text(
            "m.umair123@example.com",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
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
        _buildInfoTile(Icons.cake, "Date of Birth", "12th June 1995"),
        const Divider(color: Colors.grey),
        _buildInfoTile(Icons.male, "Gender", "Male"),
        const Divider(color: Colors.grey),
        _buildInfoTile(Icons.phone, "Phone Number", "+1 234 567 890"),
      ],
    );
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
        _buildSettingTile(Icons.lock, "Change Password", Colors.purple),
        _buildSettingTile(Icons.palette, "Appearance", Colors.orange),
        _buildSettingTile(Icons.notifications, "Notifications", Colors.green),
        _buildSettingTile(Icons.privacy_tip, "Privacy Policy", Colors.red),
      ],
    );
  }

  Widget _buildSettingTile(IconData icon, String title, Color iconColor) {
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
      onTap: () {
        // Handle settings tap
      },
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            // Handle logout
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
                      // Redirect to login screen
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
