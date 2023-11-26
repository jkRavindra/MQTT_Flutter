import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../util/routes/date_utils.dart';
import '../util/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateUtilsClass dateUtil = DateUtilsClass();

  void _requestLocationPermission() async {
    var status = await Permission.bluetooth.request();
    if (status.isGranted) {
      // Location permission is granted, you can access the location now.
      print('Location permission granted.');
    } else if (status.isDenied) {
      // Location permission is denied, you can show a snackbar/dialog to explain why it's necessary.
      print('Location permission denied.');
    } else if (status.isPermanentlyDenied) {
      // Location permission is permanently denied, you should open the app settings to enable it manually.
      print('Location permission permanently denied.');
      openAppSettings(); // This function will open the app settings for the user to manually enable the permission.
    } else if (status.isRestricted) {
      // Location permission is restricted, probably due to parental controls.
      print('Location permission restricted.');
    } else if (status.isLimited) {
      // Location permission is limited, probably due to location access restrictions on iOS 14+.
      print('Location permission limited.');
    }
  }

  @override
  Widget build(BuildContext context) {
    String expectedDateResult;
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, RouteName.mqtt),
              child: Text("mqtt")),
          ElevatedButton(
              onPressed: () => {
                    expectedDateResult = dateUtil.getDateTimeWithExpectedFormat(
                        '2023-08-04T13:45:42.589Z', 'MM-dd-yyyy h:mm a'),
                    print("getDateTimeWithExpectedFormat===> $expectedDateResult"),
                    print(dateUtil.getPreviousExpectedDate(30)),
                    print(dateUtil.getFeatureExpectedDate(30))
                  },
              child: Text("Get Date")),
          ElevatedButton(
            onPressed: _requestLocationPermission,
            child: Text('Request Location Permission'),
          ),
        ]),
      ),
    );
  }
}
