// lib/data/repository/order_repo.dart
import 'package:get/get.dart';
import 'package:mobile_food_delivery/data/api/api_client.dart';
import 'package:mobile_food_delivery/utils/app_constants.dart';

class OrderRepo extends GetxService {
  final ApiClient apiClient;
  OrderRepo({required this.apiClient});

  Future<Response> getOrders() async {
    return await apiClient.getData(AppConstants.ORDER_URI);
  }

  Future<Response> getOrderById(String id) async {
    return await apiClient.getData('${AppConstants.ORDER_URI}/$id');
  }

  Future<Response> createOrder(Map<String, dynamic> orderData) async {
    return await apiClient.postData(AppConstants.ORDER_URI, orderData);
  }

  Future<Response> updateOrder(Map<String, dynamic> orderData) async {
    return await apiClient.postData(AppConstants.ORDER_URI, orderData);
  }

  Future<Response> deleteOrder(String id) async {
    return await apiClient.deleteData('${AppConstants.ORDER_URI}/$id');
  }
}
