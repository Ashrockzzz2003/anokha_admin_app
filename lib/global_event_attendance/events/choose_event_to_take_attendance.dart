import 'package:anokha_admin/util/events/choose_event_to_take_attendance.dart';
import 'package:flutter/material.dart';

class GlobalEventAttendanceMarkerChooseEventToTakeAttendanceScreen extends StatefulWidget {
  const GlobalEventAttendanceMarkerChooseEventToTakeAttendanceScreen({super.key});

  @override
  State<GlobalEventAttendanceMarkerChooseEventToTakeAttendanceScreen> createState() =>
      _GlobalEventAttendanceMarkerChooseEventToTakeAttendanceScreenState();
}

class _GlobalEventAttendanceMarkerChooseEventToTakeAttendanceScreenState
    extends State<GlobalEventAttendanceMarkerChooseEventToTakeAttendanceScreen> {
  @override
  Widget build(BuildContext context) {
    return const ChooseEventToTakeAttendanceScreen(
      managerRoleId: "6",
    );
  }
}
