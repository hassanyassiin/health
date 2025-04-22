import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../Global/Functions/Colors.dart';

import '../../../Global/Widgets/Texts.dart';

void Show_Text_Toast({
  required BuildContext context,
  required String text,
  IconData? icon,
  Color? back_ground_color,
  void Function()? onTap,
  int duration = 3,
  Color? text_color,
  String weight = '500',
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: back_ground_color ?? Get_Grey900_90,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(1.5.h))),
      padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.5.w),
      duration: Duration(seconds: duration),
      content: GestureDetector(
        onTap: onTap,
        child: Container(
          color: Get_Trans,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                size: 2.5.h,
                icon ?? Icons.error_outline_rounded,
                color: text_color ?? Get_White,
              ),
              SizedBox(width: 4.w),
              Flexible(
                child: C_Text(
                  text: text,
                  weight: weight,
                  font_size: 1.45,
                  color: text_color ?? Get_White,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
