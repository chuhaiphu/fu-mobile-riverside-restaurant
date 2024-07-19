import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_food_delivery/controllers/order_controller.dart';
import 'package:mobile_food_delivery/models/dish.dart';
import 'package:mobile_food_delivery/pages/order/create_order_detail_page.dart';
import 'package:mobile_food_delivery/utils/colors.dart';
import 'package:mobile_food_delivery/utils/dimensions.dart';

class OrderSelectionPage extends StatelessWidget {
  final Dish dish;
  final int initialQuantity;

  const OrderSelectionPage({Key? key, required this.dish, required this.initialQuantity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OrderController orderController = Get.find<OrderController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn đơn hàng',
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.mainBlackColor)),
        backgroundColor: AppColors.mainColor,
        elevation: 2,
        iconTheme: const IconThemeData(color: AppColors.mainBlackColor),
      ),
      body: ListView.separated(
        itemCount: orderController.orders.length,
        separatorBuilder: (context, index) => Divider(color: AppColors.paraColor.withOpacity(0.3)),
        itemBuilder: (context, index) {
          final order = orderController.orders[index];
          return ListTile(
            leading: const Icon(Icons.receipt, color: AppColors.iconColor1),
            title: Text(
              'Đơn hàng: ${order.orderName}',
              style: TextStyle(
                fontSize: Dimensions.value_16,
                fontWeight: FontWeight.bold,
                color: AppColors.titleColor,
              ),
            ),
            subtitle: Text(
              'Tổng giá: ${order.totalPrice.toStringAsFixed(0)} đ',
              style: const TextStyle(color: AppColors.mainBlackColor),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, color: AppColors.mainColor),
            onTap: () {
              Get.to(() => CreateOrderDetailPage(
                  order: order, dish: dish, initialQuantity: initialQuantity));
            },
          );
        },
      ),
    );
  }
}
