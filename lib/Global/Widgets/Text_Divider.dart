import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../Global/Functions/Colors.dart';

import '../../../Global/Widgets/Texts.dart';

Widget Text_Divider({
  required String text,
  double text_size = 1.55,
  double top_padding = 2.5,
  double bottom_padding = 2.5,
  Color? text_color,
}) {
  return Padding(
    padding: EdgeInsets.only(top: top_padding.h, bottom: bottom_padding.h),
    child: Stack(
      alignment: Alignment.center,
      children: <Widget>[
        const Divider(thickness: 0.5),
        Container(
          color: Get_White,
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.25.h),
          child: C_Text(
            text: text,
            weight: '500',
            font_size: text_size,
            text_align: TextAlign.center,
            color: text_color ?? Get_Black38,
          ),
        ),
      ],
    ),
  );
}
