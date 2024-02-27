import 'package:anokha_admin/util/tags/add_tag.dart';
import 'package:flutter/material.dart';

class AdminAddTagScreen extends StatefulWidget {
  const AdminAddTagScreen({super.key});

  @override
  State<AdminAddTagScreen> createState() => _AdminAddTagScreenState();
}

class _AdminAddTagScreenState extends State<AdminAddTagScreen> {
  @override
  Widget build(BuildContext context) {
    return const AddTagScreen(managerRoleId: "2");
  }
}
