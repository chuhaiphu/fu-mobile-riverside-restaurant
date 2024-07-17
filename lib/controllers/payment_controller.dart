// lib/controllers/payment_controller.dart

import 'package:get/get.dart';
import 'package:mobile_food_delivery/models/payment.dart';
import 'package:mobile_food_delivery/data/repository/payment_repo.dart';

class PaymentController extends GetxController {
  final PaymentRepo paymentRepo;
  PaymentController({required this.paymentRepo});

  final payments = <Payment>[].obs;

  Future<void> getPayments() async {
    Response response = await paymentRepo.getPayments();
    if (response.statusCode == 200) {
      payments.value = (response.body['content'] as List).map((item) => Payment.fromJson(item)).toList();
      update();
    } else {
      print("Failed to load payments: ${response.statusText}");
    }
  }

  Future<void> fetchPaymentById(String id) async {
    Response response = await paymentRepo.getPaymentById(id);
    if (response.statusCode == 200) {
      Payment payment = Payment.fromJson(response.body['content']);
      int index = payments.indexWhere((element) => element.paymentId == id);
      if (index != -1) {
        payments[index] = payment;
      } else {
        payments.add(payment);
      }
      update();
    } else {
      print("Failed to fetch payment: ${response.statusText}");
    }
  }

  Future<Payment?> createPayment(Payment payment) async {
    update();
    Map<String, dynamic> paymentJson = payment.toJson();
    Response response = await paymentRepo.createPayment(paymentJson);
    if (response.statusCode == 201) {
      Payment createdPayment = Payment.fromJson(response.body['content']);
      payments.add(createdPayment);
      update();
      return createdPayment;
    } else {
      print("Failed to create payment: ${response.statusText}");
      update();
      return null;
    }
  }

  Future<void> deletePayment(String id) async {
    Response response = await paymentRepo.deletePayment(id);
    if (response.statusCode == 200) {
      payments.removeWhere((element) => element.paymentId == id);
      update();
    } else {
      print("Failed to delete payment: ${response.statusText}");
    }
  }
}
