import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_food_delivery/controllers/auth_controller.dart';
import 'package:mobile_food_delivery/controllers/popular_dish_controller.dart';
import 'package:mobile_food_delivery/routes/route_helper.dart';
import 'helpers/dependencies.dart' as dep;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dep.init();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    Get.find<AuthController>().loadUserTokenAndAccountId();
    // * use GetX library to call the controller that injected in dependencies,
    // * then call the method of that controller
    return GetBuilder<PopularProductController>(builder: (_) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: RouteHelper.getSplashPage(),
        getPages: RouteHelper.routes,
      );
    });
  }
}
