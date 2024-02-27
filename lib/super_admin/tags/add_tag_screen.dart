import 'package:anokha_admin/util/tags/add_tag.dart';
import 'package:flutter/material.dart';

class SuperAdminAddTagScreen extends StatefulWidget {
  const SuperAdminAddTagScreen({super.key});

  @override
  State<SuperAdminAddTagScreen> createState() => _SuperAdminAddTagScreenState();
}

class _SuperAdminAddTagScreenState extends State<SuperAdminAddTagScreen> {
  @override
  Widget build(BuildContext context) {
    return const AddTagScreen(managerRoleId: "1");
  }
}
