import 'package:anokha_admin/util/profile/profile_screen.dart';
import 'package:flutter/material.dart';

class LocalEventAttendanceProfileScreen extends StatefulWidget {
  const LocalEventAttendanceProfileScreen({super.key});

  @override
  State<LocalEventAttendanceProfileScreen> createState() => _LocalEventAttendanceProfileScreenState();
}

class _LocalEventAttendanceProfileScreenState extends State<LocalEventAttendanceProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return const ProfileScreen(
      managerRoleId: "7",
    );
  }
}
