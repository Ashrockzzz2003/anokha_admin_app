import 'package:anokha_admin/util/events/edit_event_screen.dart';
import 'package:flutter/material.dart';

class SuperAdminEditEventScreen extends StatefulWidget {
  const SuperAdminEditEventScreen({super.key, required this.eventData});

  final Map<String, dynamic> eventData;

  @override
  State<SuperAdminEditEventScreen> createState() =>
      _SuperAdminNewEventScreenState();
}

class _SuperAdminNewEventScreenState extends State<SuperAdminEditEventScreen> {
  @override
  Widget build(BuildContext context) {
    return EditEventScreen(
      managerRoleId: "1",
      eventData: widget.eventData,
    );
  }
}
