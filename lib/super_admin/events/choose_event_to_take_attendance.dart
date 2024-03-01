import 'package:anokha_admin/util/events/choose_event_to_take_attendance.dart';
import 'package:flutter/material.dart';

class SuperAdminChooseEventToTakeAttendanceScreen extends StatefulWidget {
  const SuperAdminChooseEventToTakeAttendanceScreen({super.key});

  @override
  State<SuperAdminChooseEventToTakeAttendanceScreen> createState() =>
      _SuperAdminChooseEventToTakeAttendanceScreenState();
}

class _SuperAdminChooseEventToTakeAttendanceScreenState
    extends State<SuperAdminChooseEventToTakeAttendanceScreen> {
  @override
  Widget build(BuildContext context) {
    return const ChooseEventToTakeAttendanceScreen(
      managerRoleId: "1",
    );
  }
}
