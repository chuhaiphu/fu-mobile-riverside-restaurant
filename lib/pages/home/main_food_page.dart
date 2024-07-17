import 'package:flutter/material.dart';
import 'package:mobile_food_delivery/pages/home/food_page_body.dart';
import 'package:mobile_food_delivery/utils/dimensions.dart';

class MainFoodPage extends StatefulWidget {
  const MainFoodPage({super.key});

  @override
  _MainFoodPageState createState() => _MainFoodPageState();
}

class _MainFoodPageState extends State<MainFoodPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // * header app bar
          Container(
            margin: EdgeInsets.only(
                top: Dimensions.value_45, bottom: Dimensions.value_15),
            padding: EdgeInsets.only(
                left: Dimensions.value_20, right: Dimensions.value_20),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                ),
              ],
            ),
          ),

          // * body
          const Expanded(
            child: SingleChildScrollView(
              child: FoodPageBody(),
            ),
          )
        ],
      ),
    );
  }
}
