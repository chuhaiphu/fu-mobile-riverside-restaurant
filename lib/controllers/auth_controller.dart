
import 'package:get/get.dart';
import 'package:mobile_food_delivery/controllers/order_controller.dart';
import 'package:mobile_food_delivery/controllers/popular_dish_controller.dart';
import 'package:mobile_food_delivery/controllers/table_controller.dart';
import 'package:mobile_food_delivery/data/repository/auth_repo.dart';
import 'package:mobile_food_delivery/models/response_model.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  AuthController({required this.authRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    update();
  }

  String _accountId = "";
  String get accountId => _accountId;

  Future<ResponseModel> login(String email, String password) async {
    _isLoading = true;
    update();
    Response response = await authRepo.login(email, password);
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      String token = response.body['content']['access_token'];
      _accountId = response.body['content']['account_id'];
      await authRepo.saveUserToken(token);
      await authRepo.saveAccountId(_accountId);
      responseModel = ResponseModel(true, "Login successful");
      loadDataAfterLogin();
    } else {
      String errorMessage = response.body['details'][0];
      if (response.body != null &&
          response.body['details'] != null &&
          response.body['details'].isNotEmpty) {
        errorMessage = response.body['details'][0];
      }

      responseModel = ResponseModel(false, errorMessage);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  void loadDataAfterLogin() {
    Get.find<PopularProductController>().getPopularProductList();
    Get.find<TableController>().getAreas();
    Get.find<OrderController>().getOrdersByUser(_accountId);
  }

  void loadUserTokenAndAccountId() {
    authRepo.apiClient.token = authRepo.getUserToken();
    _accountId = authRepo.getAccountId();
  }

  Future<void> logout() async {
    await authRepo.logout();
    _accountId = "";
    update();
  }
}
