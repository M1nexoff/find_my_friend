
import 'package:find_my_friend/data/domain/repository.dart';
import 'package:find_my_friend/data/models/user_model.dart';
import 'package:get/get.dart';

class MapController extends GetxController{
  UserRepository userRepository = Get.find();

  Stream<List<UserModel>> getUsersProfiles(){
    return userRepository.getProfiles();
  }
}