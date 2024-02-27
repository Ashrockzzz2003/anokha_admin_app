import 'package:anokha_admin/admin/events/edit_event.dart';
import 'package:anokha_admin/auth/login_screen.dart';
import 'package:anokha_admin/super_admin/events/edit_event_screen.dart';
import 'package:anokha_admin/util/404.dart';
import 'package:anokha_admin/util/api.dart';
import 'package:anokha_admin/util/loading_screen.dart';
import 'package:anokha_admin/util/toast_message.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventScreen extends StatefulWidget {
  const EventScreen(
      {super.key, required this.managerRoleId, required this.eventId});

  final String managerRoleId, eventId;

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  bool _isLoading = true;

  Map<String, dynamic> eventData = {};

  void _fetchEventData() async {
    setState(() {
      _isLoading = true;
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
            // "https://web.abhinavramakrishnan.tech/api/user/getAllEvents",
            "${API().getIndividualEventPrefixUrl}/${widget.eventId}",
            options: Options(
              contentType: Headers.jsonContentType,
              validateStatus: (status) {
                return status! < 1000;
              },
            ),
          )
              .then((response) {
            // getTags API

            switch (response.statusCode) {
              case 200:
                // Success
                debugPrint("getAllTags");

                setState(() {
                  eventData = response.data;
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
              _isLoading = false;
            });
          }).catchError((e) {
            debugPrint(e.toString());
            showToast(
              "Something went wrong. We're working on it. Please try again later.",
            );

            setState(() {
              _isLoading = false;
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
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchEventData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: _isLoading == true
          ? const LoadingComponent()
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  snap: true,
                  pinned: true,
                  centerTitle: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  expandedHeight: MediaQuery.of(context).size.height * 0.16,
                  leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(builder: (context) {
                            switch (widget.managerRoleId.toString()) {
                              case "1":
                                return SuperAdminEditEventScreen(eventData: eventData);
                              case "2":
                                return AdminEditEventScreen(eventData: eventData);
                              default:
                                return const NotFoundScreen();
                            }
                          })
                        );
                      },
                      icon: const Icon(Icons.edit_rounded),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.symmetric(
                      horizontal: 0.0,
                      vertical: 8.0,
                    ),
                    centerTitle: true,
                    collapseMode: CollapseMode.parallax,
                    background: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(32.0),
                        bottomRight: Radius.circular(32.0),
                      ),
                      child: Image.asset(
                        "assets/ansan_1.jpg",
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                    title: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Text(
                        "About Event",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.habibi(
                          textStyle: Theme.of(context).textTheme.headlineSmall,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 8.0,
                          ),
                          margin: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  Theme.of(context).colorScheme.outlineVariant,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            eventData["eventName"] ?? "",
                            style: GoogleFonts.poppins(
                              textStyle:
                                  Theme.of(context).textTheme.titleMedium,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            eventData["eventImageURL"] ?? "",
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width * 0.9,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                          margin: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  Theme.of(context).colorScheme.outlineVariant,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            eventData["eventDescription"] ?? "",
                            style: GoogleFonts.poppins(
                              textStyle: Theme.of(context).textTheme.bodySmall,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                          margin: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  Theme.of(context).colorScheme.outlineVariant,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Venue, Date, Time, Price
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Venue",
                                    style: GoogleFonts.poppins(
                                      textStyle:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ),
                                  Text(
                                    eventData["eventVenue"] ?? "",
                                    style: GoogleFonts.poppins(
                                      textStyle:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              const Divider(
                                thickness: 1,
                              ),
                              const SizedBox(
                                height: 8,
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Date",
                                    style: GoogleFonts.poppins(
                                      textStyle:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ),
                                  Text(
                                    "${DateTime.tryParse(eventData["eventDate"])?.day}-${DateTime.tryParse(eventData["eventDate"])?.month}-${DateTime.tryParse(eventData["eventDate"])?.year}" ??
                                        "",
                                    style: GoogleFonts.poppins(
                                      textStyle:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height: 8,
                              ),
                              const Divider(
                                thickness: 1,
                              ),
                              const SizedBox(
                                height: 8,
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Time",
                                    style: GoogleFonts.poppins(
                                      textStyle:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ),
                                  Text(
                                    eventData["eventTime"] ?? "",
                                    style: GoogleFonts.poppins(
                                      textStyle:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height: 8,
                              ),
                              const Divider(
                                thickness: 1,
                              ),
                              const SizedBox(
                                height: 8,
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Price",
                                    style: GoogleFonts.poppins(
                                      textStyle:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ),
                                  Text(
                                    ("₹${eventData["eventPrice"]}${eventData["isPerHeadPrice"] == '1' ? " /head" : " /team"}"),
                                    style: GoogleFonts.poppins(
                                      textStyle:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                          margin: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  Theme.of(context).colorScheme.outlineVariant,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // minTeamSize, maxTeamSize, seatsFilled / maxSeats

                              const SizedBox(
                                height: 8,
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Min Team Size",
                                    style: GoogleFonts.poppins(
                                      textStyle:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ),
                                  Text(
                                    eventData["minTeamSize"].toString() ?? "",
                                    style: GoogleFonts.poppins(
                                      textStyle:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height: 8,
                              ),
                              const Divider(
                                thickness: 1,
                              ),
                              const SizedBox(
                                height: 8,
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Max Team Size",
                                    style: GoogleFonts.poppins(
                                      textStyle:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ),
                                  Text(
                                    eventData["maxTeamSize"].toString() ?? "",
                                    style: GoogleFonts.poppins(
                                      textStyle:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height: 8,
                              ),
                              const Divider(
                                thickness: 1,
                              ),
                              const SizedBox(
                                height: 8,
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Seats Filled",
                                    style: GoogleFonts.poppins(
                                      textStyle:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ),
                                  Text(
                                    "${eventData["seatsFilled"]}/${eventData["maxSeats"]}" ??
                                        "",
                                    style: GoogleFonts.poppins(
                                      textStyle:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        ),
                        /*
                        * String? _isWorkshop,
      _isTechnical,
      _isGroup,
      _isPerHeadPrice,
      _isRefundable,
      _needGroupData,
      _eventDepartmentId;*/

                        const SizedBox(
                          height: 16,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                          margin: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  Theme.of(context).colorScheme.outlineVariant,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 8,
                            children: [
                              // isWorkshop, isTechnical, isGroup, isRefundable, needGroupData, eventDepartmentId
                              Chip(
                                label: Text(
                                  eventData["isWorkshop"] == "1"
                                      ? "Workshop"
                                      : "Event",
                                  style: GoogleFonts.poppins(
                                    textStyle:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                              ),
                              Chip(
                                label: Text(
                                  eventData["isTechnical"] == "1"
                                      ? "Technical"
                                      : "Non-Technical",
                                  style: GoogleFonts.poppins(
                                    textStyle:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                              ),
                              Chip(
                                label: Text(
                                  eventData["isGroup"] == "1"
                                      ? "Group"
                                      : "Individual",
                                  style: GoogleFonts.poppins(
                                    textStyle:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                              ),
                              Chip(
                                label: Text(
                                  eventData["isRefundable"] == "1"
                                      ? "Refundable"
                                      : "Non-Refundable",
                                  style: GoogleFonts.poppins(
                                    textStyle:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                              ),
                              Chip(
                                label: Text(
                                  eventData["needGroupData"] == "1"
                                      ? "Group Data Needed"
                                      : "No Group Data Needed",
                                  style: GoogleFonts.poppins(
                                    textStyle:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                              ),
                              Chip(
                                label: Text(
                                  eventData["departmentName"] ?? "",
                                  style: GoogleFonts.poppins(
                                    textStyle:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                          margin: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  Theme.of(context).colorScheme.outlineVariant,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 8,
                            children: List<Widget>.generate(
                              eventData["tags"].length,
                              (index) {
                                return Chip(
                                  label: Text(
                                    eventData["tags"][index]["tagName"],
                                    style: GoogleFonts.poppins(
                                      textStyle:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                          margin: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  Theme.of(context).colorScheme.outlineVariant,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: MarkdownBody(
                            data: eventData["eventMarkdownDescription"] ?? "",
                            styleSheet: MarkdownStyleSheet(
                              p: GoogleFonts.poppins(
                                textStyle:
                                    Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 48,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
