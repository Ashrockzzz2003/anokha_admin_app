import 'package:anokha_admin/util/profile/profile_screen.dart';
import 'package:flutter/material.dart';

class EventideAttendanceProfileScreen extends StatefulWidget {
  const EventideAttendanceProfileScreen({super.key});

  @override
  State<EventideAttendanceProfileScreen> createState() => _EventideAttendanceProfileScreenState();
}

class _EventideAttendanceProfileScreenState extends State<EventideAttendanceProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return const ProfileScreen(
      managerRoleId: "5",
    );
  }
}
