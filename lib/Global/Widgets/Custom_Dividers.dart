import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../Global/Functions/Colors.dart';

Widget SHEIN_Custom_Divider({
  double bottom_padding = 2,
  double top_padding = 2,
}) {
  return Container(
    margin: EdgeInsets.only(top: top_padding.h, bottom: bottom_padding.h),
    height: 1.h,
    width: double.infinity,
    color: Get_Shein,
  );
}
