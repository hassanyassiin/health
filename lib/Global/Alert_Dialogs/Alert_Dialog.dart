import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../Global/Functions/Colors.dart';

import '../../../Global/Widgets/Texts.dart';

Future<void> C_Alert_Dialog({
  required BuildContext context,
  required String title,
  required String content,
  Color title_color = Colors.black,
  Color? content_color,
  required String button_one_title,
  Color? button_one_color,
  String? button_two_title,
  Color button_two_color = Colors.black,
  bool is_only_one_button = true,
  void Function()? button_two_function,
  void Function()? button_one_function,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      return WillPopScope(
        onWillPop: () => Future.value(false),
        child: AlertDialog(
          backgroundColor: Get_White,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.h),
          ),
          alignment: Alignment.center,
          titlePadding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 2.w),
          title: C_Text(
            text: title,
            font_size: 2,
            weight: 'Bold',
            color: title_color,
            text_align: TextAlign.center,
          ),
          content: C_Text(
            text: content,
            font_size: 1.8,
            weight: '500',
            color: content_color ?? Get_Grey,
            text_align: TextAlign.center,
          ),
          contentPadding: EdgeInsets.only(bottom: 2.5.h, right: 2.w, left: 2.w),
          actionsOverflowAlignment: OverflowBarAlignment.center,
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            const Divider(thickness: 0.5),
            GestureDetector(
              onTap: button_one_function ?? () => Navigator.pop(context),
              child: ColoredBox(
                color: Get_Trans,
                child: SizedBox(
                  width: double.infinity,
                  height: 4.5.h,
                  child: Align(
                    alignment: Alignment.center,
                    child: C_Text(
                      font_size: 2,
                      text: button_one_title,
                      color: button_one_color ?? Get_Primary,
                    ),
                  ),
                ),
              ),
            ),
            if (!is_only_one_button) const Divider(thickness: 0.5),
            if (!is_only_one_button)
              GestureDetector(
                onTap: button_two_function ?? () => Navigator.pop(context),
                child: ColoredBox(
                  color: Get_Trans,
                  child: SizedBox(
                    width: double.infinity,
                    height: 4.5.h,
                    child: Align(
                      alignment: Alignment.center,
                      child: C_Text(
                        font_size: 2,
                        text: button_two_title!,
                        color: button_two_color,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    },
  );
}
