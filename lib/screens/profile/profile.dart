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
            title: const Text('Log out'),
            content: const Text('Are you sure you want to log out?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Log out'),
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
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error signing out: $e')));
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
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: const Color(0xFFFBFBFB),
                ),
              ),

              Positioned(
                top: 20,
                left: 37,
                child: InkWell(
                  borderRadius: BorderRadius.circular(40),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFA9A9A9),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 16,
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 25,
                left: 50,
                right: 50,
                child: Column(
                  children: [
                    SizedBox(
                      width: 62,
                      height: 64,
                      child: Image.asset('assets/user_icon.png'),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Clark Kent",
                      style: TextStyle(
                        color: Color(0xFF343434),
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      "Student",
                      style: TextStyle(
                        color: Color(0x80000000),
                        fontFamily: 'Poppins',
                        fontSize: 12,
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
                        onPress: () {},
                      ),

                      SizedBox(height: 10.h),

                      ProfileMenuWidget(
                        title: "Privacy",
                        subtitle: "Profile photo, Group",
                        iconPath: 'assets/privacy_icon.png',
                        onPress: () {},
                      ),

                      SizedBox(height: 10.h),

                      ProfileMenuWidget(
                        title: "Chats",
                        subtitle: "Theme, Font size",
                        iconPath: 'assets/chat_icon.png',
                        onPress: () {},
                      ),

                      SizedBox(height: 10.h),

                      ProfileMenuWidget(
                        title: "Log Book",
                        subtitle: "Voice-to-Text Generator",
                        iconPath: 'assets/logbook_icon.png',
                        onPress: () {},
                      ),

                      SizedBox(height: 10.h),

                      ProfileMenuWidget(
                        title: "Help",
                        subtitle: "Help center, contact us",
                        iconPath: 'assets/help_icon.png',
                        onPress: () {},
                      ),

                      SizedBox(height: 20.h),

                      GestureDetector(
                        onTap: () => _signout(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 17,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3C5A7D),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 3,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),

                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 16,
                                ),
                                child: Text(
                                  "Log out",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
