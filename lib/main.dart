import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sign_in_screen/core/utils/route_utils.dart';
import 'package:sign_in_screen/ui/screens/splash_screen.dart';

void main() {
  runApp(const SignInScreen());
}

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder:
          (context, child) => const MaterialApp(
            onGenerateRoute: RouteUtils.onGenerateRoute,
            home: SplashScreen(),
          ),
    );
  }
}
