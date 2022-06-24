import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;

import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

void main() async {
  // check if is running on Web
  if (kIsWeb) {
    // initialiaze the facebook javascript SDK
    await FacebookAuth.i.webInitialize(
      appId: "2254862551498941",
      cookie: true,
      xfbml: true,
      version: "v13.0",
    );
  }

  runApp(LoginPage());
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoggedIn = false;
  dynamic profileData;
  late Future future;

  @override
  void initState() {
    super.initState();
    future = checkLoginStatus();
  }

  Future checkLoginStatus() async {
    final AccessToken? accessToken = await FacebookAuth.instance.accessToken;

    if (accessToken != null) {
      // user is logged
      final userData = await FacebookAuth.instance.getUserData(
        fields: "name,email,picture.width(200),birthday,gender",
      );

      onLoginStatusChanged(true, profileData: userData);
    }
    onLoginStatusChanged(false);
  }

  void onLoginStatusChanged(bool isLoggedIn, {profileData}) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
      this.profileData = profileData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Facebook Login"),
          actions: isLoggedIn
              ? <Widget>[
                  IconButton(
                    icon: const Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                    ),
                    onPressed: () => isLoggedIn ? _logout() : {},
                  ),
                ]
              : [],
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                  child: FutureBuilder(
                      future: future,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return isLoggedIn
                              ? _displayUserData(profileData)
                              : _displayLoginButton();
                        } else {
                          return const Text('Loading...');
                        }
                      }))
            ]),
      ),
    );
  }

  void initiateFacebookLogin() async {
    final LoginResult result = await FacebookAuth.instance.login(permissions: [
      'email',
      'public_profile',
      'user_gender',
      'user_birthday'
    ]); // by default we request the email and the public profile
// or FacebookAuth.i.login()
    if (result.status == LoginStatus.success) {
      // you are logged
      final AccessToken accessToken = result.accessToken!;
      final userData = await FacebookAuth.instance.getUserData(
        fields: "name,email,picture.width(200),birthday,gender",
      );

      onLoginStatusChanged(true, profileData: userData);
    } else {
      onLoginStatusChanged(false);
      if (kDebugMode) {
        print(result.status);
        print(result.message);
      }
    }
  }

  _displayUserData(profileData) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 200.0,
          width: 200.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(
                profileData['picture']['data']['url'],
              ),
            ),
          ),
        ),
        const SizedBox(height: 28.0),
        Text(
          "Welcome: ${profileData['name']}",
          style: const TextStyle(
            fontSize: 20.0,
          ),
        ),
        Text("You are ${profileData.toString()}")
      ],
    );
  }

  _displayLoginButton() {
    return SignInButton(
      Buttons.FacebookNew,
      text: "Login with Facebook",
      onPressed: () => initiateFacebookLogin(),
    );
  }

  _logout() async {
    await FacebookAuth.instance.logOut();
    onLoginStatusChanged(false);
    print("Logged out");
  }
}
