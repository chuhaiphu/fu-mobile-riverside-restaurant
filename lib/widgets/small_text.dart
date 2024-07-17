import 'package:flutter/cupertino.dart';
import 'package:mobile_food_delivery/utils/colors.dart';

class SmallText extends StatelessWidget {
  final Color? color;
  final String text;
  double size;
  double height;

  SmallText({
    super.key,
    this.color = AppColors.textColor,
    required this.text,
    this.size = 12,
    this.height = 1.2
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Roboto',
        color: color,
        fontSize: size,
        height: height
      ),
    );
  }
}
