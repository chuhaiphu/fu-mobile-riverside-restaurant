import 'package:flutter/material.dart';
import 'package:mobile_food_delivery/utils/dimensions.dart';
import 'package:mobile_food_delivery/widgets/big_text.dart';
import 'package:mobile_food_delivery/widgets/small_text.dart';

class AppColumn extends StatelessWidget {
  final String text;
  final String ingredients;
  const AppColumn({super.key, required this.text, required this.ingredients});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BigText(text: text, size: Dimensions.value_20),
        SizedBox(height: Dimensions.value_10 / 2),
        SmallText(text: ingredients, size: Dimensions.value_15 - 1,),
        SizedBox(height: Dimensions.value_10 / 2),
        const Row(
          children: [
            Icon(Icons.local_fire_department, color: Colors.red),
            SizedBox(width: 5),
            Text(
              "MÓN NHIỀU NGƯỜI THÍCH",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
