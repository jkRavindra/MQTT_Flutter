import 'package:flutter/material.dart';
import 'package:mqttfluttermsg/util/routes/routes.dart';
import 'package:mqttfluttermsg/widgets/homeScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
