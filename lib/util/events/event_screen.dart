import 'package:anokha_admin/auth/login_screen.dart';
import 'package:anokha_admin/util/api.dart';
import 'package:anokha_admin/util/loading_screen.dart';
import 'package:anokha_admin/util/toast_message.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
      body: _isLoading == true ? const LoadingComponent() : CustomScrollView(
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
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      eventData["eventName"] ?? "",
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.titleMedium,
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

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
