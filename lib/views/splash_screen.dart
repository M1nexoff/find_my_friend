import 'package:find_my_friend/routes/app_routes.dart';
import 'package:find_my_friend/views/home_screen.dart';
import 'package:find_my_friend/views/make_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import 'login_screen.dart';
import 'map_screen.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final AuthController authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward().then((_) => _checkLogin());
  }

  void _checkLogin() async {
    await Future.delayed(const Duration(seconds: 1));
    if (authController.isLogined()) {
      if (await authController.checkProfile() == "Success") {
        Get.off(HomeScreen());
      }else{
        Get.offAll(MakeProfile());
      }
    } else {
      Get.off(LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Image.asset('assets/images/logo.png',width: 200,height: 200,),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
