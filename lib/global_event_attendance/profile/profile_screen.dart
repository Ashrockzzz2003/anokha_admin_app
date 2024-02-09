import 'package:anokha_admin/util/profile/profile_screen.dart';
import 'package:flutter/material.dart';

class GlobalEventAttendanceProfileScreen extends StatefulWidget {
  const GlobalEventAttendanceProfileScreen({super.key});

  @override
  State<GlobalEventAttendanceProfileScreen> createState() => _GlobalEventAttendanceProfileScreenState();
}

class _GlobalEventAttendanceProfileScreenState extends State<GlobalEventAttendanceProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return const ProfileScreen(
      managerRoleId: "6",
    );
  }
}
