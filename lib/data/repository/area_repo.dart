import 'package:get/get.dart';
import 'package:mobile_food_delivery/data/api/api_client.dart';
import 'package:mobile_food_delivery/utils/app_constants.dart';

class AreaRepo extends GetxService {
  final ApiClient apiClient;
  AreaRepo({required this.apiClient});

  Future<Response> getAreas() async {
    return await apiClient.getData(AppConstants.AREA_URI);
  }
}
