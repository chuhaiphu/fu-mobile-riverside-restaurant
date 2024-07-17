import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_food_delivery/utils/colors.dart';
import 'package:mobile_food_delivery/utils/dimensions.dart';

class ShowCustomLoader extends StatelessWidget {
  const ShowCustomLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: Dimensions.value_20*5,
        width: Dimensions.value_20*5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.value_20*5/2),
          color: AppColors.mainColor
        ),
        alignment: Alignment.center,
        child: const CircularProgressIndicator(color: Colors.white,),
      ),
    );
  }
}
