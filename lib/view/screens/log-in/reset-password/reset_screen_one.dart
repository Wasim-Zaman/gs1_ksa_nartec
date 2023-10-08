import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gs1_v2_project/providers/login_provider.dart';
import 'package:gs1_v2_project/res/common/common.dart';
import 'package:gs1_v2_project/utils/app_dialogs.dart';
import 'package:gs1_v2_project/view-model/login/login_services.dart';
import 'package:gs1_v2_project/view-model/login/reset-password/reset_password_services.dart';
import 'package:gs1_v2_project/view/screens/log-in/gs1_member_login_screen.dart';
import 'package:gs1_v2_project/view/screens/log-in/reset-password/reset_screen_two.dart';
import 'package:gs1_v2_project/view/screens/member-screens/get_barcode_screen.dart';
import 'package:gs1_v2_project/widgets/dropdown_widget.dart';
import 'package:gs1_v2_project/widgets/required_text_widget.dart';
import 'package:provider/provider.dart';

class ResetScreenOne extends StatefulWidget {
  const ResetScreenOne({super.key});
  static const String routeName = 'reset-screen-one';

  @override
  State<ResetScreenOne> createState() => _ResetScreenOneState();
}

class _ResetScreenOneState extends State<ResetScreenOne> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  List<String> activities = [];
  String? activityValue;
  String? activityId;
  @override
  void dispose() {
    emailController.dispose();
    formKey.currentState?.deactivate();
    super.dispose();
  }

  Future<void> selectActivity() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 600,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RequiredTextWidget(title: "Select Activity".tr),
                const SizedBox(height: 10),
                FutureBuilder(
                    future: LoginServices.getActivities(
                        email: emailController.text),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: LinearProgressIndicator(),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text("User on this email not found".tr),
                        );
                      }
                      final snap = snapshot.data;
                      final listOfAcitivies = snap;
                      activities = listOfAcitivies!
                          .where((activity) => (activity.activity != null ||
                              activity.activity != "null"))
                          .map((e) => e.activity.toString())
                          .toList();
                      activityId = listOfAcitivies
                          .where(
                              (element) => element.activity == activities.first)
                          .first
                          .activityID
                          .toString();
                      return DropdownWidget(
                        value: activityValue ?? activities.first,
                        list: activities,
                        onChanged: (value) {
                          setState(() {
                            activityValue = value;
                            activityId = listOfAcitivies
                                .where((element) =>
                                    element.activity == activityValue)
                                .first
                                .activityID
                                .toString();
                            Provider.of<LoginProvider>(context, listen: false)
                                .setActivity(activityValue);
                            Provider.of<LoginProvider>(context, listen: false)
                                .setEmail(emailController.text);
                            Navigator.of(context).pop();
                          });
                        },
                      );
                    }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          title: Text("Reset Password".tr),
          centerTitle: true,
        ),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RequiredTextWidget(title: "Email Address".tr),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: emailController,
                  hintText: "Enter your email".tr,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email".tr;
                    }
                    if (EmailValidator.validate(value) == false) {
                      return "Please enter a valid email".tr;
                    }
                    return null;
                  },
                ),
                activityValue != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          RequiredTextWidget(title: "Activity".tr),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(activityValue.toString()),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate() &&
                        activityValue == null) {
                      selectActivity().catchError(
                        (error) {
                          Common.showToast(
                            error
                                .toString()
                                .replaceAll("Exception: ", "Error: "),
                          );
                        },
                      );
                    } else {
                      AppDialogs.loadingDialog(context);
                      emailController.text =
                          Provider.of<LoginProvider>(context, listen: false)
                              .email
                              .toString();
                      activityValue =
                          Provider.of<LoginProvider>(context, listen: false)
                              .activity
                              .toString();
                      try {
                        ResetPasswordServices.forgotPassword(
                          emailController.text,
                          activityValue.toString(),
                          activityId.toString(),
                        ).then((value) {
                          AppDialogs.closeDialog();
                          Common.showToast(
                            "Sent verification code to your email".tr,
                            backgroundColor: Theme.of(context).primaryColor,
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResetScreenTwo(
                                email: emailController.text,
                                activity: activityValue.toString(),
                                activityId: activityId.toString(),
                              ),
                            ),
                          );
                        }).catchError(
                          (error) {
                            AppDialogs.closeDialog();
                            Common.showToast(
                              error
                                  .toString()
                                  .replaceAll("Exception: ", "Error: "),
                            );
                          },
                        );
                      } catch (error) {
                        Common.showToast(
                          error.toString().replaceAll(
                                "Exception: ",
                                "Error: ",
                              ),
                        );
                      }
                    }
                  },
                  child: Text("Send Verification Code".tr),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text("Login Again?".tr),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          Gs1MemberLoginScreen.routeName,
                        );
                      },
                      child: Text("Login Now".tr),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
