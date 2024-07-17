import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_food_delivery/controllers/order_detail_controller.dart';
import 'package:mobile_food_delivery/models/order_detail.dart';
import 'package:mobile_food_delivery/utils/dimensions.dart';
import 'package:mobile_food_delivery/utils/colors.dart';
import 'package:mobile_food_delivery/widgets/big_text.dart';

class UpdateOrderDetailPage extends StatelessWidget {
  final OrderDetail orderDetail;
  final OrderDetailController controller = Get.find<OrderDetailController>();

  UpdateOrderDetailPage({Key? key, required this.orderDetail}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cập nhật đơn hàng',
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.mainBlackColor, fontSize: Dimensions.value_16 + 3)),
        backgroundColor: AppColors.mainColor,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.mainBlackColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(Dimensions.value_20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BigText(text: 'Mô tả ngắn: ${orderDetail.description}', color: AppColors.titleColor),
            SizedBox(height: Dimensions.value_20),
            BigText(text: 'Số lượng: ${orderDetail.quantity}', color: AppColors.titleColor),
            SizedBox(height: Dimensions.value_20),
            Row(
              children: [
                BigText(text: 'Trạng thái: ', color: AppColors.titleColor),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(orderDetail.status),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _getStatusText(orderDetail.status),
                    style: TextStyle(color: Colors.white, fontSize: Dimensions.value_15),
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.value_20),
            BigText(text: 'Cập nhật trạng thái:', color: AppColors.titleColor),
            SizedBox(height: Dimensions.value_10),
            DropdownButton<Status>(
              value: orderDetail.status,
              items: Status.values.map((Status status) {
                return DropdownMenuItem<Status>(
                  value: status,
                  child: Text(_getStatusText(status),
                      style: TextStyle(color: AppColors.titleColor, fontSize: Dimensions.value_16)),
                );
              }).toList(),
              onChanged: (Status? newValue) {
                if (newValue != null) {
                  controller.updateOrderDetailStatus(
                    orderDetail.orderDetailId!,
                    newValue.toString().split('.').last,
                  );
                  Get.back();
                }
              },
              dropdownColor: Colors.white,
              style: TextStyle(color: AppColors.titleColor, fontSize: Dimensions.value_16),
              icon: const Icon(Icons.arrow_drop_down, color: AppColors.mainColor),
              underline: Container(height: 2, color: AppColors.mainColor),
            ),
          ],
        ),
      ),
    );
  }
}
