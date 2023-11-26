import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import '../util/routes/route_name.dart';
import '../util/routes/routes.dart';

class Navigate extends StatefulWidget {
  const Navigate({super.key});
  @override
  State<Navigate> createState() => _NavigateState();
}

class _NavigateState extends State<Navigate> {
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: RouteName.home,
      onGenerateRoute: Routes.generateRoute,
    );
    //)
  }
}
