import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sign_in_screen/core/utils/route_utils.dart';
import 'package:sign_in_screen/ui/screens/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://wvmlalwfmzzbugsruoee.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind2bWxhbHdmbXp6YnVnc3J1b2VlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzg5OTM0NDAsImV4cCI6MjA1NDU2OTQ0MH0.PLBtR4y3MgEcBP9e-PotUETRinxImHIB582-6h6caBY',
  );
  runApp(const SignInScreen());
}

final supabase = Supabase.instance.client;

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
