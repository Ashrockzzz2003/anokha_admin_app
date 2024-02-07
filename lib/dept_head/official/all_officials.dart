import 'package:anokha_admin/util/official/all_officials.dart';
import 'package:flutter/material.dart';

class DeptHeadAllOfficialsScreen extends StatefulWidget {
  const DeptHeadAllOfficialsScreen({super.key});

  @override
  State<DeptHeadAllOfficialsScreen> createState() => _DeptHeadAllOfficialsScreenState();
}

class _DeptHeadAllOfficialsScreenState extends State<DeptHeadAllOfficialsScreen> {
  @override
  Widget build(BuildContext context) {
    return const AllOfficialsScreen(managerRoleId: "4");
  }
}
