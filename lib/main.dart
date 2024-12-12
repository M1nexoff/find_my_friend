import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yandex_maps_mapkit_lite/init.dart';
import 'bindings/initial_bindings.dart';
import 'routes/app_routes.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  Repository.prefs = await SharedPreferences.getInstance();
  await initMapkit(
      apiKey: 'a3a6e137-8f0e-47b8-a3fb-ff9656d8412b'
  );
  await Firebase.initializeApp();
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return GetMaterialApp(
      theme: themeProvider.themeData,
      initialBinding: InitialBindings(),
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.routes,
    );
  }
}

class ThemeProvider extends ChangeNotifier {
  Repository impl = Repository();
  ThemeProvider(){
    _themeData = impl.getTheme()?ThemeData.dark():ThemeData.light();
    notifyListeners();
  }

  ThemeData _themeData = ThemeData.light();

  ThemeData get themeData => _themeData;

  void setThemeData(ThemeData themeData) {
    _themeData = themeData;
    impl.setTheme(themeData == ThemeData.dark());
    notifyListeners();
  }
}

class Repository  {
  static SharedPreferences? prefs;

  void setTheme(bool isDarkMode)  {
    prefs?.setBool('is_dark_mode', isDarkMode);
  }

  bool getTheme()  {
    return prefs?.getBool('is_dark_mode') ?? false; // Default to light theme
  }
}

