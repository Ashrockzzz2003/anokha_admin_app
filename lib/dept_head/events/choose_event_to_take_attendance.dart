import 'package:anokha_admin/util/events/choose_event_to_take_attendance.dart';
import 'package:flutter/material.dart';

class DeptHeadChooseEventToTakeAttendanceScreen extends StatefulWidget {
  const DeptHeadChooseEventToTakeAttendanceScreen({super.key});

  @override
  State<DeptHeadChooseEventToTakeAttendanceScreen> createState() =>
      _DeptHeadChooseEventToTakeAttendanceScreenState();
}

class _DeptHeadChooseEventToTakeAttendanceScreenState
    extends State<DeptHeadChooseEventToTakeAttendanceScreen> {
  @override
  Widget build(BuildContext context) {
    return const ChooseEventToTakeAttendanceScreen(
      managerRoleId: "4",
    );
  }
}
