import 'package:get/get.dart';
import 'package:mobile_food_delivery/data/api/api_client.dart';
import 'package:mobile_food_delivery/utils/app_constants.dart';

class UserRepo {
  final ApiClient apiClient;

  UserRepo({required this.apiClient});

  Future<Response> getUserDetails(String userId) async {
    return await apiClient.getData("${AppConstants.USER_DETAIL_URI}/$userId");
  }
}
