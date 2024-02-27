import 'package:anokha_admin/util/events/edit_event_screen.dart';
import 'package:flutter/material.dart';

class AdminEditEventScreen extends StatefulWidget {
  const AdminEditEventScreen({super.key, required this.eventData});

  final Map<String, dynamic> eventData;

  @override
  State<AdminEditEventScreen> createState() =>
      _AdminNewEventScreenState();
}

class _AdminNewEventScreenState extends State<AdminEditEventScreen> {
  @override
  Widget build(BuildContext context) {
    return EditEventScreen(
      managerRoleId: "2",
      eventData: widget.eventData,
    );
  }
}
