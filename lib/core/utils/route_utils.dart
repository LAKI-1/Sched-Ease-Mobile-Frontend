import 'package:flutter/material.dart';
import 'package:user_profile/core/constants/string.dart';
import 'package:user_profile/screens/profile.dart';

class RouteUtils {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case profile:
        return MaterialPageRoute(builder: (context) => Profile());

      //case home:
      //  return MaterialPageRoute(builder: (context) => HomeScreen{});
      default:
        return MaterialPageRoute(
          builder:
              (context) =>
                  const Scaffold(body: Center(child: Text("No Route Found"))),
        );
    }
  }
}
