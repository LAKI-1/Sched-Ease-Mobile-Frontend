import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sign_in_screen/ui/screens/login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    Color.fromARGB(255, 154, 200, 216),
                    Color.fromARGB(255, 236, 231, 226),
                    Colors.white,
                  ],
                  stops: [0.0, 0.2, 1.0],
                ),
              ),
            ),

            Positioned.fill(
              child: Image.asset(
                'assets/rectangle.png',
                fit: BoxFit.cover,
                opacity: const AlwaysStoppedAnimation(1),
              ),
            ),

            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 70.h),
                    Image.asset(
                      'assets/logo.png',
                      width: 0.8.sw,
                      fit: BoxFit.contain,
                    ),

                    SizedBox(height: 50.h),

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3C5A7D),
                        borderRadius: BorderRadius.circular(30.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 3.r,
                            offset: Offset(0, 2.h),
                          ),
                        ],
                      ),

                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 12.h,
                              horizontal: 16.w,
                            ),
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          InkWell(
                            borderRadius: BorderRadius.circular(30.r),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            },

                            child: Container(
                              width: 24.w,
                              height: 24.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Color(0xFFA9A9A9),
                                  width: 1.w,
                                ),
                              ),

                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.black87,
                                size: 12.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
