// lib/data/repository/order_detail_repo.dart

import 'package:get/get.dart';
import 'package:mobile_food_delivery/data/api/api_client.dart';
import 'package:mobile_food_delivery/utils/app_constants.dart';

class OrderDetailRepo extends GetxService {
  final ApiClient apiClient;
  OrderDetailRepo({required this.apiClient});

  Future<Response> getOrderDetails() async {
    return await apiClient.getData(AppConstants.ORDER_DETAIL_URI);
  }

  Future<Response> getOrderDetailById(String id) async {
    return await apiClient.getData('${AppConstants.ORDER_DETAIL_URI}/$id');
  }

  Future<Response> createOrderDetail(dynamic body) async {
    return await apiClient.postData(AppConstants.ORDER_DETAIL_URI, body);
  }

  Future<Response> updateOrderDetailStatus(String id, String status) async {
    return await apiClient.putData('${AppConstants.ORDER_DETAIL_URI}/$id/$status', null);
  }

  Future<Response> deleteOrderDetail(String id) async {
    return await apiClient.deleteData('${AppConstants.ORDER_DETAIL_URI}/$id');
  }

  Future<Response> getOrderDetailsByOrderId(String orderId) async {
    return await apiClient.getData('${AppConstants.ORDER_DETAIL_URI}/order/$orderId');
  }

  Future<Response> getOrderDetailsByAccountId(String accountId) async {
    return await apiClient.getData('${AppConstants.ORDER_DETAIL_URI}/account/$accountId');
  }
}
