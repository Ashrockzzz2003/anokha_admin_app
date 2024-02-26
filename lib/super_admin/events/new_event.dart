import 'package:anokha_admin/util/events/new_event_screen.dart';
import 'package:flutter/material.dart';

class SuperAdminNewEventScreen extends StatefulWidget {
  const SuperAdminNewEventScreen({super.key});

  @override
  State<SuperAdminNewEventScreen> createState() => _SuperAdminNewEventScreenState();
}

class _SuperAdminNewEventScreenState extends State<SuperAdminNewEventScreen> {
  @override
  Widget build(BuildContext context) {
    return const NewEventScreen(managerRoleId: "1");
  }
}
