import 'package:anokha_admin/auth/login_screen.dart';
import 'package:anokha_admin/util/api.dart';
import 'package:anokha_admin/util/data_validator.dart';
import 'package:anokha_admin/util/loading_screen.dart';
import 'package:anokha_admin/util/toast_message.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:markdown_editor_plus/markdown_editor_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewEventScreen extends StatefulWidget {
  const NewEventScreen({super.key, required this.managerRoleId});

  final String managerRoleId;

  @override
  State<NewEventScreen> createState() => _NewEventScreenState();
}

class _NewEventScreenState extends State<NewEventScreen> {
  List<Map<String, dynamic>> tagData = [], departmentData = [];

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

  void _getAllDepartments() async {
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
            API().getAllDepartmentsUrl,
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
                debugPrint("getAllDepartments");

                setState(() {
                  departmentData = List<Map<String, dynamic>>.from(
                      response.data["departments"]);
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
    _getAllTags();
    _getAllDepartments();
  }

  final GlobalKey<FormState> _newEventFormKey = GlobalKey<FormState>();

  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventDescriptionController =
      TextEditingController();
  final TextEditingController _eventMarkdownDescriptionController =
      TextEditingController();
  final TextEditingController _eventDateController = TextEditingController();
  final TextEditingController _eventTimeController = TextEditingController();
  final TextEditingController _eventVenueController = TextEditingController();
  final TextEditingController _eventImageURLController =
      TextEditingController();
  final TextEditingController _eventPriceController = TextEditingController();
  final TextEditingController _maxSeatsController = TextEditingController();
  final TextEditingController _minTeamSizeController = TextEditingController();
  final TextEditingController _maxTeamSizeController = TextEditingController();
  String? _isWorkshop,
      _isTechnical,
      _isGroup,
      _isPerHeadPrice,
      _isRefundable,
      _needGroupData,
      _eventDepartmentId;

  final List<int> _selectedTagIds = [];

  Future<String> _createNewEvent() async {
    setState(() {
      _isLoading = true;
    });

    if (_isGroup == "0") {
      setState(() {
        _needGroupData = "0";
        _minTeamSizeController.text = "1";
        _maxTeamSizeController.text = "1";
      });
    }

    try {
      final sp = await SharedPreferences.getInstance();
      if (sp.getString("anokha-t") == null) {
        showToast("Session Expired. Please login again.");
        return "-2";
      }

      final dio = Dio();

      debugPrint("[CREATE_EVENT] ${{
        "eventName": _eventNameController.text.trim(),
        // "eventDescription": _eventDescriptionController.text.trim(),
        // "eventMarkdownDescription": _eventMarkdownDescriptionController.text,
        "eventDate": _eventDateController.text.trim(),
        "eventTime": _eventTimeController.text.trim(),
        "eventVenue": _eventVenueController.text.trim(),
        "eventImageURL": _eventImageURLController.text.trim(),
        "eventPrice": _eventPriceController.text.trim(),
        "maxSeats": _maxSeatsController.text.trim(),
        "minTeamSize": _minTeamSizeController.text.trim(),
        "maxTeamSize": _maxTeamSizeController.text.trim(),
        "isWorkshop": _isWorkshop,
        "isTechnical": _isTechnical,
        "isGroup": _isGroup,
        "isPerHeadPrice": _isPerHeadPrice,
        "isRefundable": _isRefundable,
        "needGroupData": _needGroupData,
        "eventDepartmentId": _eventDepartmentId,
        "tags": _selectedTagIds,
      }}");

      final response = await dio.post(
        API().createEventUrl,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: {"Authorization": "Bearer ${sp.getString("anokha-t")}"},
          validateStatus: (status) {
            return status! < 1000;
          },
        ),
        data: {
          "eventName": _eventNameController.text.trim(),
          "eventDescription": _eventDescriptionController.text.trim(),
          "eventMarkdownDescription": _eventMarkdownDescriptionController.text,
          "eventDate": _eventDateController.text.trim(),
          "eventTime": _eventTimeController.text.trim(),
          "eventVenue": _eventVenueController.text.trim(),
          "eventImageURL": _eventImageURLController.text.trim(),
          "eventPrice": _eventPriceController.text.trim(),
          "maxSeats": _maxSeatsController.text.trim(),
          "minTeamSize": _minTeamSizeController.text.trim(),
          "maxTeamSize": _maxTeamSizeController.text.trim(),
          "isWorkshop": _isWorkshop,
          "isTechnical": _isTechnical,
          "isGroup": _isGroup,
          "isPerHeadPrice": _isPerHeadPrice,
          "isRefundable": _isRefundable,
          "needGroupData": _needGroupData,
          "eventDepartmentId": _eventDepartmentId,
          "tags": _selectedTagIds,
        },
      );

      debugPrint("[CREATE_EVENT] ${response.statusCode}");

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

  bool showPreview = false;

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
                        "New Event",
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
                    physics: const ClampingScrollPhysics(),
                    primary: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Form(
                      key: _newEventFormKey,
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
                            controller: _eventNameController,
                            validator: DataValidator().eventNameValidator,
                            decoration: InputDecoration(
                              labelText: "Event Name",
                              prefixIcon: const Icon(
                                  Icons.local_fire_department_rounded),
                              hintText: "Please enter the event name",
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
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            maxLines: null,
                            style: GoogleFonts.poppins(),
                            controller: _eventDescriptionController,
                            validator:
                                DataValidator().eventDescriptionValidator,
                            decoration: InputDecoration(
                              labelText: "Event Description",
                              hintText: "Please enter the event description",
                              helperText: "Max 255 chars",
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
                          if (_eventMarkdownDescriptionController
                                  .text.isNotEmpty &&
                              showPreview) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 8.0,
                              ),
                              width: MediaQuery.of(context).size.width * 0.99,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .outlineVariant,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: MarkdownAutoPreview(
                                controller: _eventMarkdownDescriptionController,
                                emojiConvert: true,
                                enableToolBar: false,
                                readOnly: true,
                              ),
                            ),
                          ],
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            maxLines: null,
                            style: GoogleFonts.poppins(),
                            controller: _eventMarkdownDescriptionController,
                            onChanged: (value) {
                              setState(() {
                                _eventMarkdownDescriptionController.text =
                                    value;
                              });
                            },
                            validator:
                                DataValidator().eventDescriptionValidator,
                            decoration: InputDecoration(
                              labelText: "Event Markdown Description",
                              hintText: "event markdown description",
                              helperText: "Max 5000 chars",
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
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Show Preview",
                                ),
                                Switch(
                                  value: showPreview,
                                  onChanged: (value) {
                                    setState(() {
                                      showPreview = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.datetime,
                            style: GoogleFonts.poppins(),
                            controller: _eventDateController,
                            validator: DataValidator().eventDateValidator,
                            decoration: InputDecoration(
                              labelText: "Event Start Date",
                              prefixIcon: const Icon(Icons.date_range),
                              hintText: "Please select the event start date",
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
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime(2100));

                              if (pickedDate != null) {
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                setState(() {
                                  _eventDateController.text = formattedDate;
                                });
                              } else {}
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: "Department",
                              prefixIcon: const Icon(Icons.flag_rounded),
                              hintText: "Event Conducted by Department",
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
                            value: _eventDepartmentId,
                            validator: DataValidator().deptValidator,
                            onChanged: (String? newValue) {
                              setState(() {
                                _eventDepartmentId = newValue;
                              });
                            },
                            items: departmentData.map<DropdownMenuItem<String>>(
                                    (Map<String, dynamic> value) {
                                  return DropdownMenuItem<String>(
                                    value: value["departmentId"].toString(),
                                    child: RichText(
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(
                                        text: value["departmentName"],
                                        style: GoogleFonts.poppins(),
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.datetime,
                            style: GoogleFonts.poppins(),
                            controller: _eventTimeController,
                            validator: DataValidator().eventTimeValidator,
                            decoration: InputDecoration(
                              labelText: "Event Start Time",
                              prefixIcon: const Icon(Icons.access_time_rounded),
                              hintText: "Please select the event start time",
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
                            onTap: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: _eventTimeController.text.isEmpty
                                    ? const TimeOfDay(hour: 12, minute: 0)
                                    : TimeOfDay(
                                        hour: int.parse(_eventTimeController
                                            .text
                                            .split(":")[0]),
                                        minute: int.parse(_eventTimeController
                                            .text
                                            .split(":")[1]),
                                      ),
                              );

                              if (pickedTime != null) {
                                String formattedTime =
                                    "${pickedTime.hour}:${pickedTime.minute}:00";
                                setState(() {
                                  _eventTimeController.text = formattedTime;
                                });
                              } else {}
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.name,
                            style: GoogleFonts.poppins(),
                            controller: _eventVenueController,
                            validator: DataValidator().eventVenueValidator,
                            decoration: InputDecoration(
                              labelText: "Event Venue",
                              prefixIcon: const Icon(Icons.location_on_rounded),
                              hintText: "Please enter the event venue",
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
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.url,
                            style: GoogleFonts.poppins(),
                            controller: _eventImageURLController,
                            validator: DataValidator().eventImageURLValidator,
                            decoration: InputDecoration(
                              labelText: "Event Image URL",
                              prefixIcon: const Icon(Icons.image_rounded),
                              hintText: "Please enter the event image URL",
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
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.44,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  style: GoogleFonts.poppins(),
                                  controller: _eventPriceController,
                                  validator:
                                      DataValidator().eventPriceValidator,
                                  decoration: InputDecoration(
                                    labelText: "Event Price",
                                    prefixIcon: const Icon(
                                      Icons.attach_money_rounded,
                                    ),
                                    hintText: "Please enter the event price",
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
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.44,
                                child: DropdownButtonFormField(
                                  value: _isPerHeadPrice,
                                  validator:
                                      DataValidator().isPerHeadPriceValidator,
                                  decoration: InputDecoration(
                                    labelText: "Pricing Type",
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
                                    labelStyle: GoogleFonts.raleway(),
                                  ),
                                  items: [
                                    DropdownMenuItem(
                                      value: "1",
                                      child: Text(
                                        "Per Head",
                                        style: GoogleFonts.poppins(),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: "0",
                                      child: Text(
                                        "Per Team",
                                        style: GoogleFonts.poppins(),
                                      ),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _isPerHeadPrice = value.toString();
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.44,
                                child: DropdownButtonFormField(
                                  value: _isWorkshop,
                                  validator:
                                      DataValidator().isWorkshopValidator,
                                  decoration: InputDecoration(
                                    labelText: "Event Type",
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
                                    labelStyle: GoogleFonts.raleway(),
                                  ),
                                  items: [
                                    DropdownMenuItem(
                                      value: "1",
                                      child: Text(
                                        "Workshop",
                                        style: GoogleFonts.poppins(),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: "0",
                                      child: Text(
                                        "Event",
                                        style: GoogleFonts.poppins(),
                                      ),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _isWorkshop = value.toString();
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.44,
                                child: DropdownButtonFormField(
                                  value: _isTechnical,
                                  validator:
                                      DataValidator().isTechnicalValidator,
                                  decoration: InputDecoration(
                                    labelText: "Technical?",
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
                                    labelStyle: GoogleFonts.raleway(),
                                  ),
                                  items: [
                                    DropdownMenuItem(
                                      value: "1",
                                      child: Text(
                                        "Yes",
                                        style: GoogleFonts.poppins(),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: "0",
                                      child: Text(
                                        "No",
                                        style: GoogleFonts.poppins(),
                                      ),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _isTechnical = value.toString();
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.44,
                                child: DropdownButtonFormField(
                                  value: _isRefundable,
                                  validator:
                                      DataValidator().isRefundableValidator,
                                  decoration: InputDecoration(
                                    labelText: "Refundable?",
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
                                    labelStyle: GoogleFonts.raleway(),
                                  ),
                                  items: [
                                    DropdownMenuItem(
                                      value: "1",
                                      child: Text(
                                        "Yes",
                                        style: GoogleFonts.poppins(),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: "0",
                                      child: Text(
                                        "No",
                                        style: GoogleFonts.poppins(),
                                      ),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _isRefundable = value.toString();
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.44,
                                child: DropdownButtonFormField(
                                  value: _isGroup,
                                  validator: DataValidator().isGroupValidator,
                                  decoration: InputDecoration(
                                    labelText: "Group/Individual",
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
                                    labelStyle: GoogleFonts.raleway(),
                                  ),
                                  items: [
                                    DropdownMenuItem(
                                      value: "1",
                                      child: Text(
                                        "Group",
                                        style: GoogleFonts.poppins(),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: "0",
                                      child: Text(
                                        "Individual",
                                        style: GoogleFonts.poppins(),
                                      ),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _isGroup = value.toString();
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          if (_isGroup == "1") ...[
                            const SizedBox(
                              height: 32,
                            ),
                            DropdownButtonFormField(
                              value: _needGroupData,
                              validator: DataValidator().needGroupDataValidator,
                              decoration: InputDecoration(
                                labelText: "Do you need team member data?",
                                helperMaxLines: 4,
                                helperText:
                                    "Select No if you only need team leader details and Yes if you need all team member data",
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
                                labelStyle: GoogleFonts.raleway(),
                              ),
                              items: [
                                DropdownMenuItem(
                                  value: "1",
                                  child: Text(
                                    "Yes",
                                    style: GoogleFonts.poppins(),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: "0",
                                  child: Text(
                                    "No",
                                    style: GoogleFonts.poppins(),
                                  ),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _needGroupData = value.toString();
                                });
                              },
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.44,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    style: GoogleFonts.poppins(),
                                    controller: _minTeamSizeController,
                                    validator:
                                        DataValidator().minTeamSizeValidator,
                                    decoration: InputDecoration(
                                      labelText: "Min Team Size",
                                      hintText: "Min",
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
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.44,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    style: GoogleFonts.poppins(),
                                    controller: _maxTeamSizeController,
                                    validator:
                                        DataValidator().maxTeamSizeValidator,
                                    decoration: InputDecoration(
                                      labelText: "Max Team Size",
                                      hintText: "Max",
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
                                  ),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.poppins(),
                            controller: _maxSeatsController,
                            validator: DataValidator().maxSeatsValidator,
                            decoration: InputDecoration(
                              labelText: "Registration Limit",
                              hintText: "Max Registrations Allowed",
                              helperText:
                                  "Enter the maximum number of registrations allowed",
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
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            "Select Tags",
                            style: GoogleFonts.poppins(
                              textStyle:
                                  Theme.of(context).textTheme.titleMedium,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const Divider(
                            thickness: 1,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: tagData
                                .map(
                                  (tag) => ChoiceChip(
                                    label: Text(
                                      tag["tagName"],
                                      style: GoogleFonts.poppins(),
                                    ),
                                    selected:
                                        _selectedTagIds.contains(tag["tagId"]),
                                    onSelected: (selected) {
                                      setState(() {
                                        if (selected) {
                                          _selectedTagIds.add(tag["tagId"]);
                                        } else {
                                          _selectedTagIds.remove(tag["tagId"]);
                                        }
                                      });
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Divider(
                            thickness: 1,
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_newEventFormKey.currentState!.validate()) {
                                  // TODO: Call API to register new event

                                  _createNewEvent().then((res) => {
                                        if (res == "1")
                                          {
                                            showToast(
                                              "Event Created Successfully",
                                            ),
                                            Navigator.of(context).pop(),
                                          }
                                        else if (res == "-2")
                                          {
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                              CupertinoPageRoute(
                                                builder: (context) {
                                                  return const LoginScreen();
                                                },
                                              ),
                                              (route) => false,
                                            ),
                                          }
                                        else
                                          {
                                            showToast(
                                              "Something went wrong. We're working on it. Please try again later.",
                                            ),
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
                                "Create Event",
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
                          const SizedBox(
                            height: 48,
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
