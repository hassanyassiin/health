import 'package:flutter/material.dart';
import 'package:health_app/Global/Widgets/Buttons.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../Global/Functions/Colors.dart';

import '../../../Global/Widgets/Texts.dart';

import '../../../Global/Modal_Sheets/Header_For_Modal_Sheet.dart';

Future<dynamic> Show_Options_List_Tiles_Modal_Sheet({
  required String title,
  bool is_title_centered = false,
  required BuildContext context,
  required List<String> texts,
}) async {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Get_Black,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(2.h)),
    ),
    builder: (ctx) {
      return SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Header_For_Modal_Sheet(
              title: title,
              text_color: Get_White,
              is_title_centered: true,
            ),
            // const Divider(thickness: 0.4),
            ...texts.map((list_tile) {
              return Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.5.h),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 0.5, color: Get_Grey),
                  ),
                ),
                child: C_Text(
                  text: list_tile,
                  font_size: 1.8,
                  weight: 'Bold',
                  color: Get_White,
                ),
              );
            }),
            SizedBox(height: 3.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w,vertical: 2.h),
              child: Container_Button(
                title: 'Done',
                background_color: Get_Cyan,
                onTap: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget List_Tile_With_Mini_Divider({
  required String text,
  required IconData icon,
  required Color icon_color,
  required Color text_color,
  required void Function() onTap,
}) {
  return SizedBox(
    height: 7.h,
    width: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GestureDetector(
          onTap: onTap,
          child: ColoredBox(
            color: Get_Trans,
            child: SizedBox(
              height: 6.h,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    width: 16.w,
                    height: 4.h,
                    child: Icon(icon, size: 3.h, color: icon_color),
                  ),
                  SizedBox(
                    width: 84.w,
                    height: 4.h,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: C_Text(
                        text: text,
                        weight: '500',
                        font_size: 1.9,
                        color: text_color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: SizedBox(
            height: 1.h,
            width: 84.w,
            child: const Divider(thickness: 0.4),
          ),
        ),
      ],
    ),
  );
}
