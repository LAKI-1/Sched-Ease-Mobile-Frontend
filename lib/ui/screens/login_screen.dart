import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sign_in_screen/core/constants/styles.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Color(0xFF85B8CB),
                  Color.fromARGB(255, 245, 238, 231),
                  Colors.white,
                ],
                stops: [0.0, 0.2, 1.0],
              ),
            ),
          ),

          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 1.sw * 0.05,
                vertical: 10.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  30.verticalSpace,
                  Text(
                    "Welcome to\nSched-Ease",
                    style: h.copyWith(
                      fontFamily: 'Poppins',
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF000000),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
