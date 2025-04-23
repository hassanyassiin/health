import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:health_app/Global/Modal_Sheets/Show_Options_List_Tiles_Modal_Sheet.dart';
import 'package:health_app/Toasts.dart';
import 'package:carp_serializable/carp_serializable.dart';
import 'package:permission_handler/permission_handler.dart';

import 'heart_body.dart';
import 'main.dart';

class HealthApp extends StatefulWidget {
  const HealthApp({super.key});

  @override
  HealthAppState createState() => HealthAppState();
}

enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTHORIZED,
  AUTH_NOT_GRANTED,
  DATA_ADDED,
  DATA_DELETED,
  DATA_NOT_ADDED,
  DATA_NOT_DELETED,
  STEPS_READY,
  HEALTH_CONNECT_STATUS,
  PERMISSIONS_REVOKING,
  PERMISSIONS_REVOKED,
  PERMISSIONS_NOT_REVOKED,
}

class HealthAppState extends State<HealthApp> {
  var global_steps = 0;
  var global_heart_rate = 70;
  var global_blood_pressure = 8;
  var global_blood_oxygen = 90;
  var global_sleep = 20.0;
  var global_hrv = 30;

  List<HealthDataPoint> _healthDataList = [];
  AppState _state = AppState.DATA_NOT_FETCHED;
  int _nofSteps = 0;
  List<RecordingMethod> recordingMethodsToFilter = [];

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

  // All types available depending on platform (iOS ot Android).
  List<HealthDataType> get types =>
      (Platform.isAndroid)
          ? dataTypesAndroid
          : (Platform.isIOS)
          ? dataTypesIOS
          : [];

  // // Or specify specific types
  // static final types = [
  //   HealthDataType.WEIGHT,
  //   HealthDataType.STEPS,
  //   HealthDataType.HEIGHT,
  //   HealthDataType.BLOOD_GLUCOSE,
  //   HealthDataType.WORKOUT,
  //   HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
  //   HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
  //   // Uncomment this line on iOS - only available on iOS
  //   // HealthDataType.AUDIOGRAM
  // ];

  // Set up corresponding permissions

  // READ only
  // List<HealthDataAccess> get permissions =>
  //     types.map((e) => HealthDataAccess.READ).toList();

  // Or both READ and WRITE
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

  @override
  void initState() {
    // configure the health plugin before use and check the Health Connect status
    health.configure();
    health.getHealthConnectSdkStatus();

    super.initState();

    // addData();
    fetchData();
  }

  /// Install Google Health Connect on this phone.
  Future<void> installHealthConnect() async =>
      await health.installHealthConnect();

  /// Authorize, i.e. get permissions to access relevant health data.
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

