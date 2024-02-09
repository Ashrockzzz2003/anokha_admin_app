import 'package:anokha_admin/admin/official/new_official.dart';
import 'package:anokha_admin/auth/login_screen.dart';
import 'package:anokha_admin/dept_head/home_screen.dart';
import 'package:anokha_admin/super_admin/official/new_official.dart';
import 'package:anokha_admin/util/404.dart';
import 'package:anokha_admin/util/api.dart';
import 'package:anokha_admin/util/helper.dart';
import 'package:anokha_admin/util/loading_screen.dart';
import 'package:anokha_admin/util/toast_message.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllOfficialsScreen extends StatefulWidget {
  const AllOfficialsScreen({super.key, required this.managerRoleId});

  final String managerRoleId;

  @override
  State<AllOfficialsScreen> createState() => _AllOfficialsScreenState();
}

class _AllOfficialsScreenState extends State<AllOfficialsScreen> {
  List<Map<String, dynamic>> officialData = [], filteredOfficialData = [];
  bool isLoading = true;

  void _getAllOfficials() async {
    setState(() {
      isLoading = true;
    });

    try {
      SharedPreferences.getInstance().then((sp) {
        if (!sp.containsKey("anokha-t")) {
          showToast("Session expired. Please login again.");
          Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(builder: (context) {
            return const LoginScreen();
          }), (route) => false);
        } else {
          Dio()
              .get(
            API().getAllOfficialsUrl,
            options: Options(
              contentType: Headers.jsonContentType,
              headers: {
                "Authorization": "Bearer ${sp.getString("anokha-t")}",
              },
            ),
          )
              .then((response) {
            // TODO: getOfficials API

            /*
            {
                "MESSAGE": "Successfully Fetched All Officials.",
                "officials": [
                    {
                        "managerId": 2,
                        "managerFullName": "Admin WMD Ash",
                        "managerEmail": "ashrockzzz2003@gmail.com",
                        "managerPhone": "9696969696",
                        "managerAccountStatus": "1",
                        "managerRoleId": 1,
                        "roleName": "SUPER_ADMIN",
                        "managerDepartmentId": 6,
                        "departmentName": "Computer Science and Engineering",
                        "departmentAbbreviation": "CSE"
                    },
                    {
                        "managerId": 3,
                        "managerFullName": "Hariharan",
                        "managerEmail": "hariharan.14107@gmail.com",
                        "managerPhone": "9545949494",
                        "managerAccountStatus": "1",
                        "managerRoleId": 4,
                        "roleName": "DEPTARTMENT_HEAD",
                        "managerDepartmentId": 6,
                        "departmentName": "Computer Science and Engineering",
                        "departmentAbbreviation": "CSE"
                    }
                ]
            }
            */

            switch (response.statusCode) {
              case 200:
                // TODO: Success
                debugPrint("getOfficials");

                setState(() {
                  officialData = List<Map<String, dynamic>>.from(
                      response.data["officials"] as List<dynamic>);
                  filteredOfficialData = List<Map<String, dynamic>>.from(
                      response.data["officials"] as List<dynamic>);
                });
                break;
              case 400:
                if (response.data["MESSAGE"] != null) {
                  showToast(response.data["MESSAGE"]);
                } else {
                  showToast(
                      "Something went wrong. We're working on it. Please try again later.");
                }
                break;
              case 401:
                showToast("Session Expired. Please login again.");
                SharedPreferences.getInstance().then((sp) {
                  final String? managerEmail = sp.getString("managerEmail");
                  sp.clear();
                  sp.setString("managerEmail", managerEmail ?? "");
                });
                Navigator.of(context).pushAndRemoveUntil(
                    CupertinoPageRoute(builder: (context) {
                  return const LoginScreen();
                }), (route) => false);
                break;
              default:
                showToast(
                    "Something went wrong. We're working on it. Please try again later.");
                break;
            }

            setState(() {
              isLoading = false;
            });
          }).catchError((e) {
            debugPrint(e.toString());
            showToast(
              "Something went wrong. We're working on it. Please try again later.",
            );

            setState(() {
              isLoading = false;
            });
          });
        }
      });
    } catch (e) {
      debugPrint(e.toString());
      showToast(
        "Something went wrong. We're working on it. Please try again later.",
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      isLoading = true;
    });

