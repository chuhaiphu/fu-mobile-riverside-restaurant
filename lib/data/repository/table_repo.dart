import 'package:get/get.dart';
import 'package:mobile_food_delivery/data/api/api_client.dart';
import 'package:mobile_food_delivery/utils/app_constants.dart';

class TableRepo extends GetxService {
  final ApiClient apiClient;
  TableRepo({required this.apiClient});

  Future<Response> getTableById(String id) async {
    return await apiClient.getData('${AppConstants.TABLE_URI}/$id');
  }
}
