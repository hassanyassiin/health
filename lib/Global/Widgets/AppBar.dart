import 'package:flutter/material.dart';

import '../../../Global/Functions/Colors.dart';

import '../../../Global/Widgets/Texts.dart';

PreferredSizeWidget C_AppBar({
  String? title,
  double? title_size,
  Color appBar_color = Colors.white,
  bool is_title_centered = true,
  double? leading_width,
  Widget? leading_widget,
  Widget? title_widget,
  PreferredSizeWidget? bottom_widget,
  bool is_show_divider = false,
  List<Widget>? suffix_widgets,
  double elevation = 0.0,
  Color? elevation_color,
  Color? surface_color,
  Color? title_color,
  double? letter_spacing,
  String weight = '500',
}) {
  return AppBar(
    elevation: elevation,
    surfaceTintColor: surface_color ?? appBar_color,
    shadowColor: elevation_color ?? Get_Shein,
    backgroundColor: appBar_color,
    centerTitle: is_title_centered,
    leading: leading_widget,
    leadingWidth: leading_width,
    iconTheme: const IconThemeData(color: Colors.black),
    title: title_widget ??
        (title != null
            ? C_Text(
                text: title,
                font_size: title_size ?? 2.2,
                weight: weight,
                // family_type: 'A',
                color: title_color ?? Get_Black,
                letter_spacing: letter_spacing,
              )
            : null),
    bottom: bottom_widget ??
        (is_show_divider
            ? PreferredSize(
                preferredSize: const Size.fromHeight(0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 0.5, color: Get_Grey300),
                    ),
                  ),
                ),
              )
            : null),
    actions: suffix_widgets,
  );
}
