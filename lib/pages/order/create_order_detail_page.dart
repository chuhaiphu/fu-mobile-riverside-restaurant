import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_food_delivery/controllers/order_controller.dart';
import 'package:mobile_food_delivery/controllers/order_detail_controller.dart';
import 'package:mobile_food_delivery/controllers/total_price_controller.dart';
import 'package:mobile_food_delivery/models/order.dart';
import 'package:mobile_food_delivery/models/order_detail.dart';
import 'package:mobile_food_delivery/models/dish.dart';
import 'package:mobile_food_delivery/pages/order/order_page.dart';
import 'package:mobile_food_delivery/utils/colors.dart';
import 'package:mobile_food_delivery/utils/dimensions.dart';
import 'package:mobile_food_delivery/widgets/total_price_display.dart';

class CreateOrderDetailPage extends StatefulWidget {
  final Order order;
  final Dish dish;
  final int initialQuantity;

  const CreateOrderDetailPage({
    Key? key,
    required this.order,
    required this.dish,
    required this.initialQuantity,
  }) : super(key: key);

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<CreateOrderDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final OrderController orderController = Get.find<OrderController>();
  final OrderDetailController orderDetailController = Get.find<OrderDetailController>();
  final TotalPriceController totalPriceController = Get.put(TotalPriceController());

  late String _description;
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.initialQuantity;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      totalPriceController.calculateTotalPriceForOrder(widget.order.orderId!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết đơn hàng',
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.mainBlackColor)),
        backgroundColor: AppColors.mainColor,
        elevation: 2,
        leading: const Icon(Icons.restaurant_menu, color: AppColors.mainBlackColor),
        actions: [TotalPriceDisplay(orderId: widget.order.orderId!)],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(Dimensions.value_20),
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Mô tả ngắn',
                labelStyle: TextStyle(color: AppColors.titleColor, fontSize: Dimensions.value_16),
                prefixIcon: const Icon(Icons.description, color: AppColors.mainColor),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              style: TextStyle(fontSize: Dimensions.value_16, color: AppColors.mainBlackColor),
              initialValue: widget.dish.name,
              onSaved: (value) => _description = value!,
              validator: (value) => value!.isEmpty ? 'Vui lòng nhập mô tả' : null,
            ),
            SizedBox(height: Dimensions.value_20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Số lượng món ăn',
                labelStyle: TextStyle(color: AppColors.titleColor, fontSize: Dimensions.value_16),
                prefixIcon: const Icon(Icons.format_list_numbered, color: AppColors.mainColor),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              style: TextStyle(fontSize: Dimensions.value_16, color: AppColors.mainBlackColor),
              keyboardType: TextInputType.number,
              initialValue: _quantity.toString(),
              onChanged: (value) {
                setState(() {
                  _quantity = int.tryParse(value) ?? _quantity;
                });
                totalPriceController.calculateTotalPriceForOrder(widget.order.orderId!);
              },
              onSaved: (value) => _quantity = int.parse(value!),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập số lượng';
                }
                int? quantity = int.tryParse(value);
                if (quantity == null || quantity <= 0) {
                  return 'Vui lòng nhập số lượng hợp lệ';
                }
                return null;
              },
            ),
            SizedBox(height: Dimensions.value_30),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: Dimensions.value_15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, size: Dimensions.value_20),
                  SizedBox(width: Dimensions.value_10),
                  Text('Xác nhận', style: TextStyle(fontSize: Dimensions.value_16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newOrderDetail = OrderDetail(
        orderDetailId: null,
        orderId: widget.order.orderId!,
        dishId: widget.dish.dishId!,
        description: _description,
        status: Status.HAVE_NOT_STARTED,
        quantity: _quantity,
        personSaveId: widget.order.userId,
      );

      orderDetailController.createOrderDetail(newOrderDetail).then((createdOrderDetail) {
        if (createdOrderDetail != null) {
          double newTotalPrice = widget.order.totalPrice + (widget.dish.dishPrice! * _quantity);
          Order updatedOrder = widget.order.copyWith(totalPrice: newTotalPrice);
          orderController.updateOrder(updatedOrder).then((_) {
            Get.off(() => OrderPage(order: updatedOrder), preventDuplicates: false);
          });
        }
      });
    }
  }
}
