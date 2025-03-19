import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

