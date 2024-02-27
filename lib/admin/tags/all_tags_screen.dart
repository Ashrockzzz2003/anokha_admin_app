import 'package:anokha_admin/util/tags/all_tags.dart';
import 'package:flutter/material.dart';

class AdminAllTagsScreen extends StatefulWidget {
  const AdminAllTagsScreen({super.key});

  @override
  State<AdminAllTagsScreen> createState() => _AdminAllTagsScreenState();
}

class _AdminAllTagsScreenState extends State<AdminAllTagsScreen> {
  @override
  Widget build(BuildContext context) {
    return const AllTagsScreen(managerRoleId: "2");
  }
}
