import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../Global/Functions/Colors.dart';

import '../../../Global/Widgets/Texts.dart';

Widget C_Rounded_Button({
  required String title,
  bool is_enable_shadow = true,
  double text_height = 1.5,
  Color? button_color,
  Color text_color = Colors.white,
  double border_radius = 2,
  required void Function()? onPressed,
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: button_color ?? Get_Primary,
      shadowColor: is_enable_shadow ? null : Get_Trans,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(border_radius.h),
      ),
    ),
    onPressed: onPressed,
    child: C_Text(
      text: title,
      weight: '500',
      color: text_color,
      font_size: text_height,
      text_align: TextAlign.center,
    ),
  );
}

Widget Text_And_Icon_Button({
  required String title,
  required IconData icon,
  required Color button_color,
  required Color text_color,
  required void Function()? onPressed,
  double right_margin = 0.0,
}) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      margin: EdgeInsets.only(right: right_margin.w, left: 0),
      padding: EdgeInsets.only(
        top: 1.h,
        bottom: 1.h,
        left: 3.1.w,
        right: 3.5.w,
      ),
      decoration: BoxDecoration(
        color: button_color,
        borderRadius: BorderRadius.all(Radius.circular(0.9.h)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 1.75.h, color: text_color),
          SizedBox(width: 2.5.w),
          C_Text(
            text: title,
            font_size: 1.65,
            color: text_color,
            weight: '500',
          ),
        ],
      ),
    ),
  );
}

Widget Container_Button({
  required String title,
  double font_size = 1.7,
  double border_radius = 0.9,
  double vertical_margin = 0,
  double right_margin = 0,
  double left_margin = 0,
  double vertical_padding = 1.5,
  Color? background_color,
  String weight = '600',
  IconData? icon,
  IconData? right_icon,
  Color text_color = Colors.white,
  required void Function() onTap,
  Color border_color = Colors.transparent,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: EdgeInsets.only(
        right: right_margin.w,
        left: left_margin.w,
        top: vertical_margin.h,
        bottom: vertical_margin.h,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 2.w,
        vertical: vertical_padding.h,
      ),
      decoration: BoxDecoration(
        color: background_color ?? Get_Black80,
        border: Border.all(color: border_color, width: 0.5),
        borderRadius: BorderRadius.all(Radius.circular(border_radius.h)),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          const SizedBox(),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (icon != null)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 1.w),
                    child: Icon(
                      icon,
                      size: (font_size + 0.3).h,
                      color: text_color,
                    ),
                  ),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: C_Text(
                      text: title,
                      weight: '600',
                      max_lines: 1,
                      color: text_color,
                      font_size: font_size,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (right_icon != null)
            Icon(
              right_icon,
              size: (font_size).h,
              weight: 10000,
              color: text_color,
            )
          else
            const SizedBox(),
        ],
      ),
    ),
  );
}
