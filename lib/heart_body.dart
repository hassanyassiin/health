import 'package:flutter/material.dart';
import 'package:health_app/Global/Functions/Colors.dart';
import 'package:health_app/Global/Widgets/AppBar.dart';
import 'package:health_app/Global/Widgets/Texts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Heart_Body extends StatelessWidget {
  final int steps;
  final int heart_rate;
  final double blood_pressure;
  final int blood_oxygen;
  final double sleep;
  final int hrv;

  const Heart_Body({
    required this.steps,
    required this.sleep,
    required this.hrv,
    required this.heart_rate,
    required this.blood_pressure,
    required this.blood_oxygen,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get_Black45,
      appBar: C_AppBar(
        leading_widget: GestureDetector(
          child: UnconstrainedBox(
            child: Container(
              padding: EdgeInsets.all(0.25.h),
              decoration: BoxDecoration(
                color: Get_Grey,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, color: Get_Black, size: 2.5.h),
            ),
          ),
        ),
        title: 'HEALTH MONITOR',
        appBar_color: Get_Black45,
        title_size: 2,
        title_color: Get_White,
      ),
      body: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Image.asset('assets/photos/blood.png'),
              Container(
                padding: EdgeInsets.all(3.h),
                decoration: BoxDecoration(
                  color: Get_Black,
                  shape: BoxShape.circle,
                ),
                child: Column(
                  children: [
                    Icon(Icons.favorite, color: Get_Grey, size: 1.6.h),
                    SizedBox(height: 0.5.h),
                    C_Text(
                      text: heart_rate.toString(),
                      font_size: 3.5,
                      weight: 'Bold',
                      color: Get_White,
                    ),
                    SizedBox(height: 0.2.h),
                    C_Text(
                      text: 'BPM',
                      font_size: 1.1,
                      weight: 'Bold',
                      color: Get_Grey,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          C_Text(
            text: 'Live Health Data',
            font_size: 1.8,
            color: Get_White,
            weight: 'Bold',
          ),
          Wrap(
            children: <Widget>[
              C_Container(
                title: 'Heart Rate',
                a_text: heart_rate.toString(),
                b_text: 'bpm',
                note: 'within 70 - 95',
              ),
              SizedBox(width: 5.w),
              C_Container(
                title: 'Blood Oxygen',
                a_text: blood_oxygen.toString(),
                b_text: '%',
                note: 'within 95 - 99',
              ),
              SizedBox(width: 5.w),
              C_Container(
                title: 'Blood Pressure',
                a_text: blood_pressure.toString(),
                b_text: 'mmHg',
                note: 'ideal < 120/80',
              ),
              SizedBox(width: 5.w),
              C_Container(
                title: 'Steps',
                a_text: steps.toString(),
                b_text: 'steps',
                note: 'goal: 10,000',
              ),
              SizedBox(width: 5.w),
              C_Container(
                title: 'Sleep',
                a_text: (sleep / 60).toStringAsFixed(2),
                b_text: 'hrs',
                note: 'Ideal: 7-9 hrs',
              ),
              SizedBox(width: 5.w),
              C_Container(
                title: 'HRV',
                a_text: hrv.toString(),
                b_text: 'ms',
                note: 'higher is better',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget C_Container({
  required String title,
  required String a_text,
  required String b_text,
  required String note,
}) {
  return Container(
    width: 45.w,
    margin: EdgeInsets.only(top: 3.h),
    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
    decoration: BoxDecoration(
      color: Get_Grey50,
      borderRadius: BorderRadius.all(Radius.circular(1.h)),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Icon(Icons.favorite, color: Get_Grey, size: 2.3.h),
            // SizedBox(width: 2.w),
            C_Text(text: title, weight: '600', font_size: 1.7, color: Get_Grey),
          ],
        ),
        SizedBox(height: 1.h),
        C_Rich_Text(
          a_text: a_text,
          a_size: 3.5,
          a_weight: 'Bold',
          a_color: Get_White,
          b_color: Get_White,
          b_size: 1.5,
          b_text: b_text,
          b_weight: 'Bold',
        ),
        SizedBox(height: 2.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.3.h),
          decoration: BoxDecoration(
            color: Get_Cyan.withOpacity(0.6),
            borderRadius: BorderRadius.all(Radius.circular(0.5.h)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Icon(Icons.check, color: Get_White, weight: 1000, size: 2.h),
              SizedBox(width: 1.w),
              C_Text(
                text: note,
                max_lines: 1,
                font_size: 1.4,
                color: Get_White,
                weight: 'Bold',
              ),
            ],
          ),
        ),
        SizedBox(height: 1.2.h),
      ],
    ),
  );
}
