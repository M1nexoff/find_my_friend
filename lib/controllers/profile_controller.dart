
import 'dart:math';

import 'package:cross_file/cross_file.dart';
import 'package:find_my_friend/data/domain/repository.dart';
import 'package:find_my_friend/data/models/user_model.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController{
  UserRepository repository = Get.find();

  Future<String> createProfile(UserModel userModel) async {
    userModel.name = userModel.name?.trim();
    if(userModel.latitude == null||userModel.longitude == null){
      return "Location is required!";
    }
    if(userModel.name == null){
      return "Name must be filled!";
    }
    if(userModel.name!.length < 3){
      return "Name must be more than 3 characters";
    }
    if(userModel.name!.contains(' ')){
      return "Name must be without space!";
    }
    return repository.createProfile(userModel);
  }

  Future<String> uploadImage(XFile pickedFile) async {
    return await repository.uploadImage(pickedFile);
  }

  Future<String> updateProfile(UserModel userModel) async {
    userModel.name = userModel.name?.trim();
    if(userModel.latitude == null||userModel.longitude == null){
      return "Location is required!";
    }
    if(userModel.name == null){
      return "Name must be filled!";
    }
    if(userModel.name!.length < 3){
      return "Name must be more than 3 characters";
    }
    if(userModel.name!.contains(' ')){
      return "Name must be without space!";
    }
    return repository.updateProfile(userModel);
  }

}