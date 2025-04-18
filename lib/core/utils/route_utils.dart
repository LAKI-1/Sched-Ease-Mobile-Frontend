import 'package:flutter/material.dart';
import 'package:user_profile/core/constants/string.dart';
import 'package:user_profile/screens/profile/profile.dart';
import 'package:sign_in_screen/core/constants/string.dart';
import 'package:sign_in_screen/ui/screens/help_screen.dart';
import 'package:sign_in_screen/ui/screens/login_screen.dart';
import 'package:sign_in_screen/ui/screens/splash_screen.dart';

class RouteUtils {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case profile:
        return MaterialPageRoute(builder: (context) => Profile());
      case splash:
        return MaterialPageRoute(builder: (context) => SplashScreen());
      case login:
        return MaterialPageRoute(builder: (context) => LoginScreen());
      case help:
        return MaterialPageRoute(builder: (context) => HelpScreen());

      default:
        return MaterialPageRoute(
          builder:
              (context) =>
                  const Scaffold(body: Center(child: Text("No Route Found"))),
        );
    }
  }
}
