import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_food_delivery/controllers/table_controller.dart';
import 'package:mobile_food_delivery/models/area.dart';
import 'package:mobile_food_delivery/models/table.dart';
import 'package:mobile_food_delivery/widgets/table_widget.dart';

class AreaWidget extends StatelessWidget {
  final Area area;
  final int columns;
  final TableController controller = Get.find();

  AreaWidget({required this.area, required this.columns});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TableController>(
      builder: (controller) {
        List<Tables> tables = controller.getTablesForArea(area);
        return Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Text(area.name!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              LayoutBuilder(
                builder: (context, constraints) {
                  final double tableWidth = constraints.maxWidth / columns;
                  return Wrap(
                    children: tables.map((table) => SizedBox(
                      width: tableWidth,
                      height: 40, // Fixed height for each table
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: TableWidget(
                          table: table,
                          width: tableWidth - 4, // Subtract padding
                          height: 36, // Subtract padding
                        ),
                      ),
                    )).toList(),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
