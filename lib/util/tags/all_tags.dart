import 'package:anokha_admin/admin/tags/add_tag_screen.dart';
import 'package:anokha_admin/auth/login_screen.dart';
import 'package:anokha_admin/super_admin/tags/add_tag_screen.dart';
import 'package:anokha_admin/util/404.dart';
import 'package:anokha_admin/util/api.dart';
import 'package:anokha_admin/util/loading_screen.dart';
import 'package:anokha_admin/util/toast_message.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllTagsScreen extends StatefulWidget {
  const AllTagsScreen({super.key, required this.managerRoleId});

  final String managerRoleId;

  @override
  State<AllTagsScreen> createState() => _AllTagsScreenState();
}

class _AllTagsScreenState extends State<AllTagsScreen> {
  List<Map<String, dynamic>> tagData = [];

  bool _isLoading = true;

  void _getAllTags() async {
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
            API().getAllTagsUrl,
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
                  tagData =
                      List<Map<String, dynamic>>.from(response.data["tags"]);
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

  Future<String> _toggleTagStatus(int index) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final sp = await SharedPreferences.getInstance();
      if (sp.getString("anokha-t") == null) {
        showToast("Session Expired. Please login again.");
        return "-2";
      }

      final dio = Dio();

      debugPrint("[TOGGLE_STATUS_TAG] ${{
        "tagId": tagData[index]["tagId"],
        "isActive": tagData[index]["isActive"] == "1" ? "0" : "1",
      }}");

      final response = await dio.post(
        API().toggleTagStatusUrl,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: {"Authorization": "Bearer ${sp.getString("anokha-t")}"},
          validateStatus: (status) {
            return status! < 1000;
          },
        ),
        data: {
          "tagId": tagData[index]["tagId"],
          "isActive": tagData[index]["isActive"] == "1" ? "0" : "1",
        },
      );

      debugPrint("[TOGGLE_STATUS_TAG] ${response.statusCode}");

      debugPrint(response.data.toString());

      if (response.statusCode == 200) {
        return "1";
      } else if ((response.statusCode == 400) &&
          (response.data["MESSAGE"].toString().isNotEmpty)) {
        showToast(
          response.data["MESSAGE"].toString(),
        );
      } else if (response.statusCode == 401) {
        showToast(
          "Session Expired. Please login again.",
        );
        return "-2";
      } else {
        showToast(
          "Something went wrong. We're working on it. Please try again later.",
        );
      }

      return "-1";
    } catch (e) {
      debugPrint(e.toString());
      showToast(
        "Something went wrong. We're working on it. Please try again later.",
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }

    return "-1";
  }

  @override
  void initState() {
    super.initState();
    _getAllTags();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context)
              .pushReplacement(CupertinoPageRoute(builder: (context) {
            switch (widget.managerRoleId) {
              case "1":
                return const SuperAdminAddTagScreen();
              case "2":
                return const AdminAddTagScreen();
              default:
                return const NotFoundScreen();
            }
          }));
        },
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        label: const Text("New Tag"),
        icon: const Icon(Icons.add_rounded),
      ),
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
                        "All Tags",
                        style: GoogleFonts.habibi(
                          textStyle: Theme.of(context).textTheme.headlineSmall,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 2.0,
                        ),
                        child: Card(
                          color: Theme.of(context)
                              .colorScheme
                              .secondaryContainer
                              .withOpacity(0.2),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: Text(
                                        tagData[index]["tagName"],
                                        style: GoogleFonts.poppins(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      tagData[index]["tagAbbreviation"],
                                      style: GoogleFonts.poppins(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Switch(
                                  value: tagData[index]["isActive"] == "1"
                                      ? true
                                      : false,
                                  onChanged: (value) {
                                    _toggleTagStatus(index).then((status) {
                                      if (status == "1") {
                                        setState(() {
                                          tagData[index]["isActive"] =
                                              tagData[index]["isActive"] == "1"
                                                  ? "0"
                                                  : "1";
                                        });
                                      }
                                    });
                                  },
                                  activeColor: Colors.greenAccent,
                                  inactiveThumbColor:
                                      Theme.of(context).colorScheme.error,
                                  activeTrackColor:
                                      Colors.greenAccent.withOpacity(0.5),
                                  inactiveTrackColor: Theme.of(context)
                                      .colorScheme
                                      .error
                                      .withOpacity(0.5),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: tagData.length,
                  ),
                ),
              ],
            ),
    );
  }
}
