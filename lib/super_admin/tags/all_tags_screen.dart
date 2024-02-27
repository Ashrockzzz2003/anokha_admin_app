import 'package:anokha_admin/util/tags/all_tags.dart';
import 'package:flutter/material.dart';

class SuperAdminAllTagsScreen extends StatefulWidget {
  const SuperAdminAllTagsScreen({super.key});

  @override
  State<SuperAdminAllTagsScreen> createState() => _SuperAdminAllTagsScreenState();
}

class _SuperAdminAllTagsScreenState extends State<SuperAdminAllTagsScreen> {
  @override
  Widget build(BuildContext context) {
    return const AllTagsScreen(managerRoleId: "1");
  }
}
