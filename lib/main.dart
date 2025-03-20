import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:user_profile/core/utils/route_utils.dart';
import 'package:user_profile/screens/profile/profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

import 'homescreen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375,812),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (context,child){
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF3C5A7D),
          scaffoldBackgroundColor: Colors.white,
          textTheme: TextTheme(
            bodyMedium: TextStyle(fontSize: 16.sp),
            headlineSmall: TextStyle(fontSize: 24.sp,fontWeight: FontWeight.bold) ,
            labelLarge: TextStyle(fontSize: 14.sp),
          ),
        ),
        home: HomeScreen(),
      );
    }

    );
  }
}

import 'package:sign_in_screen/core/utils/route_utils.dart';
import 'package:sign_in_screen/ui/screens/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://wvmlalwfmzzbugsruoee.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind2bWxhbHdmbXp6YnVnc3J1b2VlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzg5OTM0NDAsImV4cCI6MjA1NDU2OTQ0MH0.PLBtR4y3MgEcBP9e-PotUETRinxImHIB582-6h6caBY',
  );
  runApp(const SchedEaseMobileFrontend());
}
class SchedEaseMobileFrontend extends StatelessWidget {
  const SchedEaseMobileFrontend({super.key});
  runApp(const SignInScreen());
}
final supabase = Supabase.instance.client;

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder:
          (context, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            onGenerateRoute: RouteUtils.onGenerateRoute,
            home: const Profile(),
          (context, child) => const MaterialApp(
            debugShowCheckedModeBanner: false,
            onGenerateRoute: RouteUtils.onGenerateRoute,
            home: SplashScreen(),
          ),
    );
  }
}
