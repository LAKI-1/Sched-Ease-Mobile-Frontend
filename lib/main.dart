import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_profile/core/utils/route_utils.dart';
import 'package:user_profile/screens/profile.dart';

void main() {
  runApp(const SchedEaseMobileFrontend());
}

class SchedEaseMobileFrontend extends StatelessWidget {
  const SchedEaseMobileFrontend({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder:
          (context, child) => MaterialApp(
            onGenerateRoute: RouteUtils.onGenerateRoute,
            home: Profile(),
          ),
    );
  }
}
