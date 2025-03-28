import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sign_in_screen/core/constants/styles.dart';
import 'package:sign_in_screen/ui/screens/help_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final supabase = Supabase.instance.client;
  bool _isLoading = false;

  Future<AuthResponse> _googleSignIn() async {
    print('Starting Google Sign-In');
    const webClientId =
        '774729998454-ikupt71orb4iqlste11472e8ntj581dj.apps.googleusercontent.com';

    final GoogleSignIn googleSignIn = GoogleSignIn(serverClientId: webClientId);

    print('Signing out previous session');
    await googleSignIn.signOut();

    print('Requesting Google Sign-In');
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      print('Sign-in aborted by user');
      throw 'Sign-in process aborted by user.';
    }

    print('Getting authentication tokens');
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;
    print('Access Token: $accessToken, ID Token: $idToken');

    if (accessToken == null || idToken == null) {
      print('No valid tokens received');
      throw 'No valid tokens received.';
    }

    print('Signing in with Supabase');

    final response = await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );

    print('Supabase Response: ${response.user?.email}');

    print('Sending token to backend');

    await _sendTokenToBackend(idToken);

    return response;
  }

  Future<void> _sendTokenToBackend(String idToken) async {
    const backendUrl = 'http://10.31.7.21:8080/api/v1/login/student-login';
    final cleanToken = idToken.trim();
    print('Sending token to $backendUrl: ${cleanToken.substring(0, 50)}...');

    try {
      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$cleanToken',
        },
      );

      print('Backend response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        print('Token successfully sent to backend');
      } else {
        throw 'Failed to send token to backend: ${response.statusCode}';
      }
    } catch (e) {
      print('Error sending token: $e');
      throw 'Error sending token to backend: $e';
    }
  }

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

          Positioned(
            top: 40.h,
            left: 30.w,
            child: InkWell(
              borderRadius: BorderRadius.circular(30.r),
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 24.w,
                height: 24.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Color(0xFFA9A9A9), width: 1.w),
                ),

                child: Icon(Icons.arrow_back_ios_new_rounded, size: 12.sp),
              ),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Welcome to\nSched-Ease",
                    style: h.copyWith(
                      fontFamily: 'Poppins',
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF000000),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 10.h),

                  Image.asset(
                    'assets/logo.png',
                    width: 0.6.sw,
                    height: 0.3.sh,
                    fit: BoxFit.contain,
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Text(
                      '"Scheduling made easy: Simplify your time, amplify your productivity."',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF707070),
                      ),
                    ),
                  ),

                  SizedBox(height: 30.h),

                  SizedBox(
                    width: 187.w,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed:
                          _isLoading
                              ? null
                              : () async {
                                setState(() => _isLoading = true);
                                try {
                                  final response = await _googleSignIn();

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Signed in as ${response.user?.email} ',
                                      ),
                                    ),
                                  );
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Placeholder(),
                                    ),
                                  );
                                } catch (error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Error: $error')),
                                  );
                                } finally {
                                  setState(() => _isLoading = false);
                                }
                              },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0x803E8498),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        elevation: 3,
                        shadowColor: Colors.black26,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/google.png', width: 24.w),
                          if (_isLoading) SizedBox(width: 10.w),
                          if (_isLoading)
                            const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 30.h),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Row(
                      children: [
                        Expanded(child: Divider(color: Color(0xFF3E8498))),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Text(
                            "Assistance",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF969696),
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: Color(0xFF3E8498))),
                      ],
                    ),
                  ),

                  SizedBox(height: 10.h),

                  SizedBox(
                    width: 180.w,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HelpScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3E8498),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        elevation: 3,
                      ),
                      child: Text(
                        "Need Help?",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
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
