import 'package:anokha_admin/util/official/new_official.dart';
import 'package:flutter/material.dart';

class SuperAdminNewOfficialScreen extends StatefulWidget {
  const SuperAdminNewOfficialScreen({super.key});

  @override
  State<SuperAdminNewOfficialScreen> createState() => _SuperAdminNewOfficialScreenState();
}

class _SuperAdminNewOfficialScreenState extends State<SuperAdminNewOfficialScreen> {
  @override
  Widget build(BuildContext context) {
    return const NewOfficialScreen(managerRoleId: "1");
  }
}
