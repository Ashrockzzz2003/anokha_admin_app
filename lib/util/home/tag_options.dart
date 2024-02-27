import 'package:anokha_admin/admin/tags/add_tag_screen.dart';
import 'package:anokha_admin/admin/tags/all_tags_screen.dart';
import 'package:anokha_admin/super_admin/tags/add_tag_screen.dart';
import 'package:anokha_admin/super_admin/tags/all_tags_screen.dart';
import 'package:anokha_admin/util/404.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreenTagComponent extends StatelessWidget {
  const HomeScreenTagComponent({super.key, required this.managerRoleId});

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
            "Manage Tags",
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
                              return const SuperAdminAllTagsScreen();
                            case "2":
                              return const AdminAllTagsScreen();
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
                    Icons.tag_rounded,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  label: Text(
                    "All Tags",
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
                              return const SuperAdminAddTagScreen();
                            case "2":
                              return const AdminAddTagScreen();
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
                    "Add Tag",
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
