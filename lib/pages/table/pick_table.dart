// lib/pages/table/pick_table.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_food_delivery/controllers/table_controller.dart';
import 'package:mobile_food_delivery/routes/bottom_navigation_helper.dart';
import 'package:mobile_food_delivery/utils/dimensions.dart';
import 'package:mobile_food_delivery/widgets/app_icon.dart';
import 'package:mobile_food_delivery/widgets/area_widget.dart';

class PickTable extends StatefulWidget {
  const PickTable({Key? key}) : super(key: key);

  @override
  State<PickTable> createState() => _PickTableState();
}

class _PickTableState extends State<PickTable> {
  final TableController controller = Get.find<TableController>();
  final BottomNavigationHelper bottomNavigationHelper = Get.find<BottomNavigationHelper>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getAreas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(0),
          child: GestureDetector(
            onTap: () => Get.back(),
            child: AppIcon(
              icon: Icons.arrow_back_ios,
              iconColor: Colors.black,
              backgroundColor: Colors.transparent,
              iconSize: Dimensions.value_24,
            ),
          ),
        ),
        leadingWidth: Dimensions.screenWidth / 6,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: Dimensions.value_10, right: Dimensions.value_10),
        child: GetBuilder<TableController>(
          builder: (controller) {
            if (!controller.isLoaded) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                if (controller.getUpstairsArea() != null)
                  AreaWidget(
                    area: controller.getUpstairsArea()!,
                    columns: 8,
                  ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 7,
                        child: ListView.builder(
                          itemCount: controller.getCenterAreas().length,
                          itemBuilder: (context, index) {
                            return AreaWidget(
                              area: controller.getCenterAreas()[index],
                              columns: 5,
                            );
                          },
                        ),
                      ),
                      if (controller.getSideArea() != null)
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: SingleChildScrollView(
                            child: AreaWidget(
                              area: controller.getSideArea()!,
                              columns: 2,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: GetBuilder<TableController>(
        builder: (controller) {
          return controller.selectedTable != null
            ? FloatingActionButton(
                child: const Icon(Icons.check),
                onPressed: () {
                  Get.back(result: {
                    'id': controller.selectedTable!.tableId,
                    'name': controller.selectedTable!.name
                  });
                },
              )
            : const SizedBox.shrink();
        },
      ),
    );
  }
}
