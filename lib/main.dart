import 'package:flutter/material.dart';
import 'FacebookAgeCountdown/index.dart';

void main() async {
  runApp(const Nav2App());
}

class Nav2App extends StatelessWidget {
  const Nav2App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {'/': (context) => const FacebookAgeCountdown()},
    );
  }
}
