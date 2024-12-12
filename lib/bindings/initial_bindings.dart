
import 'package:find_my_friend/data/domain/repository.dart';
import 'package:get/get.dart';

class InitialBindings extends Bindings{
  @override
  void dependencies() {
    Get.put(UserRepository());
  }
}