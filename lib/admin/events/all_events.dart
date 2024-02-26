import 'package:anokha_admin/util/events/all_events.dart';
import 'package:flutter/material.dart';

class AdminAllEventsScreen extends StatefulWidget {
  const AdminAllEventsScreen({super.key});

  @override
  State<AdminAllEventsScreen> createState() => _AdminAllEventsScreenState();
}

class _AdminAllEventsScreenState extends State<AdminAllEventsScreen> {
  @override
  Widget build(BuildContext context) {
    return const AllEventsScreen(managerRoleId: "2");
  }
}
