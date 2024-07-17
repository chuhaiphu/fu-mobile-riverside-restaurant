import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_food_delivery/controllers/order_controller.dart';
import 'package:mobile_food_delivery/controllers/popular_dish_controller.dart';
import 'package:mobile_food_delivery/controllers/total_price_controller.dart';
import 'package:mobile_food_delivery/models/dish.dart';
import 'package:mobile_food_delivery/pages/order/create_order_page.dart';
import 'package:mobile_food_delivery/pages/order/order_selection_page.dart';
import 'package:mobile_food_delivery/routes/route_helper.dart';
import 'package:mobile_food_delivery/utils/colors.dart';
import 'package:mobile_food_delivery/utils/dimensions.dart';
import 'package:mobile_food_delivery/widgets/app_icon.dart';
import 'package:mobile_food_delivery/widgets/big_text.dart';
import 'package:mobile_food_delivery/widgets/expandable_text.dart';

class PopularFoodDetail extends StatelessWidget {
  int pageId;
  PopularFoodDetail({required this.pageId, super.key});

  @override
  Widget build(BuildContext context) {
    Dish dish = Get.find<PopularProductController>().popularProductList[pageId];
    final TotalPriceController totalPriceController = Get.put(TotalPriceController());

    void _showOrderSelectionDialog(BuildContext context) {
      final orderController = Get.find<OrderController>();
      final popularProduct = Get.find<PopularProductController>();

      void _navigateToCreateOrderPage() {
        Get.to(() => CreateOrderPage(
              dish: dish,
              initialQuantity: popularProduct.quantity,
              initialTotalPrice: dish.dishPrice! * popularProduct.quantity,
            ));
      }

      if (orderController.orders.isEmpty) {
        _navigateToCreateOrderPage();
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Thêm đơn hàng'),
              content: const Text(
                  'Bạn muốn thêm món này vào đơn hàng cũ hay tạo một đơn hàng mới?'),
              actions: [
                TextButton(
                  child: const Text('Đơn hàng đã có'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Get.to(() => OrderSelectionPage(
                          dish: dish,
                          initialQuantity: popularProduct.quantity,
                        ));
                  },
                ),
                TextButton(
                  child: const Text('Tạo đơn hàng mới'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _navigateToCreateOrderPage();
                  },
                ),
              ],
            );
          },
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // * background image
          Positioned(
            left: 0,
            right: 0,
            child: Container(
              width: double.maxFinite,
              height: Dimensions.popularFoodImgSize,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    dish.imageURL ?? '',
                  ),
                ),
              ),
            ),
          ),
          // * top left / top right icons
          Positioned(
            top: Dimensions.value_45,
            left: Dimensions.value_20,
            right: Dimensions.value_20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.toNamed(RouteHelper.getInitial());
                  },
                  child: const AppIcon(icon: Icons.arrow_back_ios),
                ),
              ],
            ),
          ),
          // * food detail introduction
          Positioned(
            left: 0,
            right: 0,
            top: Dimensions.popularFoodImgSize - Dimensions.value_20,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.only(
                  left: Dimensions.value_20, right: Dimensions.value_20, top: Dimensions.value_20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(Dimensions.value_20),
                    topLeft: Radius.circular(Dimensions.value_20)),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: Dimensions.value_20,
                  ),
                  BigText(text: "Giới thiệu thành phần"),
                  Expanded(
                    child: SingleChildScrollView(
                      child: ExpandableText(text: dish.ingredients!),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      // * bottom navigation bar
      bottomNavigationBar: GetBuilder<PopularProductController>(
        builder: (popularProduct) {
          return Container(
            height: Dimensions.bottomHeightBar,
            padding: EdgeInsets.only(
              top: Dimensions.value_30,
              bottom: Dimensions.value_30,
              left: Dimensions.value_20,
              right: Dimensions.value_20,
            ),
            decoration: BoxDecoration(
                color: AppColors.buttonBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimensions.value_20 * 2),
                  topRight: Radius.circular(Dimensions.value_20 * 2),
                )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // * add remove buttons
                Container(
                  padding: EdgeInsets.only(
                    top: Dimensions.value_16,
                    bottom: Dimensions.value_16,
                    left: Dimensions.value_16,
                    right: Dimensions.value_16,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.value_20),
                      color: Colors.white),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          popularProduct.updateQuantity(false);
                          totalPriceController.calculateTotalPriceForOrder(dish.dishId!);
                        },
                        child: const Icon(Icons.remove),
                      ),
                      BigText(text: popularProduct.quantity.toString()),
                      GestureDetector(
                        onTap: () {
                          popularProduct.updateQuantity(true);
                          totalPriceController.calculateTotalPriceForOrder(dish.dishId!);
                        },
                        child: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ),
                // * add to cart
                GestureDetector(
                  onTap: () {
                    _showOrderSelectionDialog(context);
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      top: Dimensions.value_20,
                      bottom: Dimensions.value_20,
                      left: Dimensions.value_20,
                      right: Dimensions.value_20,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.value_20),
                        color: AppColors.mainColor),
                    child: BigText(
                      text: "${dish.dishPrice!}đ | Cho vào đơn hàng", size: Dimensions.value_16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
