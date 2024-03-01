import 'package:anokha_admin/util/events/choose_event_to_take_attendance.dart';
import 'package:flutter/material.dart';

class AdminChooseEventToTakeAttendanceScreen extends StatefulWidget {
  const AdminChooseEventToTakeAttendanceScreen({super.key});

  @override
  State<AdminChooseEventToTakeAttendanceScreen> createState() =>
      _AdminChooseEventToTakeAttendanceScreenState();
}

class _AdminChooseEventToTakeAttendanceScreenState
    extends State<AdminChooseEventToTakeAttendanceScreen> {
  @override
  Widget build(BuildContext context) {
    return const ChooseEventToTakeAttendanceScreen(
      managerRoleId: "2",
    );
  }
}
