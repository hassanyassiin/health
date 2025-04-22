import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:carp_serializable/carp_serializable.dart';
import 'package:health_app/Toasts.dart';
import 'package:health_app/heart_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'home_screen.dart';

// Global Health instance
final health = Health();

/// List of data types available on iOS
List<HealthDataType> dataTypesIOS = [
  HealthDataType.BLOOD_OXYGEN,
  HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
  HealthDataType.SLEEP_ASLEEP,
  HealthDataType.HEART_RATE,
  HealthDataType.HEART_RATE_VARIABILITY_SDNN,

  ///////////
  // HealthDataType.ACTIVE_ENERGY_BURNED,
  // HealthDataType.AUDIOGRAM,
  // HealthDataType.BASAL_ENERGY_BURNED,
  // HealthDataType.BLOOD_GLUCOSE,

  // HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
  // HealthDataType.BODY_FAT_PERCENTAGE,
  // HealthDataType.BODY_MASS_INDEX,
  // HealthDataType.BODY_TEMPERATURE,
  // HealthDataType.DIETARY_CARBS_CONSUMED,
  // HealthDataType.DIETARY_CAFFEINE,
  // HealthDataType.DIETARY_ENERGY_CONSUMED,
  // HealthDataType.DIETARY_FATS_CONSUMED,
  // HealthDataType.DIETARY_PROTEIN_CONSUMED,
  // HealthDataType.ELECTRODERMAL_ACTIVITY,
  // HealthDataType.FORCED_EXPIRATORY_VOLUME,

  // HealthDataType.HEIGHT,
  // HealthDataType.RESPIRATORY_RATE,
  // HealthDataType.PERIPHERAL_PERFUSION_INDEX,
  // HealthDataType.STEPS,
  // HealthDataType.WAIST_CIRCUMFERENCE,
  // HealthDataType.WEIGHT,
  // HealthDataType.FLIGHTS_CLIMBED,
  // HealthDataType.DISTANCE_WALKING_RUNNING,
  // HealthDataType.MINDFULNESS,
  // HealthDataType.SLEEP_AWAKE,
  // HealthDataType.SLEEP_IN_BED,
  // HealthDataType.SLEEP_LIGHT,
  // HealthDataType.SLEEP_DEEP,
  // HealthDataType.SLEEP_REM,
  // HealthDataType.WATER,
  // HealthDataType.EXERCISE_TIME,
  // HealthDataType.WORKOUT,
  // HealthDataType.HEADACHE_NOT_PRESENT,
  // HealthDataType.HEADACHE_MILD,
  // HealthDataType.HEADACHE_MODERATE,
  // HealthDataType.HEADACHE_SEVERE,
  // HealthDataType.HEADACHE_UNSPECIFIED,
  // HealthDataType.LEAN_BODY_MASS,
  // note that a phone cannot write these ECG-based types - only read them
  // HealthDataType.ELECTROCARDIOGRAM,
  // HealthDataType.HIGH_HEART_RATE_EVENT,
  // HealthDataType.IRREGULAR_HEART_RATE_EVENT,
  // HealthDataType.LOW_HEART_RATE_EVENT,
  // HealthDataType.RESTING_HEART_RATE,
  // HealthDataType.WALKING_HEART_RATE,
  // HealthDataType.ATRIAL_FIBRILLATION_BURDEN,
  // HealthDataType.NUTRITION,
  // HealthDataType.GENDER,
  // HealthDataType.BLOOD_TYPE,
  // HealthDataType.BIRTH_DATE,
  // HealthDataType.MENSTRUATION_FLOW,
  // HealthDataType.WATER_TEMPERATURE,
  // HealthDataType.UNDERWATER_DEPTH,
  // HealthDataType.UV_INDEX,
];

/// List of data types available on Android.
///
/// Note that these are only the ones supported on Android's Health Connect API.
/// Android's Health Connect has more types that we support in the [HealthDataType]
/// enumeration.
List<HealthDataType> dataTypesAndroid = [
  HealthDataType.ACTIVE_ENERGY_BURNED,
  HealthDataType.BASAL_ENERGY_BURNED,
  HealthDataType.BLOOD_GLUCOSE,
  HealthDataType.BLOOD_OXYGEN,
  HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
  HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
  HealthDataType.BODY_FAT_PERCENTAGE,
  HealthDataType.HEIGHT,
  HealthDataType.WEIGHT,
  HealthDataType.LEAN_BODY_MASS,
  // HealthDataType.BODY_MASS_INDEX,
  HealthDataType.BODY_TEMPERATURE,
  HealthDataType.HEART_RATE,
  HealthDataType.HEART_RATE_VARIABILITY_RMSSD,
  HealthDataType.STEPS,
  HealthDataType.DISTANCE_DELTA,
  HealthDataType.RESPIRATORY_RATE,
  HealthDataType.SLEEP_ASLEEP,
  HealthDataType.SLEEP_AWAKE_IN_BED,
  HealthDataType.SLEEP_AWAKE,
  HealthDataType.SLEEP_DEEP,
  HealthDataType.SLEEP_LIGHT,
  HealthDataType.SLEEP_OUT_OF_BED,
  HealthDataType.SLEEP_REM,
  HealthDataType.SLEEP_UNKNOWN,
  HealthDataType.SLEEP_SESSION,
  HealthDataType.WATER,
  HealthDataType.WORKOUT,
  HealthDataType.RESTING_HEART_RATE,
  HealthDataType.FLIGHTS_CLIMBED,
  HealthDataType.NUTRITION,
  HealthDataType.TOTAL_CALORIES_BURNED,
  HealthDataType.MENSTRUATION_FLOW,
];

List<HealthDataType> get types =>
    (Platform.isAndroid)
        ? dataTypesAndroid
        : (Platform.isIOS)
        ? dataTypesIOS
        : [];

List<HealthDataAccess> get permissions =>
    types
        .map(
          (type) =>
              // can only request READ permissions to the following list of types on iOS
              [
                    HealthDataType.WALKING_HEART_RATE,
                    HealthDataType.ELECTROCARDIOGRAM,
                    HealthDataType.HIGH_HEART_RATE_EVENT,
                    HealthDataType.LOW_HEART_RATE_EVENT,
                    HealthDataType.IRREGULAR_HEART_RATE_EVENT,
                    HealthDataType.EXERCISE_TIME,
                  ].contains(type)
                  ? HealthDataAccess.READ
                  : HealthDataAccess.READ_WRITE,
        )
        .toList();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          home: const Home_Screen(),
          debugShowCheckedModeBanner: false,
        );
      },
    ),
  );
}
