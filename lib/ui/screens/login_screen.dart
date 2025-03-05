import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sign_in_screen/core/constants/styles.dart';
import 'package:sign_in_screen/ui/screens/help_screen.dart';

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

          Positioned(
            top: 60,
            left: 37,
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Color(0xFFA9A9A9), width: 1),
                ),

                child: const Icon(Icons.arrow_back_ios_new_rounded, size: 12),
              ),
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo.png',
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.height * 0.3,
                  fit: BoxFit.contain,
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    '"Scheduling made easy: Simplify your time, amplify your productivity."',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF707070),
                    ),
                  ),
                ),

                30.verticalSpace,

                InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {},
                  child: SizedBox(
                    width: 187,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: null, // Disables the button
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0x803E8498),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 3,
                        shadowColor: Colors.black26,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Image.asset('assets/google.png', width: 24)],
                      ),
                    ),
                  ),
                ),

                40.verticalSpace,

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    children: [
                      Expanded(child: Divider(color: Color(0xFF3E8498))),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Assistance",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF969696),
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: Color(0xFF3E8498))),
                    ],
                  ),
                ),

                10.verticalSpace,

                InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HelpScreen()),
                    );
                    // Handle Help Action
                  },
                  child: SizedBox(
                    width: 180,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3E8498),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 3,
                      ),
                      child: const Text(
                        "Need Help?",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
