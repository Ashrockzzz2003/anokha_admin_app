import 'package:anokha_admin/util/events/event_screen.dart';
import 'package:flutter/material.dart';

class SuperAdminEventScreen extends StatefulWidget {
  const SuperAdminEventScreen({super.key, required this.eventId});

  final String eventId;

  @override
  State<SuperAdminEventScreen> createState() => _SuperAdminEventScreenState();
}

class _SuperAdminEventScreenState extends State<SuperAdminEventScreen> {
  @override
  Widget build(BuildContext context) {
    return EventScreen(managerRoleId: "1", eventId: widget.eventId);
  }
}
