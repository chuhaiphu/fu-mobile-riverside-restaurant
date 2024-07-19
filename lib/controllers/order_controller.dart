// lib/controllers/order_controller.dart

import 'package:get/get.dart';
import 'package:mobile_food_delivery/models/order.dart';
import 'package:mobile_food_delivery/data/repository/order_repo.dart';

class OrderController extends GetxController {
  final OrderRepo orderRepo;
  OrderController({required this.orderRepo});

  final orders = <Order>[].obs;


Future<void> getOrders() async {
  Response response = await orderRepo.getOrders();
  if (response.statusCode == 200) {
    orders.value = (response.body['content'] as List).map((item) => Order.fromJson(item)).toList();
    update();
  } else {
    // Handle error
    print("Failed to load orders: ${response.statusText}");
  }
}

  Future<void> fetchOrderById(String id) async {
    Response response = await orderRepo.getOrderById(id);
    if (response.statusCode == 200) {
      Order order = Order.fromJson(response.body['content']);
      int index = orders.indexWhere((element) => element.orderId == id);
      if (index != -1) {
        orders[index] = order;
      } else {
        orders.add(order);
      }
    } else {
      // Handle error
    }
  }

  Future<Order?> createOrder(Order order) async {
    update();
    Map<String, dynamic> orderJson = order.toJson();
    orderJson['status'] = order.status.toString().split('.').last;
    Response response = await orderRepo.createOrder(orderJson);
    if (response.statusCode == 201) {
      Order createdOrder = Order.fromJson(response.body['content']);
      orders.add(createdOrder);
      update();
      return createdOrder;
    } else {
      if (response.body != null &&
          response.body['details'] != null &&
          response.body['details'].isNotEmpty) {
      }
      update();
      return null;
    }
  }

Future<void> updateOrder(Order order) async {
  update();

  Map<String, dynamic> orderJson = order.toJson();
  orderJson['status'] = order.status.toString().split('.').last;

  Response updateResponse = await orderRepo.updateOrder(orderJson);

  if (updateResponse.statusCode == 201) {
    Order updatedOrder = Order.fromJson(updateResponse.body['content']);
    int index = orders.indexWhere((element) => element.orderId == updatedOrder.orderId);
    if (index != -1) {
      orders[index] = updatedOrder;
    } else {
      orders.add(updatedOrder);
    }
    orders.refresh();
    Get.snackbar('Thành công', 'Đơn hàng xử lý thành công');
  } else {
    Get.snackbar('Error', 'Failed to update order: ${updateResponse.body.toString()}');
  }

  update();
}


  Future<void> deleteOrder(String id) async {
    Response response = await orderRepo.deleteOrder(id);
    if (response.statusCode == 200) {
      orders.removeWhere((element) => element.orderId == id);
    } else {
      // Handle error
    }
  }

  Future<void> getOrdersByUser(String userId) async {
    Response response = await orderRepo.getOrdersByUser(userId);
    if (response.statusCode == 200) {
      orders.value = (response.body['content'] as List).map((item) => Order.fromJson(item)).toList();
      update();
    } else {
      print("Failed to load orders: ${response.statusText}");
    }
  }
}
