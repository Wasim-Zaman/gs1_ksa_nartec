import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gs1_v2_project/utils/app_dialogs.dart';
import 'package:gs1_v2_project/utils/colors.dart';
import 'package:gs1_v2_project/view-model/login/login_services.dart';
import 'package:gs1_v2_project/view/screens/log-in/reset-password/reset_screen_one.dart';
import 'package:gs1_v2_project/view/screens/log-in/select_activity_and_password_screen.dart';
import 'package:gs1_v2_project/view/screens/log-in/widgets/logo/login_logo_widget.dart';
import 'package:gs1_v2_project/view/screens/log-in/widgets/text_fields/text_field_widget.dart';
import 'package:gs1_v2_project/widgets/required_text_widget.dart';
import 'package:ionicons/ionicons.dart';

class Gs1MemberLoginScreen extends StatefulWidget {
  const Gs1MemberLoginScreen({super.key});
  static const String routeName = "/gs1_member_login_screen";

  @override
  State<Gs1MemberLoginScreen> createState() => _Gs1MemberLoginScreenState();
}

class _Gs1MemberLoginScreenState extends State<Gs1MemberLoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  bool showSpinner = false;

  @override
  void initState() {
    formKey.currentState?.activate();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    formKey.currentState?.deactivate();
    formKey.currentState?.dispose();
    super.dispose();
  }

  login() {
    if (formKey.currentState?.validate() ?? false) {
      AppDialogs.loadingDialog(context);
      LoginServices.getActivities(email: emailController.text.trim())
          .then((activities) {
        AppDialogs.closeDialog();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SelectActivityAndPasswordScreen(
              userEmail: emailController.text,
              activities: activities,
            ),
          ),
        );
      }).catchError((error) {
        AppDialogs.closeDialog();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString().replaceAll("Exception:", "")),
            backgroundColor: Colors.red,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGrey,
      appBar: AppBar(
        title: Text("gs1MemberLogin".tr),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              const LoginLogoWidget(),
              RequiredTextWidget(title: "emailAddress".tr),
              const SizedBox(height: 10),
              TextFieldWidget(
                controller: emailController,
                prefixIcon: Ionicons.mail_outline,
                label: "abc@domain.com",
                keyboardType: TextInputType.emailAddress,
                validator: (email) {
                  if (email == null || email.isEmpty) {
                    return "Please enter your email address";
                  }
                  if (EmailValidator.validate(email) == false) {
                    return "Please enter a valid email address";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: login,
                    child: showSpinner
                        ? const Center(
                            child: CircularProgressIndicator(
                            color: Colors.white,
                          ))
                        : Text("loginNow".tr)),
              ),
              const SizedBox(height: 50),
              Row(
                children: [
                  Text("forgotPassword".tr),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(ResetScreenOne.routeName);
                    },
                    child: Text("clickHereToResetPassword".tr),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
