import 'package:get/get.dart';
import 'package:mobile_food_delivery/data/api/api_client.dart';
import 'package:mobile_food_delivery/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo extends GetxController implements GetxService {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  AuthRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> login(String email, String password) async {
    return await apiClient.postData(
      AppConstants.LOGIN_URI,
      {"email": email, "password": password},
    );
  }

  Future<bool> saveUserToken(String token) async {
    apiClient.token = token;
    apiClient.updateHeader(token);
    return await sharedPreferences.setString('user_token', token);
  }

  Future<bool> saveAccountId(String accountId) async {
    return await sharedPreferences.setString('account_id', accountId);
  }

  String getUserToken() {
    return sharedPreferences.getString('user_token') ?? "";
  }

  String getAccountId() {
    return sharedPreferences.getString('account_id') ?? "";
  }

  bool clearSharedData() {
    sharedPreferences.remove('user_token');
    sharedPreferences.remove('account_id');
    apiClient.token = '';
    apiClient.updateHeader('');
    return true;
  }

  Future<bool> logout() async {
    return clearSharedData();
  }

  bool isLoggedIn() {
    return getUserToken().isNotEmpty;
  }
}
