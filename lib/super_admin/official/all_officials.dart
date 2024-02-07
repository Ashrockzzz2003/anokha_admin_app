import 'package:anokha_admin/util/official/all_officials.dart';
import 'package:flutter/material.dart';

class SuperAdminAllOfficialsScreen extends StatefulWidget {
  const SuperAdminAllOfficialsScreen({super.key});

  @override
  State<SuperAdminAllOfficialsScreen> createState() => _SuperAdminAllOfficialsScreenState();
}

class _SuperAdminAllOfficialsScreenState extends State<SuperAdminAllOfficialsScreen> {
  @override
  Widget build(BuildContext context) {
    return const AllOfficialsScreen(
      managerRoleId: "1",
    );
  }
}
