// lib/pages/payment/add_payment_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_food_delivery/controllers/payment_controller.dart';
import 'package:mobile_food_delivery/models/payment.dart';

class AddPaymentPage extends StatelessWidget {
  final String orderId;
  final double totalPrice;
  final double totalPaid;
  final PaymentController paymentController = Get.find<PaymentController>();

  AddPaymentPage({
    Key? key, 
    required this.orderId, 
    required this.totalPrice, 
    required this.totalPaid
  }) : super(key: key);

  final TextEditingController priceController = TextEditingController();

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Tạo giao dịch')),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text('Tổng phải trả: ${totalPrice.toStringAsFixed(0)}'),
          Text('Đã trả: ${totalPaid.toStringAsFixed(0)}'),
          Text('Còn lại: ${(totalPrice - totalPaid).toStringAsFixed(0)}'),
          const SizedBox(height: 20),
          TextField(
            controller: priceController,
            decoration: const InputDecoration(labelText: 'Số tiền trả'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            child: const Text('Xác nhận giao dịch'),
            onPressed: () async {
              double price = double.tryParse(priceController.text) ?? 0;
              if (price > 0 && price <= (totalPrice - totalPaid)) {
                Payment newPayment = Payment(
                  price: price,
                  paymentTime: DateTime.now(),
                  isAvailable: true,
                  orderId: orderId,
                );
                
                Payment? createdPayment = await paymentController.createPayment(newPayment);
                if (createdPayment != null) {
                  Get.back(); // Return to previous page
                } else {
                  Get.snackbar('Error', 'Failed to create payment');
                }
              } else if (price > (totalPrice - totalPaid)) {
                Get.snackbar('Error', 'Payment amount exceeds the remaining balance');
              } else {
                Get.snackbar('Error', 'Please enter a valid payment amount');
              }
            },
          ),
        ],
      ),
    ),
  );
}

}
