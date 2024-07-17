import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_food_delivery/controllers/auth_controller.dart';
import 'package:mobile_food_delivery/controllers/order_controller.dart';
import 'package:mobile_food_delivery/controllers/order_detail_controller.dart';
import 'package:mobile_food_delivery/controllers/payment_controller.dart';
import 'package:mobile_food_delivery/controllers/table_controller.dart';
import 'package:mobile_food_delivery/controllers/total_price_controller.dart';
import 'package:mobile_food_delivery/models/order.dart';
import 'package:mobile_food_delivery/models/dish.dart';
import 'package:mobile_food_delivery/models/payment.dart';
import 'package:mobile_food_delivery/pages/order/create_order_detail_page.dart';
import 'package:mobile_food_delivery/pages/table/pick_table.dart';
import 'package:mobile_food_delivery/utils/colors.dart';
import 'package:mobile_food_delivery/utils/dimensions.dart';
import 'package:mobile_food_delivery/widgets/total_price_display.dart';

class CreateOrderPage extends StatefulWidget {
  final Dish dish;
  final int initialQuantity;
  final double initialTotalPrice;

  const CreateOrderPage({
    Key? key,
    required this.dish,
    required this.initialQuantity,
    required this.initialTotalPrice,
  }) : super(key: key);

  @override
  _CreateOrderPageState createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends State<CreateOrderPage> {
  final _formKey = GlobalKey<FormState>();
  final AuthController authController = Get.find<AuthController>();
  final OrderController orderController = Get.find<OrderController>();
  final TotalPriceController totalPriceController = Get.put(TotalPriceController());
  final OrderDetailController orderDetailController = Get.find<OrderDetailController>();
  final String _tempOrderId = 'temp_${DateTime.now().millisecondsSinceEpoch}';

  String _orderName = '';
  bool _haveDeposit = false;
  double _advance = 0.0;
  String _selectedTableId = '';
  String _selectedTableName = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      totalPriceController.setTemporaryTotalPrice(_tempOrderId, widget.initialTotalPrice);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.mainBlackColor),
          onPressed: () => Get.back(),
        ),
        title: const Text('Thông tin đơn hàng',
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.mainBlackColor)),
        backgroundColor: AppColors.mainColor,
        elevation: 2,
        actions: [TotalPriceDisplay(orderId: _tempOrderId)],
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
                prefixIcon: const Icon(Icons.info_outline, color: AppColors.mainColor),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              style: TextStyle(fontSize: Dimensions.value_16, color: AppColors.mainBlackColor),
              validator: (value) => value!.isEmpty ? 'Vui lòng nhập thông tin đơn hàng' : null,
              onSaved: (value) => _orderName = value!,
            ),
            SizedBox(height: Dimensions.value_20),
            SwitchListTile(
              title: Text('Trả trước?',
                  style: TextStyle(fontSize: Dimensions.value_16, color: AppColors.titleColor)),
              value: _haveDeposit,
              onChanged: (value) => setState(() => _haveDeposit = value),
              activeColor: AppColors.mainColor,
            ),
            SizedBox(height: Dimensions.value_20),
            ElevatedButton.icon(
              icon: Icon(Icons.table_restaurant, size: Dimensions.value_20),
              label: Text(
                  _selectedTableName.isEmpty ? 'Chọn bàn cho khách' : 'Bàn: $_selectedTableName',
                  style: TextStyle(fontSize: Dimensions.value_16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainColor,
                foregroundColor: AppColors.mainBlackColor,
                padding: EdgeInsets.symmetric(vertical: Dimensions.value_15 - 3),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () async {
                final result = await Get.to(() => const PickTable());
                if (result != null) {
                  setState(() {
                    _selectedTableId = result['id'];
                    _selectedTableName = result['name'];
                  });
                }
              },
            ),
            if (_haveDeposit) ...[
              SizedBox(height: Dimensions.value_20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Số tiền trả trước (vnđ)',
                  labelStyle: TextStyle(color: AppColors.titleColor, fontSize: Dimensions.value_16),
                  prefixIcon: const Icon(Icons.monetization_on, color: AppColors.mainColor),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                style: TextStyle(fontSize: Dimensions.value_16, color: AppColors.mainBlackColor),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số tiền trả trước';
                  }
                  if (double.tryParse(value)! <= 0) {
                    return 'Số tiền trả trước phải lớn hơn 0';
                  }
                  return null;
                },
                onSaved: (value) => _advance = double.tryParse(value!) ?? 0.0,
              ),
            ],
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
                  Text('Tạo đơn',
                      style: TextStyle(fontSize: Dimensions.value_16, fontWeight: FontWeight.bold)),
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
      if (_selectedTableId.isEmpty) {
        Get.snackbar('Lỗi', 'Vui lòng chọn bàn');
        return;
      }
      final newOrder = Order(
        userId: authController.accountId,
        orderName: _orderName,
        haveDeposit: _haveDeposit,
        totalPrice: widget.initialTotalPrice,
        advance: _advance,
        remaining: widget.initialTotalPrice - _advance,
        status: OrderStatus.HAVE_NOT_STARTED,
        tableId: _selectedTableId,
        orderDetails: [],
      );
      orderController.createOrder(newOrder).then((createdOrder) {
        if (createdOrder != null && createdOrder.orderId != null) {
          totalPriceController.calculateTotalPriceForOrder(createdOrder.orderId!);
          Get.find<TableController>().resetSelectedTable();
          if (_haveDeposit && _advance > 0) {
            final payment = Payment(
              price: _advance,
              paymentTime: DateTime.now(),
              isAvailable: true,
              orderId: createdOrder.orderId!,
            );
            Get.find<PaymentController>().createPayment(payment).then((createdPayment) {
              if (createdPayment != null) {
                Get.to(() => CreateOrderDetailPage(
                      order: createdOrder,
                      dish: widget.dish,
                      initialQuantity: widget.initialQuantity,
                    ));
              } else {
                Get.snackbar('Lỗi', 'Tạo thanh toán thất bại');
              }
            });
          } else {
            Get.to(() => CreateOrderDetailPage(
                  order: createdOrder,
                  dish: widget.dish,
                  initialQuantity: widget.initialQuantity,
                ));
          }
        } else {
          Get.snackbar('Lỗi', 'Tạo đơn thất bại');
        }
      });
    }
  }
}
