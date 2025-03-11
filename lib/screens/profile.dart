import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
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
                top: 38,
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
                top: 40,
                left: 50,
                right: 50,
                child: Column(
                  children: [
                    SizedBox(
                      width: 62,
                      height: 64,
                      child: Image.asset('assets/user_icon.png'),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Clark Kent",
                      style: TextStyle(
                        color: Color(0xFF343434),
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 7),

                    const Text(
                      "Student",
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                top: 170.h,
                left: 0,
                right: 0,
                bottom: 0,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ProfileMenuWidget(iconPath: 'assets/account_icon.png'),
                      ProfileMenuWidget(iconPath: 'assets/privacy_icon.png'),
                      ProfileMenuWidget(iconPath: 'assets/chat_icon.png'),
                      ProfileMenuWidget(iconPath: 'assets/logbook_icon.png'),
                      ProfileMenuWidget(iconPath: 'assets/help_icon.png'),
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

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({Key? key, required this.iconPath}) : super(key: key);

  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      trailing: Container(
        child: Center(child: Image.asset(iconPath, width: 24, height: 24)),
      ),
    );
  }
}
