import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:health_app/Global/Functions/Colors.dart';
import 'package:health_app/Global/Widgets/Buttons.dart';
import 'package:health_app/Global/Widgets/Texts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'heart_screen.dart';
import 'main.dart';

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:health_app/Toasts.dart';
import 'package:carp_serializable/carp_serializable.dart';
import 'package:permission_handler/permission_handler.dart';

import 'main.dart';

class Home_Screen extends StatefulWidget {
  const Home_Screen({super.key});
  static const routeName = '/Home';

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {
  @override
  Widget build(BuildContext context) {
    Future<void> authorize() async {
      // If we are trying to read Step Count, Workout, Sleep or other data that requires
      // the ACTIVITY_RECOGNITION permission, we need to request the permission first.
      // This requires a special request authorization call.
      //
      // The location permission is requested for Workouts using the Distance information.
      await Permission.activityRecognition.request();
      await Permission.location.request();

      // Check if we have health permissions
      bool? hasPermissions = await health.hasPermissions(
        types,
        permissions: permissions,
      );

      // hasPermissions = false because the hasPermission cannot disclose if WRITE access exists.
      // Hence, we have to request with WRITE as well.
      hasPermissions = false;

      bool authorized = false;
      if (!hasPermissions) {
        // requesting access to the data types before reading them
        try {
          authorized = await health.requestAuthorization(
            types,
            permissions: permissions,
          );

          // request access to read historic data
          await health.requestHealthDataHistoryAuthorization();
        } catch (error) {
          debugPrint("Exception in authorize: $error");
        }
      }

      if (!authorized) {
        Show_Text_Toast(
          context: context,
          weight: '600',
          text: 'Authorization required to proceed.',
          icon: Icons.error,
          back_ground_color: Get_Red200,
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HealthApp()),
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(title: Text('Heart Rate')),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 0.46,
            child: Image.asset('assets/photos/tre.png'),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 15.h, left: 2.w),
            child: AnimatedTextKit(
              pause: Duration.zero,
              isRepeatingAnimation: true,
              repeatForever: true,
              animatedTexts: [
                FadeAnimatedText(
                  'Welcome Back',
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20, //
                    // Change this to your desired size
                  ),
                ),
                FadeAnimatedText(
                  'Monitor Your Heart with Confidence',
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                FadeAnimatedText(
                  'Stay in Control of Your Health',
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
              onTap: () {},
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 6.h, left: 2.w),
            child: SizedBox(
              height: 5.5.h,
              child: Container_Button(
                title: 'CONTINUE',
                vertical_padding: 1,
                font_size: 2,
                background_color: Get_Cyan,
                onTap: authorize,
                right_icon: Icons.arrow_forward_ios,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
