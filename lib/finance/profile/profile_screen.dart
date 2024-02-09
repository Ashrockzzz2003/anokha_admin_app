import 'package:anokha_admin/util/profile/profile_screen.dart';
import 'package:flutter/material.dart';

class FinanceProfileScreen extends StatefulWidget {
  const FinanceProfileScreen({super.key});

  @override
  State<FinanceProfileScreen> createState() => _FinanceProfileScreenState();
}

class _FinanceProfileScreenState extends State<FinanceProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return const ProfileScreen(
      managerRoleId: "3",
    );
  }
}
