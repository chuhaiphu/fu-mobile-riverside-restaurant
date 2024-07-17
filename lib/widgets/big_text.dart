import 'package:flutter/cupertino.dart';
import 'package:mobile_food_delivery/utils/colors.dart';
import 'package:mobile_food_delivery/utils/dimensions.dart';

class BigText extends StatelessWidget {
  final Color? color;
  final String text;
  double size;
  TextOverflow overflow;
  final GestureDetector? gestureDetector;

  BigText({
    super.key,
    this.color = AppColors.mainBlackColor,
    required this.text,
    this.size = 0,
    this.overflow = TextOverflow.ellipsis,
    this.gestureDetector,
  });

  @override
  Widget build(BuildContext context) {
    Widget textWidget = Text(
      text,
      maxLines: 1,
      overflow: overflow,
      style: TextStyle(
        fontFamily: 'Roboto',
        color: color,
        fontSize: size == 0 ? Dimensions.value_20 : size,
        fontWeight: FontWeight.w400
      ),
    );

    return gestureDetector != null
        ? GestureDetector(
            onTap: gestureDetector!.onTap,
            child: textWidget,
          )
        : textWidget;
  }
}