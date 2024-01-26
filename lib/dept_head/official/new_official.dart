import 'package:anokha_admin/util/official/new_official.dart';
import 'package:flutter/material.dart';

class DeptHeadNewOfficialScreen extends StatefulWidget {
  const DeptHeadNewOfficialScreen({super.key});

  @override
  State<DeptHeadNewOfficialScreen> createState() => _DeptHeadNewOfficialScreenState();
}

class _DeptHeadNewOfficialScreenState extends State<DeptHeadNewOfficialScreen> {
  @override
  Widget build(BuildContext context) {
    return const NewOfficialScreen(managerRoleId: "4");
  }
}
