import 'package:anokha_admin/auth/login_screen.dart';
import 'package:anokha_admin/util/api.dart';
import 'package:anokha_admin/util/loading_screen.dart';
import 'package:anokha_admin/util/toast_message.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChooseEventToTakeAttendanceScreen extends StatefulWidget {
  const ChooseEventToTakeAttendanceScreen({
    super.key,
    required this.managerRoleId,
  });

  final String managerRoleId;

  @override
  State<ChooseEventToTakeAttendanceScreen> createState() =>
      _ChooseEventToTakeAttendanceScreenState();
}

class _ChooseEventToTakeAttendanceScreenState
    extends State<ChooseEventToTakeAttendanceScreen> {

  bool _isLoading = true;

  List<Map<String, dynamic>> eventsData = [], filteredEventsData = [];

  void _getAllEvents() async {
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
            API().getAllEventsUrl,
            options: Options(
              contentType: Headers.jsonContentType,
              headers: {
                "Authorization": "Bearer ${sp.getString("anokha-t")}",
              },
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
                debugPrint("getAllEvents");
                // debugPrint(response.data.toString());

                setState(() {
                  eventsData =
                  List<Map<String, dynamic>>.from(response.data["events"]);
                  filteredEventsData = eventsData;
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
    _getAllEvents();
  }

  Widget eventCard(int index) {
    return InkWell(
      onTap: () {
        // Redirect To Take Attendance Screen
      },
      borderRadius: BorderRadius.circular(16.0),
      child: Stack(
        alignment: Alignment.bottomCenter,
        fit: StackFit.expand,
        textDirection: TextDirection.ltr,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Image.network(
              filteredEventsData[index]["eventImageURL"],
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
              width: MediaQuery.of(context).size.width * 0.5,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ),
              decoration: BoxDecoration(
                backgroundBlendMode: BlendMode.overlay,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16.0),
                  bottomRight: Radius.circular(16.0),
                ),
                shape: BoxShape.rectangle,
                color: Theme.of(context).colorScheme.secondaryContainer,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    filteredEventsData[index]["eventName"],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.bodyMedium,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 4.0,
                  ),
                  Chip(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    label: Text(
                      "Take Attendance",
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.bodySmall,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    avatar: Icon(
                      Icons.calendar_month_rounded,
                      color: Theme.of(context).colorScheme.onPrimary,
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




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: _isLoading == true ? const LoadingComponent() : CustomScrollView(
        primary: true,
        physics: const BouncingScrollPhysics(),
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
                  "Events",
                  style: GoogleFonts.habibi(
                    textStyle: Theme.of(context).textTheme.headlineSmall,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 16.0,
              ),
              child: SearchBar(
                hintText: "Search Events",
                side: MaterialStateBorderSide.resolveWith(
                      (states) => BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    width: 1.0,
                  ),
                ),
                padding: MaterialStateProperty.resolveWith(
                      (states) => const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                ),
                enabled: true,
                leading: const Icon(
                  Icons.search_rounded,
                ),
                onChanged: (String value) {
                  setState(() {
                    filteredEventsData = eventsData
                        .where((element) => element["eventName"]
                        .toString()
                        .toLowerCase()
                        .contains(value.toLowerCase()))
                        .toList();
                  });
                },
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 16.0,
            ),
            sliver: SliverGrid(
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.75,
              ),
              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return eventCard(index);
                },
                childCount: filteredEventsData.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 48,
            ),
          ),
        ],
      ),
    );
  }
}
