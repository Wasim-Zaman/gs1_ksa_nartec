import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gs1_v2_project/utils/app_dialogs.dart';
import 'package:gs1_v2_project/utils/colors.dart';
import 'package:gs1_v2_project/view-model/login/login_services.dart';
import 'package:gs1_v2_project/view/screens/log-in/otp_screen.dart';
import 'package:gs1_v2_project/view/screens/log-in/widgets/logo/login_logo_widget.dart';
import 'package:gs1_v2_project/view/screens/log-in/widgets/text_fields/password_text_field_widget.dart';
import 'package:gs1_v2_project/widgets/dropdown_widget.dart';
import 'package:gs1_v2_project/widgets/required_text_widget.dart';

class SelectActivityAndPasswordScreen extends StatefulWidget {
  final String userEmail;
  final List<ActivitiesModel> activities;
  const SelectActivityAndPasswordScreen(
      {Key? key, required this.userEmail, required this.activities})
      : super(key: key);
  static const String routeName = "/select_activity_&_password_screen";

  @override
  State<SelectActivityAndPasswordScreen> createState() =>
      _SelectActivityAndPasswordScreenState();
}

class _SelectActivityAndPasswordScreenState
    extends State<SelectActivityAndPasswordScreen> {
  List<String> activities = [];
  String? activityValue;
  String? activityId;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();

  showOtpPopup(String message,
      {String? email, String? activity, String? password, String? otp}) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.scale,
      title: 'OTP',
      desc: message,
      btnOkOnPress: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPScreen(
              email: email,
              activity: activity,
              activityId: activityId,
              password: password,
              generatedOtp: otp,
            ),
          ),
        );
      },
      btnOkIcon: Icons.check_circle,
      onDismissCallback: (_) {
        Navigator.pop(context);
      },
    ).show();
  }

  @override
  void initState() {
    formKey.currentState?.save();
    for (var element in widget.activities) {
      if (element.activity != null || element.activity != "null") {
        activities.add(element.activity!);
      }
    }
    activityValue = activities.first;
    activityId = widget.activities
        .firstWhere((element) => element.activity == activityValue)
        .activityID;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final email = widget.userEmail;
    return Scaffold(
      backgroundColor: bgGrey,
      appBar: AppBar(
        title: Text("selectActivityAndPassword".tr),
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: ListView(
          children: [
            const LoginLogoWidget(),
            RequiredTextWidget(title: "activity".tr),
            const SizedBox(height: 10),
            DropdownWidget(
              value: activityValue ?? activities.first,
              list: activities,
              onChanged: (activity) {
                setState(() {
                  activityValue = activity;
                  activityId = widget.activities
                      .firstWhere((element) => element.activity == activity)
                      .activityID;
                });
              },
            ),
            const SizedBox(height: 20),
            RequiredTextWidget(title: "password".tr),
            const SizedBox(height: 10),
            Form(
              key: formKey,
              child: PasswordTextFieldWidget(
                controller: passwordController,
                validator: (password) {
                  if (password!.isEmpty) {
                    return "providePassword".tr;
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  formKey.currentState?.save();
                  if (activityValue != null &&
                      passwordController.text.isNotEmpty) {
                    // Common.showToast(
                    //   'Please Wait For Admin Approval',
                    //   backgroundColor: Colors.blue,
                    // );
                    AppDialogs.loadingDialog(context);
                    LoginServices.loginWithPassword(
                      email,
                      activityValue!,
                      passwordController.text,
                      activityId.toString(),
                    ).then((response) {
                      AppDialogs.closeDialog();
                      final message = response['message'] as String;
                      final otp = response['otp'] as String;

                      showOtpPopup(
                        message,
                        email: email,
                        activity: activityValue,
                        password: passwordController.text,
                        otp: otp,
                      );
                    }).onError((error, stackTrace) {
                      AppDialogs.closeDialog();
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        animType: AnimType.topSlide,
                        title: 'Error',
                        desc: error.toString().replaceAll('Exception:', ''),
                        btnOkOnPress: () {},
                        btnOkIcon: Icons.check_circle,
                        onDismissCallback: (_) {},
                      ).show();
                    });
                  } else {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.bottomSlide,
                      title: 'Warning'.tr,
                      desc: 'Please select an activity and give a password'.tr,
                      btnOkOnPress: () {},
                      btnOkIcon: Icons.check_circle,
                      onDismissCallback: (_) {},
                    ).show();
                  }
                }
              },
              child: Text("loginNow".tr),
            ),
          ],
        ),
      ),
    );
  }
}
