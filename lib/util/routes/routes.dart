import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mqttfluttermsg/widgets/homeScreen.dart';
// import 'package:mqtt/mqtt.dart';
import 'package:mqttfluttermsg/widgets/mqttModelView.dart';
import 'package:provider/provider.dart';
import '../../widgets/mqttView.dart';
import 'route_name.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.home:
        return MaterialPageRoute(
            settings: const RouteSettings(name: RouteName.home),
            builder: (BuildContext context) => HomeScreen());

      case RouteName.mqtt:
        return MaterialPageRoute(
            builder: (BuildContext context) => ChangeNotifierProvider(
                  create: (_) => MqttAppState(),
                  child: MQTTView(),
                ));

      default:
        return MaterialPageRoute(
            settings: const RouteSettings(name: RouteName.home),
            builder: (BuildContext context) => HomeScreen());
    }
  }
}
