import 'package:anokha_admin/util/events/take_attendance.dart';
import 'package:flutter/material.dart';

class SuperAdminTakeEventAttendance extends StatefulWidget {
  const SuperAdminTakeEventAttendance({super.key, required this.eventData});

  final Map<String, dynamic> eventData;

  @override
  State<SuperAdminTakeEventAttendance> createState() =>
      _SuperAdminTakeEventAttendanceState();
}

class _SuperAdminTakeEventAttendanceState
    extends State<SuperAdminTakeEventAttendance> {
  @override
  Widget build(BuildContext context) {
    return TakeAttendance(eventData: widget.eventData, managerRoleId: "1");
  }
}
