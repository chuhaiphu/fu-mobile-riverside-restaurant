import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_food_delivery/controllers/order_controller.dart';
import 'package:mobile_food_delivery/controllers/payment_controller.dart';
import 'package:mobile_food_delivery/models/payment.dart';
import 'package:mobile_food_delivery/pages/order/order_page.dart';
import 'package:mobile_food_delivery/pages/payment/add_payment_page.dart';
import 'package:mobile_food_delivery/utils/colors.dart';
import 'package:mobile_food_delivery/utils/dimensions.dart'; // Add this import

class ViewOrderPage extends GetView<OrderController> {
  const ViewOrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final paymentController = Get.find<PaymentController>();
    paymentController.getPayments();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách đơn hàng',
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.mainBlackColor)),
        backgroundColor: AppColors.mainColor,
        elevation: 2,
        leading: const Icon(Icons.receipt_long, color: AppColors.mainBlackColor),
      ),
      body: GetBuilder<PaymentController>(
        init: paymentController,
        builder: (paymentCtrl) {
          return ListView.separated(
            itemCount: controller.orders.length,
            separatorBuilder: (context, index) =>
                Divider(color: AppColors.paraColor.withOpacity(0.3)),
            itemBuilder: (context, index) {
              final order = controller.orders[index];
              final totalPaid = getTotalPaidForOrder(order.orderId!, paymentCtrl.payments);
              final isPaid = totalPaid >= order.totalPrice;

              return ListTile(
                title: Text('Đơn hàng: ${order.orderName}',
                    style:
                      TextStyle(fontSize: Dimensions.value_16,fontWeight: FontWeight.bold, color: AppColors.titleColor)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tổng giá: ${order.totalPrice.toStringAsFixed(0)} đ',
                      style: const TextStyle(color: AppColors.mainBlackColor),
                    ),
                    Text(
                      'Đã trả: ${totalPaid.toStringAsFixed(0)} đ',
                      style: TextStyle(
                        color: totalPaid == order.totalPrice
                            ? Colors.green
                            : Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isPaid)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Đã thanh toán đủ',
                          style:
                              TextStyle(color: Colors.white, fontSize: Dimensions.value_15),
                        ),
                      )
                    else
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Trả thêm'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.mainColor,
                          foregroundColor: AppColors.mainBlackColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () async {
                          await Get.to(() => AddPaymentPage(
                                orderId: order.orderId!,
                                totalPrice: order.totalPrice,
                                totalPaid: totalPaid,
                              ));
                          await controller.getOrders();
                          await paymentController.getPayments();
                        },
                      ),
                    const SizedBox(width: 4),
                  ],
                ),
                onTap: () {
                  Get.to(() => OrderPage(order: order));
                },
              );
            },
          );
        },
      ),
    );
  }

  double getTotalPaidForOrder(String orderId, List<Payment> payments) {
    return payments
        .where((payment) => payment.orderId == orderId)
        .fold(0, (sum, payment) => sum + payment.price);
  }
}
