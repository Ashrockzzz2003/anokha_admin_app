import 'package:anokha_admin/util/official/all_officials.dart';
import 'package:flutter/material.dart';

class AdminAllOfficialsScreen extends StatefulWidget {
  const AdminAllOfficialsScreen({super.key});

  @override
  State<AdminAllOfficialsScreen> createState() => _AdminAllOfficialsScreenState();
}

class _AdminAllOfficialsScreenState extends State<AdminAllOfficialsScreen> {
  @override
  Widget build(BuildContext context) {
    return const AllOfficialsScreen(managerRoleId: "2");
  }
}
