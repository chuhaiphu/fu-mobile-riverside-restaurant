import 'package:flutter/material.dart';
import 'package:mobile_food_delivery/utils/dimensions.dart';
import 'package:mobile_food_delivery/widgets/app_icon.dart';
import 'package:mobile_food_delivery/widgets/big_text.dart';

class AccountProp extends StatelessWidget {
  AppIcon appIcon;
  BigText bigText;
  AccountProp({super.key, required this.appIcon, required this.bigText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: Dimensions.value_10,
        bottom: Dimensions.value_10,
        left: Dimensions.value_20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 1,
            offset: Offset(0, 5),
            color: Colors.grey.withOpacity(0.2),
          )
        ]
      ),
      child: Row (
        children: [
          appIcon,
          SizedBox(width: Dimensions.value_10,),
          Flexible(child: bigText)
        ],
      ),
    );
  }
}
