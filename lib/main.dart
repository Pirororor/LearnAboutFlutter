import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:test_flutter/widgets/UserData.dart';

import 'classes/FacebookInfo.dart';

void main() async {
  runApp(ChangeNotifierProvider<FacebookInfo>(
      create: (_) => FacebookInfo(), child: LoginPage()));
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<FacebookInfo>(context, listen: false).init();
  }

  @override
  Widget build(BuildContext context) {
    final facebookInfo = Provider.of<FacebookInfo>(context, listen: true);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Old Age Countdown"),
          actions: facebookInfo.isLoggedIn
              ? <Widget>[
                  IconButton(
                    icon: const Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                    ),
                    onPressed: () => facebookInfo.isLoggedIn ? _logout() : {},
                  ),
                ]
              : [],
        ),
        body: Center(
            child: !facebookInfo.isInitialized
                ? const Text('Loading')
                : facebookInfo.isLoggedIn
                    ? UserData(facebookInfo.profileInfo)
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [_displayLoginButton()])),
      ),
    );
  }

  _displayLoginButton() {
    return SignInButton(
      Buttons.FacebookNew,
      text: "Login with Facebook",
      onPressed: () =>
          Provider.of<FacebookInfo>(context, listen: false).login(),
    );
  }

  _logout() async {
    await Provider.of<FacebookInfo>(context, listen: false).logout();
    print("Logged out");
  }
}
