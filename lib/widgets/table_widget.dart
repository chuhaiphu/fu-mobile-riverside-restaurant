import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_food_delivery/controllers/table_controller.dart';
import 'package:mobile_food_delivery/models/table.dart';
import 'package:mobile_food_delivery/utils/colors.dart';

class TableWidget extends StatelessWidget {
  final Tables table;
  final double width;
  final double height;
  final TableController controller = Get.find();

  TableWidget({required this.table, this.width = 50, this.height = 50});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TableController>(
      builder: (controller) => GestureDetector(
        onTap: table.isAvailable == true ? () => controller.toggleTableSelection(table) : null,
        child: SizedBox(
          width: width,
          height: height,
          child: Card(
            color: _getTableColor(),
            child: Center(
              child: Text(table.name!),
            ),
          ),
        ),
      ),
    );
  }

  Color _getTableColor() {
    if (table.isAvailable != true) {
      return Colors.grey;
    }
    return controller.isTableSelected(table) ? AppColors.iconColor2 : AppColors.buttonBackgroundColor;
  }
}
