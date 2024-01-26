import 'package:anokha_admin/admin/home_screen.dart';
import 'package:anokha_admin/auth/forgot_password.dart';
import 'package:anokha_admin/dept_head/home_screen.dart';
import 'package:anokha_admin/eventide_attendance/home_screen.dart';
import 'package:anokha_admin/finance/home_screen.dart';
import 'package:anokha_admin/gate_entry_exit/home_screen.dart';
import 'package:anokha_admin/global_event_attendance/home_screen.dart';
import 'package:anokha_admin/local_event_attendance/home_screen.dart';
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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final TextEditingController _managerEmailController = TextEditingController();
  final TextEditingController _managerPasswordController =
      TextEditingController();

  bool _showPassword = false;
  bool isLoading = true;

  Future<String> _managerLogin() async {
    setState(() {
      isLoading = true;
    });

    try {
      final dio = Dio();

      debugPrint("[LOGIN] ${{
        "managerEmail": _managerEmailController.text.trim(),
        "managerPassword": Helper().sha256Hash(_managerPasswordController.text),
      }}");

      final response = await dio.post(
        API().loginUrl,
        options: Options(
          contentType: Headers.jsonContentType,
          validateStatus: (status) {
            return status! < 1000;
          },
        ),
        data: {
          "managerEmail": _managerEmailController.text.trim(),
          "managerPassword":
              Helper().sha256Hash(_managerPasswordController.text),
        },
      );

      debugPrint("[LOGIN] ${response.statusCode}");

      if (response.statusCode == 200) {
        final sp = await SharedPreferences.getInstance();

        sp.clear();

        sp.setString("anokha-t", response.data['SECRET_TOKEN']);
        sp.setString("managerFullName", response.data['managerFullName']);
        sp.setString("managerEmail", response.data['managerEmail']);
        sp.setString("managerPhone", response.data['managerPhone']);
        sp.setString(
            "managerRoleId", response.data['managerRoleId'].toString());

        return response.data["managerRoleId"].toString();
      } else if ((response.statusCode == 400) &&
          (response.data["MESSAGE"].toString().isNotEmpty)) {
        showToast(
          response.data["MESSAGE"].toString(),
        );
      } else {
        showToast(
          "Something went wrong. We're working on it. Please try again later.",
        );
      }

      return "-1";
    } catch (e) {
      debugPrint(e.toString());
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

    SharedPreferences.getInstance().then((sp) {
      if (sp.containsKey("managerEmail")) {
        _managerEmailController.text = sp.getString("managerEmail") ?? "";
      }

      setState(() {
        isLoading = false;
      });
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
                SliverAppBar(
                  pinned: true,
                  floating: false,
                  snap: false,
                  forceMaterialTransparency: true,
                  centerTitle: true,
                  clipBehavior: Clip.antiAlias,
                  expandedHeight: 232.0,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.symmetric(
                      horizontal: 0.0,
                      vertical: 8.0,
                    ),
                    centerTitle: true,
                    collapseMode: CollapseMode.parallax,
                    background: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.1),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 16.0,
                          ),
                          Image.asset(
                            "assets/anokha2024_logo.png",
                            height: 120.0,
                            fit: BoxFit.fitWidth,
                            filterQuality: FilterQuality.high,
                            alignment: Alignment.center,
                            colorBlendMode: BlendMode.srcATop,
                            gaplessPlayback: true,
                            isAntiAlias: true,
                          ),
                          Chip(
                            padding: const EdgeInsets.all(8.0),
                            avatar: const Icon(
                              Icons.security_rounded,
                            ),
                            side: const BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                            elevation: 1,
                            iconTheme: const IconThemeData(
                              color: Colors.black,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            label: Text(
                              "Anokha Admin App",
                              style: GoogleFonts.poppins(
                                textStyle:
                                    Theme.of(context).textTheme.titleMedium,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            backgroundColor: Colors.greenAccent,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    primary: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Form(
                      key: _loginFormKey,
                      autovalidateMode: AutovalidateMode.disabled,
                      canPop: false,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 72.0,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            style: GoogleFonts.poppins(),
                            controller: _managerEmailController,
                            validator: DataValidator().emailValidator,
                            decoration: InputDecoration(
                              labelText: "Email ID",
                              prefixIcon: const Icon(Icons.badge_rounded),
                              hintText: "Please enter your Email ID",
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
                            keyboardType: TextInputType.visiblePassword,
                            style: GoogleFonts.poppins(),
                            controller: _managerPasswordController,
                            validator: DataValidator().passwordValidator,
                            obscureText: !_showPassword,
                            decoration: InputDecoration(
                              labelText: "Password",
                              prefixIcon: const Icon(Icons.password_rounded),
                              hintText: "Please enter your password",
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _showPassword = !_showPassword;
                                  });
                                },
                                icon: Icon(
                                  _showPassword == false
                                      ? Icons.visibility_off_rounded
                                      : Icons.visibility_rounded,
                                ),
                              ),
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
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  CupertinoPageRoute(
                                    builder: (context) {
                                      return const ForgotPasswordScreen();
                                    },
                                  ),
                                );
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                overlayColor: MaterialStateProperty.all(
                                  Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer
                                      .withOpacity(0.2),
                                ),
                              ),
                              child: Text(
                                "Forgot Password?",
                                style: GoogleFonts.poppins(
                                  textStyle:
                                      Theme.of(context).textTheme.titleSmall,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                if (_loginFormKey.currentState!.validate()) {
                                  _managerLogin().then(
                                    (res) {
                                      if (res != "-1") {
                                        debugPrint(
                                            "[LOGIN]: ${Helper().roleIdToRoleName(res)}");

                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                CupertinoPageRoute(
                                                    builder: (context) {
                                          switch (res) {
                                            case "1":
                                              return const SuperAdminHomeScreen();
                                            case "2":
                                              return const AdminHomeScreen();
                                            case "3":
                                              return const FinanceHomeScreen();
                                            case "4":
                                              return const DeptHeadHomeScreen();
                                            case "5":
                                              return const EventideAttendanceHomeScreen();
                                            case "6":
                                              return const GlobalEventAttendanceHomeScreen();
                                            case "7":
                                              return const LocalEventAttendanceHomeScreen();
                                            case "8":
                                              return const GateEntryExitHomeScreen();
                                            default:
                                              return const NotFoundScreen();
                                          }
                                        }), (route) => false);
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
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                              ),
                              icon: Icon(
                                Icons.login_rounded,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                              label: Text(
                                "Login",
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
