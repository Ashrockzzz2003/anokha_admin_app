import 'package:anokha_admin/util/events/new_event_screen.dart';
import 'package:flutter/material.dart';

class AdminNewEventScreen extends StatefulWidget {
  const AdminNewEventScreen({super.key});

  @override
  State<AdminNewEventScreen> createState() => _AdminNewEventScreenState();
}

class _AdminNewEventScreenState extends State<AdminNewEventScreen> {
  @override
  Widget build(BuildContext context) {
    return const NewEventScreen(managerRoleId: "2");
  }
}
