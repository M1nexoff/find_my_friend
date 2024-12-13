import 'package:find_my_friend/views/home_screen.dart';
import 'package:find_my_friend/views/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';
import '../main.dart';
import 'make_profile.dart';

class LoginScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthController authController = AuthController();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text("Login",style: TextStyle(color: Theme.of(context).colorScheme.onBackground),),
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
          )
        ],
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome Back!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Login to continue",
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 32),

              // Email Input Field
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  color: Colors.white
                ),
                decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: TextStyle(
                    color: Colors.white
                  ),
                  prefixIcon: Icon(Icons.email_outlined,color: Colors.white,),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.2),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 12.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Password Input Field
              TextField(
                controller: passwordController,
                obscureText: true,
                style: TextStyle(
                  color: Colors.white
                ),
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: TextStyle(
                      color: Colors.white
                  ),
                  prefixIcon: Icon(Icons.lock_outline,color: Colors.white,),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.2),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 12.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  onPressed: () async {
                    String result = await authController.login(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    );
                    if (result != "Success") {
                      Get.snackbar("Error", result,
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white);
                    } else {
                      if (await authController.checkProfile() == "Success") {
                        Get.off(HomeScreen());
                      } else {
                        Get.offAll(MakeProfile());
                      }
                    }
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Register Navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onBackground),
                  ),
                  TextButton(
                    onPressed: () => Get.to(RegisterScreen()),
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
