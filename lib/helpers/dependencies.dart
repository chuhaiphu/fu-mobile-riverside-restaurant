import 'package:get/get.dart';
import 'package:mobile_food_delivery/controllers/auth_controller.dart';
import 'package:mobile_food_delivery/controllers/order_controller.dart';
import 'package:mobile_food_delivery/controllers/order_detail_controller.dart';
import 'package:mobile_food_delivery/controllers/payment_controller.dart';
import 'package:mobile_food_delivery/controllers/popular_dish_controller.dart';
import 'package:mobile_food_delivery/controllers/table_controller.dart';
import 'package:mobile_food_delivery/controllers/total_price_controller.dart';
import 'package:mobile_food_delivery/controllers/user_controller.dart';
import 'package:mobile_food_delivery/data/api/api_client.dart';
import 'package:mobile_food_delivery/data/repository/area_repo.dart';
import 'package:mobile_food_delivery/data/repository/auth_repo.dart';
import 'package:mobile_food_delivery/data/repository/order_detail_repo.dart';
import 'package:mobile_food_delivery/data/repository/order_repo.dart';
import 'package:mobile_food_delivery/data/repository/payment_repo.dart';
import 'package:mobile_food_delivery/data/repository/popular_product_repo.dart';
import 'package:mobile_food_delivery/data/repository/table_repo.dart';
import 'package:mobile_food_delivery/data/repository/user_repo.dart';
import 'package:mobile_food_delivery/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

// * initialize the dependencies in flutter for all widgets to use
// ! dependencies injection
Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => ApiClient(appBaseUrl: AppConstants.BASE_URL));

  Get.lazyPut(() => AuthRepo(apiClient: Get.find<ApiClient>(), sharedPreferences: Get.find()));
  Get.lazyPut(() => UserRepo(apiClient: Get.find<ApiClient>()));
  Get.lazyPut(() => PopularProductRepo(apiClient: Get.find<ApiClient>()));
  Get.lazyPut(() => AreaRepo(apiClient: Get.find<ApiClient>())); // Add this line
  Get.lazyPut(() => TableRepo(apiClient: Get.find<ApiClient>())); // Add this line
  Get.lazyPut(() => OrderRepo(apiClient: Get.find<ApiClient>()));
  Get.lazyPut(() => OrderDetailRepo(apiClient: Get.find<ApiClient>()));
  Get.lazyPut(() => PaymentRepo(apiClient: Get.find<ApiClient>()));

  Get.lazyPut(() => AuthController(authRepo: Get.find<AuthRepo>()));
  Get.put(UserController(userRepo: Get.find<UserRepo>()), permanent: true);
  Get.lazyPut(() => PopularProductController(popularProductRepo: Get.find<PopularProductRepo>()));
  Get.put(TableController(tableRepo: Get.find<TableRepo>(), areaRepo: Get.find<AreaRepo>()), permanent: true);
  Get.put(OrderController(orderRepo: Get.find<OrderRepo>()), permanent: true);
  Get.put(OrderDetailController(orderDetailRepo: Get.find<OrderDetailRepo>()), permanent: true);
  Get.put(PaymentController(paymentRepo: Get.find<PaymentRepo>()), permanent: true);
  Get.put(TotalPriceController());

}
