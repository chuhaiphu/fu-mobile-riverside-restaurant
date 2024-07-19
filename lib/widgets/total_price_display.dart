import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_food_delivery/controllers/order_controller.dart';

class TotalPriceDisplay extends StatelessWidget {
  final String orderId;

  const TotalPriceDisplay({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(
      builder: (controller) {
        final order = controller.orders.firstWhereOrNull(
          (order) => order.orderId == orderId,
        );

        if (order == null) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Tổng tiền: ${order.totalPrice.toStringAsFixed(0)}đ',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(
                'Đã trả trước: ${order.advance.toStringAsFixed(0)}đ',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        );
      },
    );
  }
}
