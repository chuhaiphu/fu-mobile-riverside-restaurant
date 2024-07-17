// lib/controllers/order_detail_controller.dart

import 'package:get/get.dart';
import 'package:mobile_food_delivery/models/order_detail.dart';
import 'package:mobile_food_delivery/data/repository/order_detail_repo.dart';

class OrderDetailController extends GetxController {
  final OrderDetailRepo orderDetailRepo;
  
  OrderDetailController({required this.orderDetailRepo});

  final orderDetails = <OrderDetail>[].obs;

  Future<void> fetchOrderDetails() async {
    Response response = await orderDetailRepo.getOrderDetails();
    if (response.statusCode == 200) {
      orderDetails.value = (response.body['content'] as List).map((item) => OrderDetail.fromJson(item)).toList();
    } else {
      // Handle error
    }
  }

  Future<void> fetchOrderDetailById(String id) async {
    Response response = await orderDetailRepo.getOrderDetailById(id);
    if (response.statusCode == 200) {
      OrderDetail orderDetail = OrderDetail.fromJson(response.body['content']);
      int index = orderDetails.indexWhere((element) => element.orderDetailId == id);
      if (index != -1) {
        orderDetails[index] = orderDetail;
      } else {
        orderDetails.add(orderDetail);
      }
    } else {
      // Handle error
    }
  }

Future<OrderDetail?> createOrderDetail(OrderDetail orderDetail) async {
  update();
  Map<String, dynamic> orderDetailJson = orderDetail.toJson();
  orderDetailJson['personSaveId'] = orderDetail.personSaveId;
  Response response = await orderDetailRepo.createOrderDetail(orderDetailJson);
  if (response.statusCode == 201) {
    Map<String, dynamic> responseBody = response.body['content'] as Map<String, dynamic>;
    OrderDetail createdOrderDetail = OrderDetail.fromJson(responseBody);
    orderDetails.add(createdOrderDetail);
    orderDetails.refresh(); // This will trigger an update in the UI
    update();
    return createdOrderDetail;
  } else {
    String errorMessage = "An error occurred";
    if (response.body != null &&
        response.body['details'] != null &&
        response.body['details'].isNotEmpty) {
      errorMessage = response.body['details'][0];
    }
    Get.snackbar('Error', errorMessage);
    update();
    return null;
  }
}




  Future<void> updateOrderDetailStatus(String id, String status) async {
    Response response = await orderDetailRepo.updateOrderDetailStatus(id, status);
    if (response.statusCode == 200) {
      int index = orderDetails.indexWhere((element) => element.orderDetailId == id);
      if (index != -1) {
        orderDetails[index] = OrderDetail.fromJson(response.body['content']);
      }
    } else {
      // Handle error
    }
  }

  Future<void> deleteOrderDetail(String id) async {
    Response response = await orderDetailRepo.deleteOrderDetail(id);
    if (response.statusCode == 200) {
      orderDetails.removeWhere((element) => element.orderDetailId == id);
    } else {
      // Handle error
    }
  }

Future<void> fetchOrderDetailsByOrderId(String orderId) async {
  Response response = await orderDetailRepo.getOrderDetailsByOrderId(orderId);
  if (response.statusCode == 200) {
    orderDetails.clear(); // Clear existing details
    List<OrderDetail> details = (response.body['content'] as List).map((item) => OrderDetail.fromJson(item)).toList();
    orderDetails.addAll(details);
    update(); // Notify listeners
  } else {
    // Handle error
    print("Failed to load order details: ${response.statusText}");
  }
}


  Future<void> fetchOrderDetailsByAccountId(String accountId) async {
    Response response = await orderDetailRepo.getOrderDetailsByAccountId(accountId);
    if (response.statusCode == 200) {
      List<OrderDetail> details = (response.body['content'] as List).map((item) => OrderDetail.fromJson(item)).toList();
      orderDetails.addAll(details);
    } else {
      // Handle error
    }
  }
}
