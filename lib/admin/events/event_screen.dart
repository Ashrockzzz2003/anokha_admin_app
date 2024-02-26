import 'package:anokha_admin/util/events/event_screen.dart';
import 'package:flutter/material.dart';

class AdminEventScreen extends StatefulWidget {
  const AdminEventScreen({super.key, required this.eventId});

  final String eventId;

  @override
  State<AdminEventScreen> createState() => _AdminEventScreenState();
}

class _AdminEventScreenState extends State<AdminEventScreen> {
  @override
  Widget build(BuildContext context) {
    return EventScreen(managerRoleId: "2", eventId: widget.eventId);
  }
}
