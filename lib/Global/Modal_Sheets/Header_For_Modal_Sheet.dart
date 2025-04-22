import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../Global/Functions/Colors.dart';

import '../../../Global/Widgets/Texts.dart';

Widget Header_For_Modal_Sheet({
  String? title,
  Color? text_color,
  bool is_title_centered = true,
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: is_title_centered
        ? CrossAxisAlignment.center
        : CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      SizedBox(
        height: 5.h,
        width: double.infinity,
        child: UnconstrainedBox(
          child: Container(
            width: 10.w,
            alignment: Alignment.center,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: Get_Grey300,
              borderRadius: BorderRadius.all(Radius.circular(1.5.h)),
            ),
          ),
        ),
      ),
      if (title != null)
        Padding(
          padding: EdgeInsets.only(left: 4.w, top: 0.5.h, bottom: 1.5.h),
          child: C_Text(
            text: title,
            weight: '600',
            font_size: 2.1,
            color: text_color ?? Get_Black,
          ),
        ),
    ],
  );
}
