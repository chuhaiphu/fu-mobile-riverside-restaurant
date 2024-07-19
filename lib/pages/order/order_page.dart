import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_food_delivery/controllers/order_controller.dart';
import 'package:mobile_food_delivery/controllers/order_detail_controller.dart';
import 'package:mobile_food_delivery/controllers/payment_controller.dart';
import 'package:mobile_food_delivery/controllers/total_price_controller.dart';
import 'package:mobile_food_delivery/models/order.dart';
import 'package:mobile_food_delivery/models/order_detail.dart';
import 'package:mobile_food_delivery/models/payment.dart';
import 'package:mobile_food_delivery/pages/home/home_page.dart';
import 'package:mobile_food_delivery/pages/order/update_order_detail_page.dart';
import 'package:mobile_food_delivery/utils/dimensions.dart';
import 'package:mobile_food_delivery/utils/colors.dart';
import 'package:mobile_food_delivery/widgets/big_text.dart';
import 'package:mobile_food_delivery/widgets/total_price_display.dart';

class OrderPage extends StatefulWidget {
  final Order order;

  const OrderPage({super.key, required this.order});

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final OrderController orderController = Get.find<OrderController>();
  final OrderDetailController orderDetailController = Get.find<OrderDetailController>();
  final TotalPriceController totalPriceController = Get.put(TotalPriceController());
  final PaymentController paymentController = Get.find<PaymentController>();

  @override
  void initState() {
    super.initState();
    orderController.fetchOrderById(widget.order.orderId!);
    paymentController.getPayments();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      totalPriceController.calculateTotalPriceForOrder(widget.order.orderId!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.mainBlackColor),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text('Chi tiết đơn hàng',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.mainBlackColor,
                fontSize: Dimensions.value_16 + 3)),
        actions: [
          TotalPriceDisplay(orderId: widget.order.orderId!),
        ],
        backgroundColor: AppColors.mainColor,
        elevation: 2,
      ),
      body: Obx(() {
        Order? order = orderController.orders.firstWhereOrNull(
          (order) => order.orderId == widget.order.orderId,
        );

        if (order == null) {
          return const Center(child: CircularProgressIndicator(color: AppColors.mainColor));
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(Dimensions.value_20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainColor,
                  foregroundColor: AppColors.mainBlackColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  Get.offAll(() => HomePage());
                },
                child: const Icon(Icons.home, size: 20),
              ),
              SizedBox(width: Dimensions.value_10),
              SizedBox(height: Dimensions.value_10),
              ElevatedButton.icon(
                icon: const Icon(Icons.history, size: 20),
                label:
                    Text('Xem lịch sử thanh toán', style: TextStyle(fontSize: Dimensions.value_16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainColor,
                  foregroundColor: AppColors.mainBlackColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  _showPaymentsDialog(context, order.orderId!);
                },
              ),
              SizedBox(height: Dimensions.value_20),
              BigText(text: 'Lịch sử đơn hàng', color: AppColors.titleColor),
              SizedBox(height: Dimensions.value_10),
              Obx(() => ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: orderDetailController.orderDetails.length,
                    itemBuilder: (context, index) {
                      OrderDetail detail = orderDetailController.orderDetails[index];
                      return Card(
                        elevation: 2,
                        margin: EdgeInsets.only(bottom: Dimensions.value_10),
                        child: ListTile(
                          title: Text(detail.description,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.titleColor,
                                  fontSize: Dimensions.value_16)),
                          subtitle: Text('Số lượng: ${detail.quantity}',
                              style: TextStyle(
                                  color: AppColors.paraColor, fontSize: Dimensions.value_15)),
                          trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getStatusColor(detail.status),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                _getStatusText(detail.status),
                                style:
                                    TextStyle(color: Colors.white, fontSize: Dimensions.value_15),
                              )),
                          onTap: () {
                            Get.to(() => UpdateOrderDetailPage(orderDetail: detail));
                          },
                        ),
                      );
                    },
                  )),
            ],
          ),
        );
      }),
    );
  }

  Color _getStatusColor(Status status) {
    switch (status) {
      case Status.HAVE_NOT_STARTED:
        return Colors.blue;
      case Status.IN_PROCESS:
        return Colors.orange;
      case Status.DONE:
        return Colors.green;
      case Status.CANCEL:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(Status status) {
    switch (status) {
      case Status.HAVE_NOT_STARTED:
        return "Chưa xử lý";
      case Status.IN_PROCESS:
        return "Đang xử lý";
      case Status.DONE:
        return "Xử lý xong";
      case Status.CANCEL:
        return "Huỷ";
      default:
        return "Không xác định";
    }
  }

  void _showPaymentsDialog(BuildContext context, String orderId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Lịch sử thanh toán',
              style: TextStyle(color: AppColors.titleColor, fontWeight: FontWeight.bold)),
          content: Container(
            width: double.maxFinite,
            child: Obx(() {
              List<Payment> orderPayments = paymentController.payments
                  .where((payment) => payment.orderId == orderId)
                  .toList();
              return ListView.builder(
                itemCount: orderPayments.length,
                itemBuilder: (context, index) {
                  Payment payment = orderPayments[index];
                  return ListTile(
                    title: Text('Trả lần ${index + 1}',
                        style: const TextStyle(
                            color: AppColors.titleColor, fontWeight: FontWeight.bold)),
                    subtitle: Text('Số tiền: ${payment.price.toStringAsFixed(0)} đ',
                        style: const TextStyle(color: AppColors.paraColor)),
                    trailing: Text(payment.paymentTime.toString().split(' ')[0],
                        style: const TextStyle(color: AppColors.iconColor2, fontSize: 14)),
                  );
                },
              );
            }),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Đóng', style: TextStyle(color: AppColors.mainColor)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
