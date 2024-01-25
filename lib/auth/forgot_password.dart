import 'package:anokha_admin/auth/reset_password.dart';
import 'package:anokha_admin/util/api.dart';
import 'package:anokha_admin/util/data_validator.dart';
import 'package:anokha_admin/util/loading_screen.dart';
import 'package:anokha_admin/util/toast_message.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _forgotPasswordKey = GlobalKey<FormState>();
  final TextEditingController _managerEmailController = TextEditingController();

  bool isLoading = true;

  Future<String> _managerForgotPassword() async {
    setState(() {
      isLoading = true;
    });

    try {
      final dio = Dio();

      debugPrint("[FORGOT_PASSWORD] ${{
        "managerEmail": _managerEmailController.text.trim(),
      }}");

      final response = await dio.post(
        API().forgotPasswordUrl,
        options: Options(
          contentType: Headers.jsonContentType,
          validateStatus: (status) {
            return status! < 1000;
          },
        ),
        data: {
          "managerEmail": _managerEmailController.text.trim(),
        },
      );

      debugPrint("[FORGOT_PASSWORD] ${response.statusCode}");

      if (response.statusCode == 200) {
        final sp = await SharedPreferences.getInstance();

        sp.clear();
        sp.setString("managerEmail", _managerEmailController.text.trim());
        sp.setString("anokha-fpt", response.data['SECRET_TOKEN']);

        showToast(
          "Password reset OTP sent to your email ID.",
        );

        return "1";
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
                SliverAppBar.large(
                  floating: false,
                  pinned: true,
                  snap: false,
                  centerTitle: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  expandedHeight: MediaQuery.of(context).size.height * 0.24,
                  backgroundColor:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.1),
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
                        "Recover Password",
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
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Form(
                      key: _forgotPasswordKey,
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
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                if (_forgotPasswordKey.currentState!
                                    .validate()) {
                                  _managerForgotPassword().then(
                                    (res) {
                                      if (res == "1") {
                                        Navigator.of(context).pushReplacement(
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                const ResetPasswordScreen(),
                                          ),
                                        );
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
                                Icons.mail_lock_rounded,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                              label: Text(
                                "Send OTP",
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
