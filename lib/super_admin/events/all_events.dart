import 'package:anokha_admin/util/events/all_events.dart';
import 'package:flutter/material.dart';

class SuperAdminAllEventsScreen extends StatefulWidget {
  const SuperAdminAllEventsScreen({super.key});

  @override
  State<SuperAdminAllEventsScreen> createState() => _SuperAdminAllEventsScreenState();
}

class _SuperAdminAllEventsScreenState extends State<SuperAdminAllEventsScreen> {
  @override
  Widget build(BuildContext context) {
    return const AllEventsScreen(managerRoleId: "1");
  }
}
