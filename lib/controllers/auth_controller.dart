import 'dart:io';
import 'package:find_my_friend/data/domain/repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../data/models/user_model.dart';

class AuthController extends GetxController {
  final UserRepository authRepository = Get.find();

  bool isLogined() {
    return authRepository.isLogined();
  }

  Future<String> login(String email, String password) async {
    return await authRepository.login(email, password);
  }

  Future<String> register(String email, String password) async {
    return await authRepository.register(email, password);
  }

  Future<String> checkProfile() async {
    return await authRepository.checkUser();
  }
}
