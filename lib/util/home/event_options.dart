import 'package:anokha_admin/admin/events/new_event.dart';
import 'package:anokha_admin/super_admin/events/all_events.dart';
import 'package:anokha_admin/super_admin/events/new_event.dart';
import 'package:anokha_admin/util/404.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreenEventComponent extends StatelessWidget {
  const HomeScreenEventComponent({super.key, required this.managerRoleId});

  final String managerRoleId;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.99,
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.brightness == Brightness.light
            ? Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.4)
            : Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Manage Events",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              textStyle: Theme.of(context).textTheme.titleLarge,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          const Divider(),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: ElevatedButton.icon(
                  onPressed: () {
                    //  Navigate to Events Screen.
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) {
                          switch (managerRoleId) {
                            case "1":
                              return const SuperAdminAllEventsScreen();
                            case "2":
                              return const AdminNewEventScreen();
                            default:
                              return const NotFoundScreen();
                          }
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 16.0,
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  icon: Icon(
                    Icons.local_fire_department_rounded,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  label: Text(
                    "All Events",
                    style: GoogleFonts.raleway(
                      textStyle: Theme.of(context).textTheme.titleSmall,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // redirect to add new Official.
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) {
                          switch (managerRoleId) {
                            case "1":
                              return const SuperAdminNewEventScreen();
                            case "2":
                              return const AdminNewEventScreen();
                            default:
                              return const NotFoundScreen();
                          }
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 16.0,
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  icon: Icon(
                    Icons.add_circle_rounded,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  label: Text(
                    "New Event",
                    style: GoogleFonts.raleway(
                      textStyle: Theme.of(context).textTheme.titleSmall,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
