import 'package:anokha_admin/util/api.dart';
import 'package:anokha_admin/util/loading_screen.dart';
import 'package:anokha_admin/util/qr_overlay.dart';
import 'package:anokha_admin/util/toast_message.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TakeAttendance extends StatefulWidget {
  const TakeAttendance({
    super.key,
    required this.eventData,
    required this.managerRoleId,
  });
  final Map<String, dynamic> eventData;
  final String managerRoleId;
  @override
  State<TakeAttendance> createState() => _TakeAttendanceState();
}

class _TakeAttendanceState extends State<TakeAttendance> {
  String? studentID;

  MobileScannerController cameraController = MobileScannerController(
    autoStart: true,
    facing: CameraFacing.back,
    formats: [BarcodeFormat.qrCode],
    useNewCameraSelector: true
  );
  bool _isLoading = false;

  bool qrDone = false;

  final List<bool> _selected = [true, false];

  void _cameraPermissionInitState() async {
    if (Platform.isAndroid) {
      if (await Permission.camera.request().isGranted) {
        cameraController.start();
      }

      if (!mounted) return;
    }
  }

  Future<String> markEntry(String studentId) async {
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

      debugPrint(
          "${API().markAttendanceEntryUrl}/$studentId-${widget.eventData["eventId"]}");

      final response = await dio.post(
        "${API().markAttendanceEntryUrl}/$studentId-${widget.eventData["eventId"]}",
        options: Options(
          contentType: Headers.jsonContentType,
          headers: {"Authorization": "Bearer ${sp.getString("anokha-t")}"},
          validateStatus: (status) {
            return status! < 1000;
          },
        ),
      );

      debugPrint("[ENTRY] ${response.statusCode}");

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

  Future<String> markExit(String studentId) async {
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

      final response = await dio.post(
        "${API().markEventAttendanceExitUrl}/$studentId-${widget.eventData["eventId"]}",
        options: Options(
          contentType: Headers.jsonContentType,
          headers: {"Authorization": "Bearer ${sp.getString("anokha-t")}"},
          validateStatus: (status) {
            return status! < 1000;
          },
        ),
      );

      debugPrint("[ENTRY] ${response.statusCode}");

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
    setState(() {
      _cameraPermissionInitState();
    });
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
                  title: Text(
                    'Take Attendance',
                    style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  centerTitle: true,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  actions: [
                    IconButton(
                      color: Colors.white,
                      icon: ValueListenableBuilder(
                        valueListenable: cameraController.torchState,
                        builder: (context, state, child) {
                          switch (state) {
                            case TorchState.off:
                              return const Icon(Icons.flash_off,
                                  color: Colors.grey);
                            case TorchState.on:
                              return const Icon(Icons.flash_on,
                                  color: Colors.yellow);
                          }
                        },
                      ),
                      iconSize: 24.0,
                      onPressed: () => cameraController.toggleTorch(),
                    ),
                    IconButton(
                      color: Colors.white,
                      icon: ValueListenableBuilder(
                        valueListenable: cameraController.cameraFacingState,
                        builder: (context, state, child) {
                          switch (state) {
                            case CameraFacing.front:
                              return const Icon(Icons.cameraswitch_rounded);
                            case CameraFacing.back:
                              return const Icon(Icons.cameraswitch_rounded);
                          }
                        },
                      ),
                      iconSize: 24.0,
                      onPressed: () => cameraController.switchCamera(),
                    ),
                  ],
                ),
                SliverFillRemaining(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    fit: StackFit.loose,
                    textDirection: TextDirection.ltr,
                    children: [
                      MobileScanner(
                        controller: cameraController,
                        fit: BoxFit.cover,
                        onDetect: (capture) {
                          final qrCode = capture.barcodes.first.rawValue;
                          if (qrCode != null && qrCode.startsWith("anokha://")) {
                            if (!qrDone) {
                              setState(() {
                                qrDone = true;
                              });

                              final studentId = qrCode.substring(9);

                              (_selected[0] ? markEntry(studentId) : markExit(studentId)).then((result) {
                                if (result == "1") {
                                  showToast(_selected[0] ? "Entry Marked" : "Exit Marked");

                                } else {
                                  showToast("Failed to mark. Try again.");
                                }

                                // Reset qrDone state after a short delay
                                Future.delayed(const Duration(milliseconds: 500), () {
                                  if (mounted) {
                                    setState(() {
                                      qrDone = false;
                                    });
                                  }
                                });
                              }).catchError((error) {
                                showToast("Error processing the scan: ${error.toString()}");
                                if (mounted) {
                                  setState(() {
                                    qrDone = false; // Reset on error
                                  });
                                }
                              });
                            }
                          } else {
                            if (mounted && qrDone) {
                              setState(() {
                                qrDone = false;
                              });
                            }
                          }
                        },
                      ),
                      QRScannerOverlay(
                        overlayColour: Theme.of(context)
                            .colorScheme
                            .background
                            .withOpacity(0.4),
                      ),
                      SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 24,
                            horizontal: 16.0,
                          ),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(32.0),
                              topRight: Radius.circular(32.0),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Scan QR Code",
                                style: GoogleFonts.poppins(
                                  textStyle:
                                      Theme.of(context).textTheme.titleLarge,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                              ),
                              Text(
                                "${widget.eventData["eventName"] ?? "the event"}",
                                style: GoogleFonts.poppins(
                                  textStyle:
                                      Theme.of(context).textTheme.labelSmall,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              ToggleButtons(
                                onPressed: (int index) {
                                  if (index == 0) {
                                    setState(() {
                                      _selected[0] = true;
                                      _selected[1] = false;
                                    });

                                    setState(() {
                                      qrDone = false;
                                    });

                                  } else {
                                    setState(() {
                                      _selected[0] = false;
                                      _selected[1] = true;
                                    });

                                    setState(() {
                                      qrDone = false;
                                    });
                                  }
                                },
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                                selectedBorderColor:
                                    Theme.of(context).colorScheme.primary,
                                selectedColor:
                                    Theme.of(context).colorScheme.onPrimary,
                                fillColor:
                                    Theme.of(context).colorScheme.primary,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                constraints: const BoxConstraints(
                                  minHeight: 40.0,
                                  minWidth: 80.0,
                                ),
                                isSelected: _selected,
                                children: const <Widget>[
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Text('Entry'),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Text('Exit'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
