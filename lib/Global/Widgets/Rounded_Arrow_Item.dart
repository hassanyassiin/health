import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../Global/Functions/Colors.dart';

Widget Rounded_Arrow_Item({
  double icon_size = 2.6,
  double padding = 1.5,
}) {
  return Container(
    padding: EdgeInsets.all(padding.h),
    decoration: BoxDecoration(
      color: Get_White,
      shape: BoxShape.circle,
      boxShadow: const [
        BoxShadow(
          offset: Offset(1, 1),
          blurRadius: 7,
          color: Color(0xFFe0e0e0),
        ),
        BoxShadow(
          offset: Offset(1, 1),
          blurRadius: 7,
          color: Color(0xFFe0e0e0),
        ),
      ],
    ),
    child: Icon(
      size: icon_size.h,
      Icons.arrow_forward_ios_rounded,
    ),
  );
}
