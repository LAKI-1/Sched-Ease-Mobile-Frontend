import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:user_profile/core/utils/route_utils.dart';
import 'package:user_profile/screens/profile/profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://wvmlalwfmzzbugsruoee.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind2bWxhbHdmbXp6YnVnc3J1b2VlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzg5OTM0NDAsImV4cCI6MjA1NDU2OTQ0MH0.PLBtR4y3MgEcBP9e-PotUETRinxImHIB582-6h6caBY',
  );
  runApp(const SchedEaseMobileFrontend());
}

class SchedEaseMobileFrontend extends StatelessWidget {
  const SchedEaseMobileFrontend({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder:
          (context, child) => MaterialApp(
            onGenerateRoute: RouteUtils.onGenerateRoute,
            home: const Profile(),
          ),
    );
  }
}
