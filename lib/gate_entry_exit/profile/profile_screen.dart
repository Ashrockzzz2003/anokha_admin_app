import 'package:anokha_admin/util/profile/profile_screen.dart';
import 'package:flutter/material.dart';

class GateEntryExitProfileScreen extends StatefulWidget {
  const GateEntryExitProfileScreen({super.key});

  @override
  State<GateEntryExitProfileScreen> createState() => _GateEntryExitProfileScreenState();
}

class _GateEntryExitProfileScreenState extends State<GateEntryExitProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return const ProfileScreen(
      managerRoleId: "8",
    );
  }
}
