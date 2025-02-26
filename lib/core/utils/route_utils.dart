import 'package:flutter/material.dart';
import 'package:sign_in_screen/core/constants/string.dart';
import 'package:sign_in_screen/ui/screens/splash_screen.dart';

class RouteUtils {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (context) => SplashScreen());
    }
  }
}
