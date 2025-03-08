import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sign_in_screen/core/utils/route_utils.dart';
import 'package:sign_in_screen/ui/screens/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://niwzewmxvdnbmkfxxxbk.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5pd3pld214dmRuYm1rZnh4eGJrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDExNjIzNjksImV4cCI6MjA1NjczODM2OX0.PiChm9zF2rmfABh6y02VHP6amzI3hnj2fiuYzp_W4Fw',
  );
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
