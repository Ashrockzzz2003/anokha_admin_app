import 'package:anokha_admin/util/profile/profile_screen.dart';
import 'package:flutter/material.dart';

class DeptHeadProfileScreen extends StatefulWidget {
  const DeptHeadProfileScreen({super.key});

  @override
  State<DeptHeadProfileScreen> createState() => _DeptHeadProfileScreenState();
}

class _DeptHeadProfileScreenState extends State<DeptHeadProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return const ProfileScreen(
      managerRoleId: "4",
    );
  }
}
