import 'package:anokha_admin/auth/login_screen.dart';
import 'package:anokha_admin/util/api.dart';
import 'package:anokha_admin/util/data_validator.dart';
import 'package:anokha_admin/util/helper.dart';
import 'package:anokha_admin/util/loading_screen.dart';
import 'package:anokha_admin/util/toast_message.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.managerRoleId});

  final String managerRoleId;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;

  Map<String, dynamic> officialData = {};

  void _getProfile() async {
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
            API().profileUrl,
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
            switch (response.statusCode) {
              case 200:
                debugPrint("getOfficials");

                debugPrint(response.data.toString());

                setState(() {
                  officialData = {
                    "managerFullName": response.data["managerFullName"],
                    "managerEmail": response.data["managerEmail"],
                    "managerPhone": response.data["managerPhone"],
                    "departmentName": response.data["managerDepartment"],
                    "managerDepartmentId": response.data["managerDepartmentId"],
                    "managerRoleId": response.data["managerRoleId"],
                  };
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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _managerFullNameController =
      TextEditingController();
  final TextEditingController _managerPhoneController = TextEditingController();

  Future<String> _editProfile() async {
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

      debugPrint("[EDIT_PROFILE] ${{
        "managerFullName": _managerFullNameController.text.trim(),
        "managerPhone": _managerPhoneController.text.trim(),
        "managerDepartmentId": officialData["departmentName"],
      }}");

      final response = await dio.post(
        API().editProfileUrl,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: {"Authorization": "Bearer ${sp.getString("anokha-t")}"},
          validateStatus: (status) {
            return status! < 1000;
          },
        ),
        data: {
          "managerFullName": _managerFullNameController.text.trim(),
          "managerPhone": _managerPhoneController.text.trim(),
          "managerDepartmentId": officialData["managerDepartmentId"],
        },
      );

      debugPrint("[EDIT_PROFILE] ${response.statusCode}");

      // debugPrint(response.data.toString());

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

  Widget _editProfileWidget() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 32.0,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 16.0,
              ),
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width * 0.88,
                minHeight: MediaQuery.of(context).size.height * 0.12,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                image: const DecorationImage(
                  image: AssetImage("assets/ansan_1.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16.0,
                ),
                child: Text(
                  "Edit Profile",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.habibi(
                    textStyle: Theme.of(context).textTheme.headlineMedium,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Chip(
              avatar: const Icon(
                Icons.verified_user_rounded,
                color: Colors.black,
                opticalSize: 2.0,
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
              padding: const EdgeInsets.all(4.0),
              labelPadding: const EdgeInsets.symmetric(
                horizontal: 2.0,
                vertical: 0.0,
              ),
              label: Text(
                Helper().roleIdToRoleName(
                  officialData["managerRoleId"].toString(),
                ),
                style: GoogleFonts.raleway(
                  textStyle: Theme.of(context).textTheme.bodyMedium,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                textAlign: TextAlign.left,
              ),
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(
              height: 32,
            ),
            TextField(
              controller:
                  TextEditingController(text: officialData["managerEmail"]),
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Email ID",
                prefixIcon: const Icon(Icons.email_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller:
                  TextEditingController(text: officialData["departmentName"]),
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Department",
                prefixIcon: const Icon(Icons.apartment_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              keyboardType: TextInputType.name,
              style: GoogleFonts.poppins(),
              controller: _managerFullNameController,
              validator: DataValidator().fullNameValidator,
              decoration: InputDecoration(
                labelText: "Full Name",
                prefixIcon: const Icon(Icons.person_rounded),
                hintText: "Please enter the official's full name",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
                labelStyle: GoogleFonts.poppins(),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              keyboardType: TextInputType.phone,
              style: GoogleFonts.poppins(),
              controller: _managerPhoneController,
              validator: DataValidator().phoneValidator,
              decoration: InputDecoration(
                labelText: "Phone Number",
                prefixIcon: const Icon(Icons.alternate_email_rounded),
                hintText: "Please enter official's Phone Number",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
                labelStyle: GoogleFonts.poppins(),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _editProfile().then(
                      (res) {
                        if (res != "-1") {
                          debugPrint(
                              "[EDIT_PROFILE]: ${Helper().roleIdToRoleName(res)}");

                          Navigator.of(context).pop();
                          showToast(
                            "Profile updated successfully.",
                          );
                          _getProfile();

                        }
                      },
                    );
                  }
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
                  Icons.login_rounded,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                label: Text(
                  "Update",
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.titleLarge,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getProfile();
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
                  expandedHeight: MediaQuery.of(context).size.height * 0.24,
                  leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  actions: [
                    IconButton(
                        icon: const Icon(Icons.edit_rounded),
                        onPressed: () {
                          setState(() {
                            _managerFullNameController.text =
                                officialData["managerFullName"];
                            _managerPhoneController.text =
                                officialData["managerPhone"];
                          });

                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16.0),
                                topRight: Radius.circular(16.0),
                              ),
                            ),
                            constraints: BoxConstraints(
                              minWidth: MediaQuery.of(context).size.width,
                            ),
                            enableDrag: true,
                            useSafeArea: true,
                            isDismissible: true,
                            showDragHandle: true,
                            isScrollControlled: true,
                            builder: (context) {
                              return _editProfileWidget();
                            },
                          );
                        }),
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
                        "Profile",
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 32.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Chip(
                          avatar: const Icon(
                            Icons.verified_user_rounded,
                            color: Colors.black,
                            opticalSize: 2.0,
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
                          padding: const EdgeInsets.all(4.0),
                          labelPadding: const EdgeInsets.symmetric(
                            horizontal: 2.0,
                            vertical: 0.0,
                          ),
                          label: Text(
                            Helper().roleIdToRoleName(
                              officialData["managerRoleId"].toString(),
                            ),
                            style: GoogleFonts.raleway(
                              textStyle: Theme.of(context).textTheme.bodyMedium,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        TextField(
                          controller: TextEditingController(
                              text: officialData["managerFullName"]),
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: "Full Name",
                            prefixIcon: const Icon(Icons.person_rounded),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextField(
                          controller: TextEditingController(
                              text: officialData["managerEmail"]),
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: "Email ID",
                            prefixIcon: const Icon(Icons.email_rounded),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextField(
                          controller: TextEditingController(
                              text: officialData["managerPhone"]),
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: "Phone Number",
                            prefixIcon: const Icon(Icons.phone_rounded),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextField(
                          controller: TextEditingController(
                              text: officialData["departmentName"]),
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: "Department",
                            prefixIcon: const Icon(Icons.apartment_rounded),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
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