    setState(
      () =>
          _state =
              (authorized) ? AppState.AUTHORIZED : AppState.AUTH_NOT_GRANTED,
    );
  }

  /// Gets the Health Connect status on Android.
  Future<void> getHealthConnectSdkStatus() async {
    assert(Platform.isAndroid, "This is only available on Android");

    final status = await health.getHealthConnectSdkStatus();

    setState(() {
      _contentHealthConnectStatus = Text(
        'Health Connect Status: ${status?.name.toUpperCase()}',
      );
      _state = AppState.HEALTH_CONNECT_STATUS;
    });
  }

  /// Fetch data points from the health plugin and show them in the app.
  Future<void> fetchData() async {
    setState(() => _state = AppState.FETCHING_DATA);

    // get data within the last 24 hours
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(hours: 24));

    // Clear old data points
    _healthDataList.clear();

    try {
      // fetch health data
      List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
        types: types,
        startTime: yesterday,
        endTime: now,
        recordingMethodsToFilter: recordingMethodsToFilter,
      );

      // debugPrint(
      //   'Total number of data points: ${healthData.length}. '
      //   '${healthData.length > 100 ? 'Only showing the first 100.' : ''}',
      // );

      // sort the data points by date
      healthData.sort((a, b) => b.dateTo.compareTo(a.dateTo));

      // save all the new data points (only the first 100)
      _healthDataList.addAll(
        (healthData.length < 100) ? healthData : healthData.sublist(0, 100),
      );
    } catch (error) {
      // debugPrint("Exception in getHealthDataFromTypes: $error");
    }

    // filter out duplicates
    _healthDataList = health.removeDuplicates(_healthDataList);

    for (var data in _healthDataList) {
      // debugPrint(toJsonString(data));
    }

    // update the UI to display the results
    setState(() {
      _state = _healthDataList.isEmpty ? AppState.NO_DATA : AppState.DATA_READY;
    });

    final Map<HealthDataType, HealthDataPoint> latestByType = {};

    for (var point in _healthDataList) {
      final existing = latestByType[point.type];

      if (existing == null || point.dateFrom.isAfter(existing.dateFrom)) {
        latestByType[point.type] = point;
      }
    }

    setState(() {
      _healthDataList = latestByType.values.toList();
    });

    //

    // NOW ADDING THE CONSTRAINTS.

    //

    //

    //

    // var steps = await fetchStepData();

    final midnight = DateTime(now.year, now.month, now.day);

    // var steps =
    //     await health.getTotalStepsInInterval(
    //       midnight,
    //       now,
    //       includeManualEntry:
    //           !recordingMethodsToFilter.contains(RecordingMethod.manual),
    //     ) ??
    //     0;

    int? steps;

    // get steps for today (i.e., since midnight)
    final nowww = DateTime.now();
    final midnighttt = DateTime(nowww.year, nowww.month, nowww.day);

    bool stepsPermission =
        await health.hasPermissions([HealthDataType.STEPS]) ?? false;

    if (!stepsPermission) {
      stepsPermission = await health.requestAuthorization([
        HealthDataType.STEPS,
      ]);
    }

    steps = await health.getTotalStepsInInterval(
      midnight,
      now,
      includeManualEntry:
          !recordingMethodsToFilter.contains(RecordingMethod.manual),
    );

    var sleep_index = _healthDataList.indexWhere(
      (e) => e.type == HealthDataType.SLEEP_ASLEEP,
    );

    var sleep = 20.00;

    if (sleep_index != -1) {
      sleep =
          double.tryParse(
            _healthDataList[sleep_index].value.toString().split(' ').last,
          ) ??
          20.00;
    }

    var boold_oxygen_index = _healthDataList.indexWhere(
      (e) => e.type == HealthDataType.BLOOD_OXYGEN,
    );

    var blood_oxygen = 98;

    if (boold_oxygen_index != -1) {
      blood_oxygen =
          int.tryParse(_healthDataList[boold_oxygen_index].value.toString()) ??
          98;
    }

    var hrv_index = _healthDataList.indexWhere(
      (e) => e.type == HealthDataType.HEART_RATE_VARIABILITY_SDNN,
    );

    var hrv = 30;

    if (hrv_index != -1) {
      hrv =
          int.tryParse(
            _healthDataList[hrv_index].value.toString().split(' ').last,
          ) ??
          30;
    }

    var blood_pressure_index = _healthDataList.indexWhere(
      (e) => e.type == HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
    );

    var blood_pressure = 8;

    if (blood_pressure_index != -1) {
      blood_pressure =
          int.tryParse(
            _healthDataList[blood_pressure_index].value
                .toString()
                .split(' ')
                .last,
          ) ??
          8;
    }

    var hear_rate_index = _healthDataList.indexWhere(
      (e) => e.type == HealthDataType.HEART_RATE,
    );

    var heart_rate = 70;

    if (hear_rate_index != -1) {
      heart_rate =
          double.parse(
            _healthDataList[hear_rate_index].value.toString().split(' ').last,
          ).toInt();
    }

    global_sleep = sleep;
    global_blood_oxygen = blood_oxygen;
    global_blood_pressure = blood_pressure;
    global_heart_rate = heart_rate;
    global_steps = steps ?? 0;
    global_hrv = hrv;

    List<Map<String, dynamic>> notes = [];

    List<String> texts = [];
    List<String> what_to_take = [];

    var sleep_to_hours = global_sleep / 60;

    if (sleep_to_hours < 6) {
      notes.add({
        'key': 'Sleep',
        'text': 'You didn\'t rest enough, need a push',
      });
      texts.add('You didn\'t rest enough, need a push');
      what_to_take.add('Use Energy Boost Oil');
    }

    if (global_steps < 5000) {
      notes.add({'key': 'Steps', 'text': 'Mentally foggy, sedentary day'});
      texts.add('Mentally foggy, sedentary day');
      what_to_take.add('Focus Oil');
    } else if (global_steps < 3000) {
      notes.add({
        'key': 'Steps',
        'text': 'Inactivity + sluggishness = energy needed',
      });
      texts.add('Inactivity + sluggishness = energy needed');
      what_to_take.add('Use Energy Boost Oil');
    }

    if (global_blood_oxygen < 94) {
      notes.add({'key': 'Oxygen', 'text': 'Low oxygen may cause fatigue'});
      texts.add('Low oxygen may cause fatigue');
      what_to_take.add('Use Energy Boost Oil');
    }

    if (global_hrv < 20) {
      notes.add({'key': 'Hrv', 'text': 'Poor recovery - you feel drained'});
      texts.add('Poor recovery - you feel drained');
      what_to_take.add('Use Energy Boost Oil');
    }

    if (global_hrv < 20 && global_blood_oxygen < 94) {
      notes.add({
        'key': 'Hrv & Oxygen',
        'text': 'Low recovery & oxygen - support needed',
      });
      texts.add('Low recovery & oxygen - support needed');
      what_to_take.add('Use Energy Boost Oil');
    }

    if (global_heart_rate > 95) {
      notes.add({
        'key': 'Heart',
        'text': 'High HR usually = stress or overexertion',
      });
      texts.add('High HR usually = stress or overexertion');
      what_to_take.add('Stress & Fatigue Relief Oil');
    }

    if (global_blood_pressure > 1.52) {
      notes.add({'key': 'Blood', 'text': 'Tension and anxiety likely present'});
      texts.add('Tension and anxiety likely present');
      what_to_take.add('Stress & Fatigue Relief Oil');
    }

    if (global_blood_pressure > 1.52 && global_hrv < 20) {
      notes.add({
        'key': 'Blood & Hrv',
        'text': 'Stress state - nervous system overwhelmed',
      });
      texts.add('Stress state - nervous system overwhelmed');
      what_to_take.add('Stress & Fatigue Relief Oil');
    }

    if (global_heart_rate > 95 && global_hrv < 20) {
      notes.add({
        'key': 'Heart & Hrv',
        'text': 'Sympathetic overdrive = relaxation needed',
      });
      texts.add('Sympathetic overdrive = relaxation needed');
      what_to_take.add('Stress & Fatigue Relief Oil');
    }

    if (sleep_to_hours > 6 &&
        (global_blood_pressure > 1.52 || global_heart_rate > 95)) {
      notes.add({
        'key': 'Sleep & Heart & Blood',
        'text': 'Mental stress even after rest',
      });
      texts.add('Mental stress even after rest');
      what_to_take.add('Stress & Fatigue Relief Oil');
    }

    if (sleep_to_hours > 6.5) {
      notes.add({'key': 'Sleep', 'text': 'You are well-rested physically'});
      texts.add('You are well-rested physically');
      what_to_take.add('Focus Oil');
    }

    if (global_heart_rate < 95 && global_heart_rate > 70) {
      if (global_blood_pressure < 1.52) {
        notes.add({'key': 'Heart & Blood', 'text': 'You are calm physically'});
        texts.add('You are calm physically');
        what_to_take.add('Focus Oil');
      }
    }

    if (global_blood_oxygen >= 95) {
      notes.add({
        'key': 'Oxygen',
        'text': 'Brain has oxygen - just needs clarity',
      });
      texts.add('Brain has oxygen - just needs clarity');
      what_to_take.add('Focus Oil');
    }

    setState(() {});

    // Delay showing the snackbar until after the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(seconds: 2));

      Map<String, int> frequencyMap = {};

      for (var item in what_to_take) {
        frequencyMap[item] = (frequencyMap[item] ?? 0) + 1;
      }

      // Filter for items that appear more than once and get unique values
      List<String> repeatedItems =
          frequencyMap.entries
              .where((entry) => entry.value > 1)
              .map((entry) => entry.key)
              .toList();

      Show_Options_List_Tiles_Modal_Sheet(
        title: 'Report',
        context: context,
        texts: repeatedItems,
      );
    });
  }

  /// Add some random health data.
  /// Note that you should ensure that you have permissions to add the
  /// following data types.
  Future<void> addData() async {
    final now = DateTime.now();
    final earlier = now.subtract(const Duration(minutes: 20));

    // Add data for supported types
    // NOTE: These are only the ones supported on Androids new API Health Connect.
    // Both Android's Health Connect and iOS' HealthKit have more types that we support in the enum list [HealthDataType]
    // Add more - like AUDIOGRAM, HEADACHE_SEVERE etc. to try them.
    bool success = true;

    // misc. health data examples using the writeHealthData() method
    success &= await health.writeHealthData(
      value: 1.925,
      type: HealthDataType.HEIGHT,
      startTime: earlier,
      endTime: now,
      recordingMethod: RecordingMethod.manual,
    );
    success &= await health.writeHealthData(
      value: 90,
      type: HealthDataType.WEIGHT,
      startTime: now,
      recordingMethod: RecordingMethod.manual,
    );
    success &= await health.writeHealthData(
      value: 90,
      type: HealthDataType.HEART_RATE,
      startTime: earlier,
      endTime: now,
      recordingMethod: RecordingMethod.manual,
    );
    success &= await health.writeHealthData(
      value: 90,
      type: HealthDataType.STEPS,
      startTime: earlier,
      endTime: now,
      recordingMethod: RecordingMethod.manual,
    );
    success &= await health.writeHealthData(
      value: 200,
      type: HealthDataType.ACTIVE_ENERGY_BURNED,
      startTime: earlier,
      endTime: now,
    );
    success &= await health.writeHealthData(
      value: 70,
      type: HealthDataType.HEART_RATE,
      startTime: earlier,
      endTime: now,
    );
    if (Platform.isIOS) {
      success &= await health.writeHealthData(
        value: 30,
        type: HealthDataType.HEART_RATE_VARIABILITY_SDNN,
        startTime: earlier,
        endTime: now,
      );
    } else {
      success &= await health.writeHealthData(
        value: 30,
        type: HealthDataType.HEART_RATE_VARIABILITY_RMSSD,
        startTime: earlier,
        endTime: now,
      );
    }
    success &= await health.writeHealthData(
      value: 37,
      type: HealthDataType.BODY_TEMPERATURE,
      startTime: earlier,
      endTime: now,
    );
    success &= await health.writeHealthData(
      value: 105,
      type: HealthDataType.BLOOD_GLUCOSE,
      startTime: earlier,
      endTime: now,
    );
    success &= await health.writeHealthData(
      value: 1.8,
      type: HealthDataType.WATER,
      startTime: earlier,
      endTime: now,
    );

    // different types of sleep
    success &= await health.writeHealthData(
      value: 0.0,
      type: HealthDataType.SLEEP_REM,
      startTime: earlier,
      endTime: now,
    );
    success &= await health.writeHealthData(
      value: 0.0,
      type: HealthDataType.SLEEP_ASLEEP,
      startTime: earlier,
      endTime: now,
    );
    success &= await health.writeHealthData(
      value: 0.0,
      type: HealthDataType.SLEEP_AWAKE,
      startTime: earlier,
      endTime: now,
    );
    success &= await health.writeHealthData(
      value: 0.0,
      type: HealthDataType.SLEEP_DEEP,
      startTime: earlier,
      endTime: now,
    );
    success &= await health.writeHealthData(
      value: 22,
      type: HealthDataType.LEAN_BODY_MASS,
      startTime: earlier,
      endTime: now,
    );

    // specialized write methods
    success &= await health.writeBloodOxygen(
      saturation: 98,
      startTime: earlier,
      endTime: now,
    );
    success &= await health.writeWorkoutData(
      activityType: HealthWorkoutActivityType.AMERICAN_FOOTBALL,
      title: "Random workout name that shows up in Health Connect",
      start: now.subtract(const Duration(minutes: 15)),
      end: now,
      totalDistance: 2430,
      totalEnergyBurned: 400,
    );
    success &= await health.writeBloodPressure(
      systolic: 90,
      diastolic: 80,
      startTime: now,
    );
    success &= await health.writeMeal(
      mealType: MealType.SNACK,
      startTime: earlier,
      endTime: now,
      caloriesConsumed: 1000,
      carbohydrates: 50,
      protein: 25,
      fatTotal: 50,
      name: "Banana",
      caffeine: 0.002,
      vitaminA: 0.001,
      vitaminC: 0.002,
      vitaminD: 0.003,
      vitaminE: 0.004,
      vitaminK: 0.005,
      b1Thiamin: 0.006,
      b2Riboflavin: 0.007,
      b3Niacin: 0.008,
      b5PantothenicAcid: 0.009,
      b6Pyridoxine: 0.010,
      b7Biotin: 0.011,
      b9Folate: 0.012,
      b12Cobalamin: 0.013,
      calcium: 0.015,
      copper: 0.016,
      iodine: 0.017,
      iron: 0.018,
      magnesium: 0.019,
      manganese: 0.020,
      phosphorus: 0.021,
      potassium: 0.022,
      selenium: 0.023,
      sodium: 0.024,
      zinc: 0.025,
      water: 0.026,
      molybdenum: 0.027,
      chloride: 0.028,
      chromium: 0.029,
      cholesterol: 0.030,
      fiber: 0.031,
      fatMonounsaturated: 0.032,
      fatPolyunsaturated: 0.033,
      fatUnsaturated: 0.065,
      fatTransMonoenoic: 0.65,
      fatSaturated: 066,
      sugar: 0.067,
      recordingMethod: RecordingMethod.manual,
    );

    // Store an Audiogram - only available on iOS
    // const frequencies = [125.0, 500.0, 1000.0, 2000.0, 4000.0, 8000.0];
    // const leftEarSensitivities = [49.0, 54.0, 89.0, 52.0, 77.0, 35.0];
    // const rightEarSensitivities = [76.0, 66.0, 90.0, 22.0, 85.0, 44.5];
    // success &= await health.writeAudiogram(
    //   frequencies,
    //   leftEarSensitivities,
    //   rightEarSensitivities,
    //   now,
    //   now,
    //   metadata: {
    //     "HKExternalUUID": "uniqueID",
    //     "HKDeviceName": "bluetooth headphone",
    //   },
    // );

    success &= await health.writeMenstruationFlow(
      flow: MenstrualFlow.medium,
      isStartOfCycle: true,
      startTime: earlier,
      endTime: now,
    );

    // Available on iOS 16.0+ only
    if (Platform.isIOS) {
      success &= await health.writeHealthData(
        value: 22,
        type: HealthDataType.WATER_TEMPERATURE,
        startTime: earlier,
        endTime: now,
        recordingMethod: RecordingMethod.manual,
      );

      success &= await health.writeHealthData(
        value: 55,
        type: HealthDataType.UNDERWATER_DEPTH,
        startTime: earlier,
        endTime: now,
        recordingMethod: RecordingMethod.manual,
      );
      success &= await health.writeHealthData(
        value: 4.3,
        type: HealthDataType.UV_INDEX,
        startTime: earlier,
        endTime: now,
        recordingMethod: RecordingMethod.manual,
      );
    }

    setState(() {
      _state = success ? AppState.DATA_ADDED : AppState.DATA_NOT_ADDED;
    });
  }

  /// Delete some random health data.
  Future<void> deleteData() async {
    final now = DateTime.now();
    final earlier = now.subtract(const Duration(hours: 24));

    bool success = true;
    for (HealthDataType type in types) {
      success &= await health.delete(
        type: type,
        startTime: earlier,
        endTime: now,
      );
    }

    // To delete a record by UUID - call the `health.deleteByUUID` method:
    /**
        List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
        types: [HealthDataType.STEPS],
        startTime: startDate,
        endTime: endDate,
        );

        if (healthData.isNotEmpty) {
        print("DELETING: ${healthData.first.toJson()}");
        String uuid = healthData.first.uuid;

        success &= await health.deleteByUUID(
        type: HealthDataType.STEPS,
        uuid: uuid,
        );

        }
     */

    setState(() {
      _state = success ? AppState.DATA_DELETED : AppState.DATA_NOT_DELETED;
    });
  }

  /// Fetch steps from the health plugin and show them in the app.
  Future<int> fetchStepData() async {
    int? steps;

    // get steps for today (i.e., since midnight)
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    bool stepsPermission =
        await health.hasPermissions([HealthDataType.STEPS]) ?? false;
    if (!stepsPermission) {
      stepsPermission = await health.requestAuthorization([
        HealthDataType.STEPS,
      ]);
    }

    if (stepsPermission) {
      try {
        steps = await health.getTotalStepsInInterval(
          midnight,
          now,
          includeManualEntry:
              !recordingMethodsToFilter.contains(RecordingMethod.manual),
        );
      } catch (error) {
        // debugPrint("Exception in getTotalStepsInInterval: $error");
      }

      // debugPrint('Total number of steps: $steps');

      setState(() {
        _nofSteps = (steps == null) ? 0 : steps;
        _state = (steps == null) ? AppState.NO_DATA : AppState.STEPS_READY;
      });
      return _nofSteps = (steps == null) ? 0 : steps;
    } else {
      // debugPrint("Authorization not granted - error in authorization");
      setState(() => _state = AppState.DATA_NOT_FETCHED);
      return 0;
    }
  }

  /// Revoke access to health data. Note, this only has an effect on Android.
  Future<void> revokeAccess() async {
    setState(() => _state = AppState.PERMISSIONS_REVOKING);

    bool success = false;

    try {
      await health.revokePermissions();
      success = true;
    } catch (error) {
      // debugPrint("Exception in revokeAccess: $error");
    }

    setState(() {
      _state =
          success
              ? AppState.PERMISSIONS_REVOKED
              : AppState.PERMISSIONS_NOT_REVOKED;
    });
  }

  // UI building below

  @override
  Widget build(BuildContext context) {
    return Heart_Body(
      blood_oxygen: global_blood_oxygen,
      blood_pressure: global_blood_pressure.toDouble(),
      heart_rate: global_heart_rate,
      hrv: global_hrv,
      sleep: global_sleep,
      steps: global_steps,
    );
  }

  Widget get _dataFiltration => Column(
    children: [
      Wrap(
        children: [
          for (final method
              in Platform.isAndroid
                  ? [
                    RecordingMethod.manual,
                    RecordingMethod.automatic,
                    RecordingMethod.active,
                    RecordingMethod.unknown,
                  ]
                  : [RecordingMethod.automatic, RecordingMethod.manual])
            SizedBox(
              width: 150,
              child: CheckboxListTile(
                title: Text(
                  '${method.name[0].toUpperCase()}${method.name.substring(1)} entries',
                ),
                value: !recordingMethodsToFilter.contains(method),
                onChanged: (value) {
                  setState(() {
                    if (value!) {
                      recordingMethodsToFilter.remove(method);
                    } else {
                      recordingMethodsToFilter.add(method);
                    }
                    fetchData();
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
            ),
          // Add other entries here if needed
        ],
      ),
      const Divider(thickness: 3),
    ],
  );

  Widget get _stepsFiltration => Column(
    children: [
      Wrap(
        children: [
          for (final method in [RecordingMethod.manual])
            SizedBox(
              width: 150,
              child: CheckboxListTile(
                title: Text(
                  '${method.name[0].toUpperCase()}${method.name.substring(1)} entries',
                ),
                value: !recordingMethodsToFilter.contains(method),
                onChanged: (value) {
                  setState(() {
                    if (value!) {
                      recordingMethodsToFilter.remove(method);
                    } else {
                      recordingMethodsToFilter.add(method);
                    }
                    fetchStepData();
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
            ),
          // Add other entries here if needed
        ],
      ),
      const Divider(thickness: 3),
    ],
  );

  Widget get _permissionsRevoking => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Container(
        padding: const EdgeInsets.all(20),
        child: const CircularProgressIndicator(strokeWidth: 10),
      ),
      const Text('Revoking permissions...'),
    ],
  );

  Widget get _permissionsRevoked => const Text('Permissions revoked.');

  Widget get _permissionsNotRevoked =>
      const Text('Failed to revoke permissions');

  Widget get _contentFetchingData => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Container(
        padding: const EdgeInsets.all(20),
        child: const CircularProgressIndicator(strokeWidth: 10),
      ),
      const Text('Fetching data...'),
    ],
  );

  Widget get _contentDataReady => ListView.builder(
    itemCount: _healthDataList.length,
    itemBuilder: (_, index) {
      // filter out manual entires if not wanted
      if (recordingMethodsToFilter.contains(
        _healthDataList[index].recordingMethod,
      )) {
        return Container();
      }

      HealthDataPoint p = _healthDataList[index];
      if (p.value is AudiogramHealthValue) {
        return ListTile(
          title: Text("${p.typeString}: ${p.value}"),
          trailing: Text(p.unitString),
          subtitle: Text('${p.dateFrom} - ${p.dateTo}\n${p.recordingMethod}'),
        );
      }
      if (p.value is WorkoutHealthValue) {
        return ListTile(
          title: Text(
            "${p.typeString}: ${(p.value as WorkoutHealthValue).totalEnergyBurned} ${(p.value as WorkoutHealthValue).totalEnergyBurnedUnit?.name}",
          ),
          trailing: Text(
            (p.value as WorkoutHealthValue).workoutActivityType.name,
          ),
          subtitle: Text('${p.dateFrom} - ${p.dateTo}\n${p.recordingMethod}'),
        );
      }
      if (p.value is NutritionHealthValue) {
        return ListTile(
          title: Text(
            "${p.typeString} ${(p.value as NutritionHealthValue).mealType}: ${(p.value as NutritionHealthValue).name}",
          ),
          trailing: Text('${(p.value as NutritionHealthValue).calories} kcal'),
          subtitle: Text('${p.dateFrom} - ${p.dateTo}\n${p.recordingMethod}'),
        );
      }

      return ListTile(
        title: Text("${p.typeString}: ${p.value}"),
        trailing: Text(p.unitString),
        subtitle: Text('${p.dateFrom} - ${p.dateTo}\n${p.recordingMethod}'),
      );
    },
  );

  final Widget _contentNoData = const Text('No Data to show');

  final Widget _contentNotFetched = const Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text("Press 'Auth' to get permissions to access health data."),
      Text("Press 'Fetch Dat' to get health data."),
      Text("Press 'Add Data' to add some random health data."),
      Text("Press 'Delete Data' to remove some random health data."),
    ],
  );

  final Widget _authorized = const Text('Authorization granted!');

  final Widget _authorizationNotGranted = const Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text('Authorization not given.'),
      Text(
        'For Google Health Connect please check if you have added the right permissions and services to the manifest file.',
      ),
      Text('For Apple Health check your permissions in Apple Health.'),
    ],
  );

  Widget _contentHealthConnectStatus = const Text(
    'No status, click getHealthConnectSdkStatus to get the status.',
  );

  final Widget _dataAdded = const Text('Data points inserted successfully.');

  final Widget _dataDeleted = const Text('Data points deleted successfully.');

  Widget get _stepsFetched => Text('Total number of steps: $_nofSteps.');

  final Widget _dataNotAdded = const Text(
    'Failed to add data.\nDo you have permissions to add data?',
  );

  final Widget _dataNotDeleted = const Text('Failed to delete data');

  Widget get _content => switch (_state) {
    AppState.DATA_READY => _contentDataReady,
    AppState.DATA_NOT_FETCHED => _contentNotFetched,
    AppState.FETCHING_DATA => _contentFetchingData,
    AppState.NO_DATA => _contentNoData,
    AppState.AUTHORIZED => _authorized,
    AppState.AUTH_NOT_GRANTED => _authorizationNotGranted,
    AppState.DATA_ADDED => _dataAdded,
    AppState.DATA_DELETED => _dataDeleted,
    AppState.DATA_NOT_ADDED => _dataNotAdded,
    AppState.DATA_NOT_DELETED => _dataNotDeleted,
    AppState.STEPS_READY => _stepsFetched,
    AppState.HEALTH_CONNECT_STATUS => _contentHealthConnectStatus,
    AppState.PERMISSIONS_REVOKING => _permissionsRevoking,
    AppState.PERMISSIONS_REVOKED => _permissionsRevoked,
    AppState.PERMISSIONS_NOT_REVOKED => _permissionsNotRevoked,
  };
}
