import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_food_delivery/pages/account/account_page.dart';
import 'package:mobile_food_delivery/pages/home/main_food_page.dart';
import 'package:mobile_food_delivery/pages/order/view_order_page.dart';
import 'package:mobile_food_delivery/routes/bottom_navigation_helper.dart';
import 'package:mobile_food_delivery/utils/colors.dart';

class HomePage extends StatelessWidget {
  final BottomNavigationHelper bottomNavigationHelper = Get.put(BottomNavigationHelper());

  HomePage({super.key});

  final List<Widget> pages = [
    const MainFoodPage(),
    const ViewOrderPage(),
    const AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => pages[bottomNavigationHelper.selectedIndex.value]),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        selectedItemColor: AppColors.mainColor,
        unselectedItemColor: Colors.amberAccent,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedFontSize: 0.0,
        unselectedFontSize: 0.0,
        currentIndex: bottomNavigationHelper.selectedIndex.value,
        onTap: bottomNavigationHelper.changeIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      )),
    );
  }
}
