import 'package:find_my_friend/main.dart';
import 'package:flutter/material.dart';
import 'package:find_my_friend/controllers/map_controller.dart';
import 'package:find_my_friend/data/models/user_model.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'make_profile.dart';
import 'map_screen.dart';
import 'login_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  final MapController controller = Get.put(MapController());

  HomeScreen({super.key});

  void showLeaveDialog(BuildContext context) {
    Get.defaultDialog(
      title: "Leave Application",
      middleText: "Are you sure you want to leave?",
      textCancel: "Cancel",
      textConfirm: "Leave",
      confirmTextColor: Colors.white,
      onConfirm: () {
        controller.userRepository.logOutUser();
        Get.offAll(() => LoginScreen());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.sunny),
            onPressed: () {
              if (themeProvider.themeData == ThemeData.light()) {
                themeProvider.setThemeData(ThemeData.dark());
              } else {
                themeProvider.setThemeData(ThemeData.light());
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () => Get.to(() => MapScreen()),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () async {
              Get.to(MakeProfile(userModel: await controller.userRepository.getUser()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => showLeaveDialog(context),
          ),
        ],
      ),
      body: StreamBuilder<List<UserModel>>(
        stream: controller.getUsersProfiles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data;

          if (users == null || users.isEmpty) {
            return const Center(
              child: Text(
                "No Users Available",
                style: TextStyle(fontSize: 18.0),
              ),
            );
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: GestureDetector(
                  onTap: () => Get.to(() => ProfileScreen(user: user)),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(user.imageUrl ?? ''),
                  ),
                ),
                title: Text(user.name ?? "Unknown"),
                subtitle: Text(user.email ?? "No Email"),
                onTap: () => Get.to(() => MapScreen(userModel: user)),
              );
            },
          );
        },
      ),
    );
  }
}
