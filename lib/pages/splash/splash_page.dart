import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_food_delivery/routes/route_helper.dart';
import 'package:mobile_food_delivery/utils/dimensions.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    // todo controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    // todo controller.forward();
    // ! cannot use controller = AnimationController(vsync: this, duration: const Duration(seconds: 2)).forward();
    // ! because controller.forward(); return TickerFuture object, not AnimateController object.
    controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..forward();
    animation = CurvedAnimation(parent: controller, curve: Curves.linear);
    Timer(
      const Duration(seconds: 3),
      // * unlike Get.toNamed()
      // * Get.offNamed() removes SplashPage from navigation stack
      // * which means cannot go back to SplashPage from Get.back() or swipe screen
      () => Get.offNamed(RouteHelper.getLogin()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: animation,
            child: Center(
              child: Image.asset(
                "assets/image/logo_part_1.png",
                width: Dimensions.splashImage,
              ),
            ),
          ),
          Center(
            child: Image.asset(
              "assets/image/logo part 2.png",
              width: Dimensions.splashImage,
            ),
          ),
        ],
      ),
    );
  }
}
