import 'dart:convert';
import 'dart:developer';

import 'package:cross_file/cross_file.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import '../models/user_model.dart';

class UserRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final dio.Dio _dio = dio.Dio();

  /// Check if user is logged in
  bool isLogined() => _auth.currentUser != null;

  /// Login with email and password
  Future<String> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return 'Success';
    } catch (e) {
      return e.toString();
    }
  }

  /// Register a new user
  Future<String> register(String email, String password) async {
    // if()Get
    // if (!RegExp(r'^[a-zA-Z0-9]{5,}\$').hasMatch(email.split('@')[0])) {
    //   return 'Name must be at least 5 characters long, letters and numbers only';
    // }
    // if (!RegExp(r'^(?=.*[0-9])(?=\a+\$).{6,}\$').hasMatch(password)) {
    //   return 'Password must be at least 6 characters long, contain numbers, and have no spaces';
    // }
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return 'Success';
    } catch (e) {
      return e.toString();
    }
  }

  /// Stream of user profiles from Firestore
  Stream<List<UserModel>> getProfiles() {
    return _firestore.collection('users').where("email", isNotEqualTo: _auth.currentUser!.email).snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => UserModel.fromMap(doc.id, doc.data())).toList());
  }

  Future<String> checkUser() async {
    try{
      var result = await _firestore.collection('users').where('email',isEqualTo: _auth.currentUser!.email).get();
      if (result.docs.isEmpty) {
        return "Profile not created";
      }
      if(result.docs.first.get('name') == null){
        return "Profile not created";
      }
      return "Success";
    }catch (e){
      return e.toString();
    }
  }
  Future<UserModel?> getUser() async {
    try{
      var result = await _firestore.collection('users').where('email',isEqualTo: _auth.currentUser!.email).get();
      if (result.docs.isEmpty) {
        return null;
      }
      if(result.docs.first.get('name') == null){
        return null;
      }
      return UserModel.fromMap(result.docs.first.id, result.docs.first.data());
    }catch (e){
      return null;
    }
  }

  Future<String> updateProfile(UserModel userModel) async {
    try {
      await _firestore.collection('users').doc(userModel.id).set(userModel.toMap(), SetOptions(merge: true));
      return 'Success';
    } catch (e) {
      return e.toString();
    }
  }
Future<String> createProfile(UserModel userModel) async {
    try {
      userModel.email = _auth.currentUser!.email;
      var result = await _firestore.collection('users').add(userModel.toMap());
      return 'Success';
    } catch (e) {
      return e.toString();
    }
  }

  /// Upload image to imgbb API
  Future<String> uploadImage(XFile file) async {
    const String apiKey = '3ea13ef41a56068047d1d407a9ecd6d2';
    const String uploadUrl = 'https://api.imgbb.com/1/upload';

    try {
      final formData = dio.FormData.fromMap({
        'key': apiKey,
        'image': await dio.MultipartFile.fromFile(file.path),
      });

      final response = await _dio.post(uploadUrl, data: formData);
      if (response.statusCode == 200) {
        return response.data['data']['url'];
      } else {
        return '';
      }
    } catch (e) {
      log(e.toString());
      Get.snackbar("Error", e.toString());
      return '';
    }
  }

  void logOutUser() {
    _auth.signOut();
  }
}
