import 'package:get/get.dart';
import 'package:mobile_food_delivery/controllers/order_detail_controller.dart';
import 'package:mobile_food_delivery/controllers/popular_dish_controller.dart';
import 'package:mobile_food_delivery/models/dish.dart';
import 'package:mobile_food_delivery/models/order_detail.dart';

class TotalPriceController extends GetxController {
  final PopularProductController popularProductController = Get.find();
  final OrderDetailController orderDetailController = Get.find();
  final Map<String, RxDouble> _totalPrices = <String, RxDouble>{}.obs;

  double getTotalPrice(String orderId) => _totalPrices[orderId]?.value ?? 0.0;

  Future<void> calculateTotalPriceForOrder(String orderId) async {
    await orderDetailController.fetchOrderDetailsByOrderId(orderId);
    List<OrderDetail> orderDetails = orderDetailController.orderDetails;

    double total = 0.0;
    for (var detail in orderDetails) {
      var dish = popularProductController.popularProductList.firstWhere(
        (d) => d.dishId == detail.dishId,
        orElse: () => Dish(),
      );
      if (dish.dishPrice != null) {
        total += dish.dishPrice! * detail.quantity;
      }
    }

    if (!_totalPrices.containsKey(orderId)) {
      _totalPrices[orderId] = 0.0.obs;
    }
    _totalPrices[orderId]!.value = total;
    update();
  }

  void setTemporaryTotalPrice(String tempId, double price) {
    if (!_totalPrices.containsKey(tempId)) {
      _totalPrices[tempId] = 0.0.obs;
    }
    _totalPrices[tempId]!.value = price;
    update();
  }
}
