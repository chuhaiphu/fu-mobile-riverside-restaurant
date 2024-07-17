import 'package:get/get.dart';
import 'package:mobile_food_delivery/pages/account/sign_in_page.dart';
import 'package:mobile_food_delivery/pages/food/popular_food_detail.dart';
import 'package:mobile_food_delivery/pages/home/home_page.dart';
import 'package:mobile_food_delivery/pages/splash/splash_page.dart';
import 'package:mobile_food_delivery/pages/table/pick_table.dart';

class RouteHelper {
  static const String splashPage = "/splash-page";
  static const String initial = "/";
  static const String login = "/login";
  static const String logout = "/logout";
  static const String popularFood = "/popular-food";
  static const String recommendedFood = "/recommended-food";
  static const String cartPage = "/cart-page";
  static const String tablePage = "/table-page";
  static String getSplashPage() => '$splashPage';
  static String getPopularFood(int pageId) => '$popularFood?pageId=$pageId';
  static String getInitial() => '$initial';
  static String getLogin() => '$login';
  static String getRecommendedFood(int pageId) => '$recommendedFood?pageId=$pageId';
  static String getCartPage() => '$cartPage';
  static String getLogout() => '$logout';
  static String getTablePage() => '$tablePage';
  // * config route names with GetPage, when use Get.toName(name),
  // * it will navigate to the provided page element
  // todo must initial these routes in GetMaterialApp -> in main.dart
  static List<GetPage> routes = [
    GetPage(name: splashPage, page: () => const SplashPage()),
    GetPage(name: initial, page: () => HomePage()),
    GetPage(name: login, page: () => const SignInPage()),
    GetPage(name: logout, page: () => const SignInPage()),
    GetPage(
      name: popularFood,
      page: () {
        int pageId = int.parse(Get.parameters['pageId']!);
        return PopularFoodDetail(pageId: pageId);
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: tablePage,
      page: () {
        return PickTable();
      },
      transition: Transition.fadeIn,
    ),
  ];
}
