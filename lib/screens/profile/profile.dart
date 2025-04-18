import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:user_profile/screens/widgets/profile_menu.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  final supabase = Supabase.instance.client;

  Future<void> _signout(BuildContext context) async {
    bool? confirm = await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Log out', style: TextStyle(fontSize: 18.sp)),
            content: Text(
              'Are you sure you want to log out?',
              style: TextStyle(fontSize: 14.sp),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel', style: TextStyle(fontSize: 14.sp)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Log out', style: TextStyle(fontSize: 14.sp)),
              ),
            ],
          ),
    );

    if (confirm == true) {
      try {
        await supabase.auth.signOut();

        if (mounted) {
          Navigator.pushReplacementNamed(context, '/splash');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Error signing out: $e',
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          constraints: const BoxConstraints.expand(),
          color: const Color(0xFFFBFBFB),
          child: Stack(
            children: [
              Positioned(
                top: 20.h,
                left: 20.w,
                child: InkWell(
                  borderRadius: BorderRadius.circular(40.r),
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFA9A9A9),
                        width: 1.w,
                      ),
                    ),
                    child: Icon(Icons.arrow_back_ios_new_rounded, size: 16.sp),
                  ),
                ),
              ),

              Positioned(
                top: 25.h,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    SizedBox(
                      width: 62.w,
                      height: 64.h,
                      child: Image.asset(
                        'assets/user_icon.png',
                        fit: BoxFit.contain,
                      ),
                    ),

                    SizedBox(height: 10.h),

                    Text(
                      "Clark Kent",
                      style: TextStyle(
                        color: const Color(0xFF343434),
                        fontFamily: 'Poppins',
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 5.h),

                    Text(
                      "Student",
                      style: TextStyle(
                        color: const Color(0x80000000),
                        fontFamily: 'Poppins',
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                top: 150.h,
                left: 0,
                right: 0,
                bottom: 0,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ProfileMenuWidget(
                        title: "Account",
                        subtitle: "Account info, Passkeys",
                        iconPath: 'assets/account_icon.png',
                        onPress: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Placeholder(),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 10.h),

                      ProfileMenuWidget(
                        title: "Privacy",
                        subtitle: "Profile photo, Group",
                        iconPath: 'assets/privacy_icon.png',
                        onPress: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Placeholder(),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 10.h),

                      ProfileMenuWidget(
                        title: "Chats",
                        subtitle: "Theme, Font size",
                        iconPath: 'assets/chat_icon.png',
                        onPress: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Placeholder(),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 10.h),

                      ProfileMenuWidget(
                        title: "Log Book",
                        subtitle: "Voice-to-Text Generator",
                        iconPath: 'assets/logbook_icon.png',
                        onPress: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Placeholder(),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 10.h),

                      ProfileMenuWidget(
                        title: "Help",
                        subtitle: "Help center, contact us",
                        iconPath: 'assets/help_icon.png',
                        onPress: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Placeholder(),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 20.h),

                      GestureDetector(
                        onTap: () => _signout(context),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 17.w,
                            vertical: 12.h,
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 20.w),
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

                          child: Text(
                            "Log out",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
