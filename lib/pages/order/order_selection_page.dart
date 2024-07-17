// lib/pages/order/order_selection_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_food_delivery/controllers/order_controller.dart';
import 'package:mobile_food_delivery/models/dish.dart';
import 'package:mobile_food_delivery/pages/order/create_order_detail_page.dart';

class OrderSelectionPage extends StatelessWidget {
  final Dish dish;

  final int initialQuantity;

  OrderSelectionPage({required this.dish, required this.initialQuantity});

  @override
  Widget build(BuildContext context) {
    final OrderController orderController = Get.find<OrderController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Chọn đơn hàng')),
      body: ListView.builder(
        itemCount: orderController.orders.length,
        itemBuilder: (context, index) {
          final order = orderController.orders[index];
          return ListTile(
            title: Text('Đơn hàng: ${order.orderName}'),
            subtitle: Text('Trạng thái: ${order.status}'),
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
