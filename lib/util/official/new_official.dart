import 'package:anokha_admin/admin/home_screen.dart';
import 'package:anokha_admin/auth/login_screen.dart';
import 'package:anokha_admin/dept_head/home_screen.dart';
import 'package:anokha_admin/super_admin/home_screen.dart';
import 'package:anokha_admin/util/404.dart';
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

class NewOfficialScreen extends StatefulWidget {
  const NewOfficialScreen({super.key, required this.managerRoleId});

  final String managerRoleId;

  @override
  State<NewOfficialScreen> createState() => _NewOfficialScreenState();
}

class _NewOfficialScreenState extends State<NewOfficialScreen> {
  final GlobalKey<FormState> _newOfficialFormKey = GlobalKey<FormState>();
  final TextEditingController _managerFullNameController =
      TextEditingController();
  final TextEditingController _managerEmailController = TextEditingController();
  final TextEditingController _managerPhoneController = TextEditingController();

  String? selectedManagerDepartmentId, selectedManagerRoleId;
  List<String> managerDepartmentIdList = [], managerRoleIdList = [];

  bool isLoading = true;

  /*
  {
    "managerFullName":"Ark",
    "managerEmail":"cb.en.u4cse21001@cb.students.amrita.edu",
    "managerPhone":"9897989711",
    "managerRoleId":1,
    "managerDepartmentId":6
  }
  */

  Future<String> _registerOfficial() async {
    setState(() {
      isLoading = true;
    });

    try {
      final sp = await SharedPreferences.getInstance();
      if (sp.getString("anokha-t") == null) {
        showToast("Session Expired. Please login again.");
        return "-2";
      }

      final dio = Dio();

      debugPrint("[REGISTER_OFFICIAL] ${{
        "managerFullName": _managerFullNameController.text.trim(),
        "managerEmail": _managerEmailController.text.trim(),
        "managerPhone": _managerPhoneController.text.trim(),
        "managerRoleId": int.parse(selectedManagerRoleId ?? "I"),
        "managerDepartmentId": int.parse(selectedManagerDepartmentId ?? "I"),
      }}");

      final response = await dio.post(
        API().registerOfficialUrl,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: {"Authorization": "Bearer ${sp.getString("anokha-t")}"},
          validateStatus: (status) {
            return status! < 1000;
          },
        ),
        data: {
          "managerFullName": _managerFullNameController.text.trim(),
          "managerEmail": _managerEmailController.text.trim(),
          "managerPhone": _managerPhoneController.text.trim(),
          "managerRoleId": int.parse(selectedManagerRoleId ?? "I"),
          "managerDepartmentId": int.parse(selectedManagerDepartmentId ?? "I"),
        },
      );

      debugPrint("[REGISTER_OFFICIAL] ${response.statusCode}");

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
        isLoading = false;
      });
    }

    return "-1";
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
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
                  expandedHeight: MediaQuery.of(context).size.height * 0.24,
                  leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.symmetric(
                      horizontal: 0.0,
                      vertical: 8.0,
                    ),
                    centerTitle: true,
                    collapseMode: CollapseMode.parallax,
                    title: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Text(
                        "New Official",
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
                    physics: const ClampingScrollPhysics(),
                    primary: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Form(
                      key: _newOfficialFormKey,
                      autovalidateMode: AutovalidateMode.disabled,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 32.0,
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
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onErrorContainer,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onErrorContainer,
                                ),
                              ),
                              labelStyle: GoogleFonts.poppins(),
                            ),
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            style: GoogleFonts.poppins(),
                            controller: _managerEmailController,
                            validator: DataValidator().emailValidator,
                            decoration: InputDecoration(
                              labelText: "Email",
                              prefixIcon: const Icon(Icons.badge_rounded),
                              hintText: "Please enter official's Email",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onErrorContainer,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onErrorContainer,
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
                              prefixIcon:
                                  const Icon(Icons.alternate_email_rounded),
                              hintText: "Please enter official's Phone Number",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onErrorContainer,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onErrorContainer,
                                ),
                              ),
                              labelStyle: GoogleFonts.poppins(),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: "Official Role",
                              prefixIcon: const Icon(Icons.tag),
                              hintText: "Please select official's role",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onErrorContainer),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onErrorContainer),
                              ),
                              labelStyle: GoogleFonts.poppins(),
                            ),
                            value: selectedManagerRoleId,
                            validator: DataValidator().roleValidator,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedManagerRoleId = newValue;
                              });
                            },
                            items: <DropdownMenuItem<String>>[
                              if (widget.managerRoleId == "1") ...[
                                DropdownMenuItem(
                                  value: "2",
                                  child: Text(
                                    "Admin",
                                    style: GoogleFonts.poppins(),
                                  ),
                                ),
                              ],
                              if (widget.managerRoleId == "1" ||
                                  widget.managerRoleId == "2") ...[
                                DropdownMenuItem(
                                  value: "3",
                                  child: Text(
                                    "Finance",
                                    style: GoogleFonts.poppins(),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: "4",
                                  child: Text(
                                    "Department Head",
                                    style: GoogleFonts.poppins(),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: "5",
                                  child: Text(
                                    "Eventide Attendance Marker",
                                    style: GoogleFonts.poppins(),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: "6",
                                  child: Text(
                                    "Global Attendance Marker",
                                    style: GoogleFonts.poppins(),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: "8",
                                  child: Text(
                                    "Gate Entry Exit Marker",
                                    style: GoogleFonts.poppins(),
                                  ),
                                ),
                              ],
                              DropdownMenuItem(
                                value: "7",
                                child: Text(
                                  "Local Attendance Marker",
                                  style: GoogleFonts.poppins(),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: "Department",
                              prefixIcon: const Icon(Icons.flag_rounded),
                              hintText: "Department of the official",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onErrorContainer),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onErrorContainer),
                              ),
                              labelStyle: GoogleFonts.poppins(),
                            ),
                            value: selectedManagerDepartmentId,
                            validator: DataValidator().deptValidator,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedManagerDepartmentId = newValue;
                              });
                            },
                            items: Helper().departmentNameList.map<
                                DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: Helper().deptNameToId[value],
                                child: RichText(
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    text: value,
                                    style: GoogleFonts.poppins(),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_newOfficialFormKey.currentState!
                                    .validate()) {
                                  _registerOfficial().then((res) => {
                                        if (res == "1")
                                          {
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    CupertinoPageRoute(
                                                        builder: (context) {
                                              switch (widget.managerRoleId) {
                                                case "1":
                                                  return const SuperAdminHomeScreen();
                                                case "2":
                                                  return const AdminHomeScreen();
                                                case "4":
                                                  return const DeptHeadHomeScreen();
                                                default:
                                                  return const NotFoundScreen();
                                              }
                                            }), (route) => false)
                                          }
                                        else if (res == "-2")
                                          {
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    CupertinoPageRoute(
                                                        builder: (context) {
                                              return const LoginScreen();
                                            }), (route) => false)
                                          }
                                      });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 16.0,
                                ),
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                              ),
                              child: Text(
                                "Register Official",
                                style: GoogleFonts.poppins(
                                  textStyle:
                                      Theme.of(context).textTheme.titleLarge,
                                  fontWeight: FontWeight.w400,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
