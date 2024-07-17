// lib/data/repository/payment_repo.dart

import 'package:get/get.dart';
import 'package:mobile_food_delivery/data/api/api_client.dart';
import 'package:mobile_food_delivery/utils/app_constants.dart';

class PaymentRepo extends GetxService {
  final ApiClient apiClient;
  PaymentRepo({required this.apiClient});

  Future<Response> getPayments() async {
    return await apiClient.getData(AppConstants.PAYMENT_URI);
  }

  Future<Response> getPaymentById(String id) async {
    return await apiClient.getData('${AppConstants.PAYMENT_URI}/$id');
  }

  Future<Response> createPayment(Map<String, dynamic> paymentData) async {
    return await apiClient.postData(AppConstants.PAYMENT_URI, paymentData);
  }

  Future<Response> deletePayment(String id) async {
    return await apiClient.deleteData('${AppConstants.PAYMENT_URI}/$id');
  }
}
