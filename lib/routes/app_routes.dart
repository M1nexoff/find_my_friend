import 'package:get/get.dart';
import '../views/splash_screen.dart';
import '../views/login_screen.dart';
import '../views/register_screen.dart';
import '../views/profile_screen.dart';
import '../views/map_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const profile = '/profile';
  static const map = '/map';

  static List<GetPage> routes = [
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: register, page: () => RegisterScreen()),
    // GetPage(name: profile, page: () => ProfileScreen()),
    GetPage(name: map, page: () => MapScreen()),
  ];
}
