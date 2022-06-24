import 'package:flutter/material.dart';
import 'package:test_flutter/CameraTest/index.dart';
import 'package:test_flutter/FacebookAgeCountdown/index.dart';
import 'common/routes.dart';

void main() async {
  runApp(const Nav2App());
}

class Nav2App extends StatelessWidget {
  const Nav2App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        Routes.facebookAgeCountdown: (context) => const FacebookAgeCountdown(),
        Routes.cameraTest: (context) => const CameraTest()
      },
    );
  }
}
