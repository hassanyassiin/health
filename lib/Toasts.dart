import 'package:flutter/material.dart';

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
      backgroundColor: back_ground_color ?? Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 35),
      duration: Duration(seconds: duration),
      content: GestureDetector(
        onTap: onTap,
        child: Container(
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                size: 25,
                icon ?? Icons.error_outline_rounded,
                color: text_color ?? Colors.white,
              ),
              SizedBox(width: 20),
              Flexible(child: Text(text)),
            ],
          ),
        ),
      ),
    ),
  );
}