    _getAllOfficials();
  }

  Widget officialCard(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: BorderSide(
            color: Theme.of(context).colorScheme.secondaryContainer,
            width: 1.0,
          ),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: BorderSide(
            color: Theme.of(context).colorScheme.secondaryContainer,
            width: 1.0,
          ),
        ),
        visualDensity: VisualDensity.comfortable,
        collapsedBackgroundColor:
            Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.4),
        backgroundColor:
            Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
        tilePadding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 6.0,
        ),
        dense: true,
        trailing: const Icon(Icons.keyboard_arrow_down_rounded),
        title: Text(
          "  ${filteredOfficialData[index]["managerFullName"]}" ?? "",
          style: GoogleFonts.raleway(
            textStyle: Theme.of(context).textTheme.titleMedium,
            color: Theme.of(context).colorScheme.secondary,
          ),
          textAlign: TextAlign.start,
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Chip(
              avatar: filteredOfficialData[index]['managerAccountStatus'] == "1"
                  ? const Icon(
                      Icons.verified_rounded,
                      color: Colors.black,
                      opticalSize: 2.0,
                    )
                  : const Icon(
                      Icons.gpp_bad_rounded,
                      color: Colors.black,
                      opticalSize: 1.0,
                    ),
              elevation: 1,
              iconTheme: const IconThemeData(
                color: Colors.black,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              side: const BorderSide(
                color: Colors.black,
              ),
              label: const SizedBox(),
              labelPadding: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(0),
              backgroundColor:
                  filteredOfficialData[index]["managerAccountStatus"] == "1"
                      ? Colors.greenAccent
                      : Theme.of(context).colorScheme.error,
            ),
            const SizedBox(
              width: 2.0,
            ),
            Chip(
              avatar: const Icon(
                Icons.offline_bolt_rounded,
              ),
              labelPadding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
              side: const BorderSide(
                color: Colors.black,
                width: 2,
              ),
              elevation: 1,
              iconTheme: IconThemeData(
                color: Theme.of(context).colorScheme.onTertiary,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              padding: const EdgeInsets.all(0),
              label: Text(
                Helper().roleIdToRoleName(
                  filteredOfficialData[index]["managerRoleId"].toString(),
                ),
                style: GoogleFonts.raleway(
                  color: Theme.of(context).colorScheme.onTertiary,
                ),
                textAlign: TextAlign.left,
              ),
              backgroundColor: Theme.of(context).colorScheme.tertiary,
            ),
          ],
        ),
        children: [
          const Divider(
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(
              Icons.account_circle_rounded,
            ),
            title: Text(
              "View Profile",
              style: GoogleFonts.raleway(
                textStyle: Theme.of(context).textTheme.bodyMedium,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.edit_rounded,
            ),
            title: Text(
              "Edit Profile",
              style: GoogleFonts.raleway(
                textStyle: Theme.of(context).textTheme.bodyMedium,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          if (filteredOfficialData[index]["managerAccountStatus"] == "1") ...[
            ListTile(
              leading: Icon(
                Icons.gpp_bad_rounded,
                color: Theme.of(context).colorScheme.error,
              ),
              title: Text(
                "Deactivate Account",
                style: GoogleFonts.raleway(
                  textStyle: Theme.of(context).textTheme.bodyMedium,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
          ] else ...[
            ListTile(
              leading: const Icon(
                Icons.verified_rounded,
                color: Colors.greenAccent,
              ),
              title: Text(
                "Activate Account",
                style: GoogleFonts.raleway(
                  textStyle: Theme.of(context).textTheme.bodyMedium,
                  fontWeight: FontWeight.w600,
                  color: Colors.greenAccent,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButton: isLoading == true
          ? null
          : FloatingActionButton.extended(
              backgroundColor: Theme.of(context).colorScheme.primary,
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) {
                      switch (widget.managerRoleId) {
                        case "1":
                          return const SuperAdminNewOfficialScreen();
                        case "2":
                          return const AdminNewOfficialScreen();
                        case "4":
                          return const DeptHeadHomeScreen();
                        default:
                          return const NotFoundScreen();
                      }
                    },
                  ),
                );
              },
              label: Text(
                "New Official",
                style: GoogleFonts.raleway(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              icon: Icon(
                Icons.add_rounded,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
      body: isLoading == true
          ? const LoadingComponent()
          : CustomScrollView(
              slivers: [
                SliverAppBar.large(
                  floating: false,
                  pinned: true,
                  snap: false,
                  centerTitle: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .secondaryContainer
                      .withOpacity(0.3),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(16.0),
                    ),
                  ),
                  leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.symmetric(
                      horizontal: 0.0,
                      vertical: 16.0,
                    ),
                    centerTitle: true,
                    collapseMode: CollapseMode.parallax,
                    title: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Text(
                        "All Officials",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.abrilFatface(
                          textStyle: Theme.of(context).textTheme.headlineSmall,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SingleChildScrollView(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (filteredOfficialData.isEmpty) ...[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.95,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 16.0,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              color: Theme.of(context).colorScheme.error,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.lightbulb,
                                      color:
                                          Theme.of(context).colorScheme.onError,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      "No Officials registered under you yet!",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.raleway(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onError,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Divider(
                                  thickness: 1,
                                  color: Theme.of(context).colorScheme.onError,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "Add new officials by clicking the button below",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.raleway(
                                    textStyle:
                                        Theme.of(context).textTheme.bodyLarge,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        Theme.of(context).colorScheme.onError,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ] else ...[
                          // TODO: Filters
                          ListView.builder(
                            itemCount: filteredOfficialData.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 16.0,
                            ),
                            itemBuilder: (context, index) {
                              return officialCard(index);
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
