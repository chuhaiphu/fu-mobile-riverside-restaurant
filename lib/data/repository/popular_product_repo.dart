import 'package:get/get.dart';
import 'package:mobile_food_delivery/data/api/api_client.dart';
import 'package:mobile_food_delivery/utils/app_constants.dart';

class PopularProductRepo extends GetxService {
  final ApiClient apiClient;
  PopularProductRepo({required this.apiClient});

  // Existing method
  Future<Response> getPopularProductList() async {
    return await apiClient.getData(AppConstants.POPUPAR_PRODUCT_URI);
  }

  // New methods
  Future<Response> getAllDishes() async {
    return await apiClient.getData("/dish");
  }

  Future<Response> updateDish(int id, Map<String, dynamic> data) async {
    return await apiClient.putData("/dish/$id", data);
  }

  Future<Response> createDish(Map<String, dynamic> data) async {
    return await apiClient.postData("/dish", data);
  }

  Future<Response> getDishById(int id) async {
    return await apiClient.getData("/dish/$id");
  }

  Future<Response> deleteDish(int id) async {
    return await apiClient.deleteData("/dish/$id");
  }

  Future<Response> getDishByCategory(int categoryId) async {
    return await apiClient.getData("/dish/category/$categoryId");
  }
}
