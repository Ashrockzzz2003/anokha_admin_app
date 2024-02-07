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

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _resetPasswordFormKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _managerEmailController = TextEditingController();
  final TextEditingController _managerPasswordController =
      TextEditingController();
  final TextEditingController _managerConfirmPasswordController =
      TextEditingController();

  bool _showPassword = false;
  bool isLoading = true;

  Future<String> _managerResetPassword() async {
    setState(() {
      isLoading = true;
    });

    try {
      final dio = Dio();

      debugPrint("[RESET_PASSWORD] ${{
        "otp": Helper().sha256Hash(_otpController.text),
        "managerPassword": Helper().sha256Hash(_managerPasswordController.text),
      }}");

      final sp = await SharedPreferences.getInstance();

      if (!sp.containsKey("anokha-fpt")) {
        sp.clear();
        showToast("OTP Expired. Please try again later.");
        return "-2";
      }

      final response = await dio.post(
        API().resetPasswordUrl,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: {
            "Authorization": "Bearer ${sp.getString("anokha-fpt")}",
          },
          validateStatus: (status) {
            return status! < 1000;
          },
        ),
        data: {
          "otp": Helper().sha256Hash(_otpController.text),
          "managerPassword":
              Helper().sha256Hash(_managerPasswordController.text),
        },
      );

      debugPrint("[RESET_PASSWORD] ${response.statusCode}");

      if (response.statusCode == 200) {
        final sp = await SharedPreferences.getInstance();
        sp.clear();
        sp.setString("managerEmail", _managerEmailController.text);

        showToast("Password reset successfully.");

        return "1";
      } else if ((response.statusCode == 400) &&
          (response.data["MESSAGE"].toString().isNotEmpty)) {
        showToast(
          response.data["MESSAGE"].toString(),
        );
      } else if ((response.statusCode == 401)) {
        sp.clear();
        showToast("OTP Expired. Please try again later.");
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
                SliverAppBar.large(
                  floating: false,
                  pinned: true,
                  snap: false,
                  centerTitle: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  expandedHeight: MediaQuery.of(context).size.height * 0.24,
                  backgroundColor:
                      Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.1),
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
                        "Reset Password",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.abrilFatface(
                          textStyle: Theme.of(context).textTheme.titleLarge,
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
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Form(
                      key: _resetPasswordFormKey,
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
                            initialValue: _managerEmailController.text,
                            enabled: false,
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
                              disabledBorder: OutlineInputBorder(
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
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.poppins(),
                            controller: _otpController,
                            validator: DataValidator().otpValidator,
                            decoration: InputDecoration(
                              labelText: "OTP",
                              prefixIcon: const Icon(Icons.repeat_one_rounded),
                              hintText:
                                  "Please enter OTP received on your email",
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
                              labelText: "New Password",
                              prefixIcon: const Icon(Icons.password_rounded),
                              hintText: "Please enter new password",
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
                          TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            style: GoogleFonts.poppins(),
                            controller: _managerConfirmPasswordController,
                            validator: DataValidator().passwordValidator,
                            obscureText: !_showPassword,
                            decoration: InputDecoration(
                              labelText: "Confirm Password",
                              prefixIcon: const Icon(Icons.password_rounded),
                              hintText: "Please confirm your password",
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
                            height: 32,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_resetPasswordFormKey.currentState!
                                        .validate() &&
                                    (_managerPasswordController.text !=
                                        _managerConfirmPasswordController
                                            .text)) {
                                  showToast("Passwords do not match.");
                                  return;
                                }

                                if (_resetPasswordFormKey.currentState!
                                    .validate()) {
                                  _managerResetPassword().then(
                                    (res) {
                                      if (res == "1") {
                                        debugPrint(
                                            "[RESET_PASSWORD]: ${Helper().roleIdToRoleName(res)}");
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                CupertinoPageRoute(
                                                    builder: (context) {
                                          return const LoginScreen();
                                        }), (route) => false);
                                      } else if (res == "-2") {
                                        Navigator.of(context).pop();
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
                              child: Text(
                                "Verify OTP and Reset Password",
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
