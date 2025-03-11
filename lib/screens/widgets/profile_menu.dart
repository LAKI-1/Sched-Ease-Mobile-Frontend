import 'package:flutter/material.dart';

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.iconPath,
    required this.onPress,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String iconPath;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color(0x993E8498), width: 1.5),
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 2,
              offset: const Offset(1, 1),
            ),
          ],
        ),
        height: 65,
        child: ListTile(
          onTap: onPress,
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.grey.withOpacity(0.1),
            ),

            child: Center(child: Image.asset(iconPath, width: 24, height: 24)),
          ),
          title: Text(
            title,
            style: TextStyle(
              color: Color(0xFF000000),
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(color: Color(0x80000000), fontSize: 14),
          ),
        ),
      ),
    );
  }
}
