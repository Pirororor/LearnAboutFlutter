// ignore: file_names
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter/foundation.dart';

class FacebookInfo extends ChangeNotifier {
  bool isInitialized = false;

  // user info
  bool isLoggedIn = false;
  late Map<String, dynamic> profileInfo;

  void setValues(
      {bool? isLoggedIn,
      Map<String, dynamic>? profileInfo,
      bool? isInitialized}) {
    if (isInitialized != null) {
      this.isInitialized = isInitialized;
    }
    if (isLoggedIn != null) {
      this.isLoggedIn = isLoggedIn;
    }
    if (profileInfo != null) {
      this.profileInfo = profileInfo;
    }
    notifyListeners();
  }

  Future init() async {
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
    final AccessToken? accessToken = await FacebookAuth.instance.accessToken;

    if (accessToken != null) {
      // user is logged
      final userData = await fetchUserData();
      setValues(profileInfo: userData, isLoggedIn: true);
    } else {
      setValues(isLoggedIn: false);
    }
    setValues(isInitialized: true);
  }

  Future<Map<String, dynamic>> fetchUserData() async {
    final userData = await FacebookAuth.instance.getUserData(
      fields: "name,email,picture.width(200),birthday,gender",
    );
    return userData;
  }

  Future login() async {
    final LoginResult result = await FacebookAuth.instance.login(permissions: [
      'email',
      'public_profile',
      'user_gender',
      'user_birthday'
    ]);

    if (result.status == LoginStatus.success) {
      // user is logged
      final userData = await fetchUserData();
      setValues(profileInfo: userData, isLoggedIn: true);
    } else {
      setValues(isLoggedIn: false);
    }
  }

  Future logout() async {
    await FacebookAuth.instance.logOut();
    setValues(isLoggedIn: false);
  }
}
