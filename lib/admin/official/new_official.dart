import 'package:anokha_admin/util/official/new_official.dart';
import 'package:flutter/material.dart';

class AdminNewOfficialScreen extends StatefulWidget {
  const AdminNewOfficialScreen({super.key});

  @override
  State<AdminNewOfficialScreen> createState() => _AdminNewOfficialScreenState();
}

class _AdminNewOfficialScreenState extends State<AdminNewOfficialScreen> {
  @override
  Widget build(BuildContext context) {
    return const NewOfficialScreen(managerRoleId: "2");
  }
}
