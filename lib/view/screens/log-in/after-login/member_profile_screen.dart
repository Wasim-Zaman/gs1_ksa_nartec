import 'dart:io';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:get/get.dart';
import 'package:gs1_v2_project/constants/colors/app_colors.dart';
import 'package:gs1_v2_project/constants/icons/app_icons.dart';
import 'package:gs1_v2_project/models/login-models/dashboard_model.dart';
import 'package:gs1_v2_project/models/login-models/profile/member_profile_model.dart';
import 'package:gs1_v2_project/res/common/common.dart';
import 'package:gs1_v2_project/utils/app_dialogs.dart';
import 'package:gs1_v2_project/view-model/login/after-login/profile/member_profile_services.dart';
import 'package:gs1_v2_project/view-model/login/after-login/validate_cr_services.dart';
import 'package:gs1_v2_project/view/screens/log-in/widgets/text_widgets/primary_text_widget.dart';
import 'package:gs1_v2_project/view/screens/member-screens/get_barcode_screen.dart';
import 'package:gs1_v2_project/widgets/buttons/primary_button_widget.dart';
import 'package:gs1_v2_project/widgets/custom_drawer_widget.dart';
import 'package:gs1_v2_project/widgets/images/image_widget.dart';
import 'package:gs1_v2_project/widgets/loading/loading_widget.dart';
import 'package:gs1_v2_project/widgets/required_text_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:velocity_x/velocity_x.dart';

class MemberProfileScreen extends StatefulWidget {
  const MemberProfileScreen({super.key});
  static const String routeName = 'member-profile-screen';

  @override
  State<MemberProfileScreen> createState() => _MemberProfileScreenState();
}

class _MemberProfileScreenState extends State<MemberProfileScreen> {
  late Map? args;
  late DashboardModel? response;
  late int? userId;
  String? title = 'Member Details'.tr;
  int _selectedIndex = 0;
  PageController pageController = PageController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)?.settings.arguments as Map;
    response = args?['response'];
    userId = args?['userId'];
    return WillPopScope(
      onWillPop: () async {
        _scaffoldKey.currentState?.openDrawer();
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(title!),
        ),
        drawer: CustomDrawerWidget(
          userId: response?.memberData?.user?.id ?? userId,
          response: response,
        ),
        body: FutureBuilder(
          future: MemberProfileServices.getMemberProfile(userId!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingWidget();
            } else if (!snapshot.hasData) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: AppColors.primaryColor,
                    ),
                    Text("noDataFound".tr), // use the key and add .tr with it
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {});
                      },
                      icon: const Icon(Icons.refresh),
                      label: Text("Refresh The Page".tr),
                    ),
                  ],
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.red,
                    ),
                    Text(snapshot.error.toString()),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {});
                      },
                      icon: const Icon(Icons.refresh),
                      label: Text("Refresh The Page".tr),
                    ),
                  ],
                ),
              );
            }
            final MemberProfileModel? memberProfileModel = snapshot.data;
            return SizedBox.expand(
              child: PageView(
                controller: pageController,
                onPageChanged: (index) {
                  if (_selectedIndex == 0) {
                    title = 'Member Details'.tr;
                  } else if (_selectedIndex == 1) {
                    title = 'Member Profile'.tr;
                  }
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                children: <Widget>[
                  _selectedIndex == 0
                      ? DetailsScreen(
                          memberProfileModel: memberProfileModel,
                        )
                      : ProfileScreen(
                          memberProfileModel: memberProfileModel,
                          userId: userId.toString(),
                        ),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: _selectedIndex,
          showElevation: true, // use this to remove appBar's elevation
          onItemSelected: (index) => setState(() {
            _selectedIndex = index;
            if (_selectedIndex == 0) {
              title = 'Member Details'.tr;
            } else if (_selectedIndex == 1) {
              title = 'Member Profile'.tr;
            }
            pageController.animateToPage(index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease);
          }),
          items: [
            BottomNavyBarItem(
              icon: const Icon(Icons.apps),
              title: Text('Details'.tr),
              activeColor: Theme.of(context).primaryColor,
            ),
            BottomNavyBarItem(
              icon: const Icon(Icons.person),
              title: Text('Profile'.tr),
              activeColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.memberProfileModel, this.userId});
  final MemberProfileModel? memberProfileModel;
  final String? userId;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final addressLine1Controller = TextEditingController();
  final addressLine2Controller = TextEditingController();
  final otherMobileController = TextEditingController();
  final otherLandlineController = TextEditingController();
  final districtController = TextEditingController();
  final websiteController = TextEditingController();
  final noOfStaffController = TextEditingController();
  final buildingNoController = TextEditingController();
  final unitNoController = TextEditingController();
  final qrCodeNoController = TextEditingController();
  final companyIdController = TextEditingController();
  final mobileExtensionController = TextEditingController();
  final countryNameController = TextEditingController();
  final crNumberController = TextEditingController();
  final activitiesController = TextEditingController();

  File? imageFile;
  String? imageFileName;
  File? addressImageFile;
  String? addressImageFileName;

  String? img, addImg;

  bool isValidate = false;

  // scaffold key
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    final MemberProfileModel? memberProfileModel = widget.memberProfileModel;
    final profile = memberProfileModel?.memberProfile;

    addressLine1Controller.text = profile?.address1 ?? '';
    otherMobileController.text = profile?.additionalNumber ?? '';
    otherLandlineController.text = profile?.otherLandline ?? '';
    districtController.text = profile?.district ?? '';
    websiteController.text = profile?.website ?? '';
    noOfStaffController.text = profile?.noOfStaff ?? '';
    buildingNoController.text = profile?.buildingNo ?? '';
    unitNoController.text = profile?.unitNumber ?? '';
    qrCodeNoController.text = profile?.qrCorde ?? '';
    companyIdController.text = profile?.companyID ?? '';
    countryNameController.text = profile?.address?.countryName ?? "";

    super.initState();
  }

  @override
  void dispose() {
    _scaffoldKey.currentState?.dispose();
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    otherMobileController.dispose();
    otherLandlineController.dispose();
    districtController.dispose();
    websiteController.dispose();
    noOfStaffController.dispose();
    buildingNoController.dispose();
    unitNoController.dispose();
    qrCodeNoController.dispose();
    companyIdController.dispose();
    mobileExtensionController.dispose();
    countryNameController.dispose();
    crNumberController.dispose();
    activitiesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    img =
        "${widget.memberProfileModel?.memberProfile?.imagePath}/${widget.memberProfileModel?.memberProfile?.image}";
    addImg =
        "${widget.memberProfileModel?.memberProfile?.imagePath}/${widget.memberProfileModel?.memberProfile?.addressImage}";

    Common.urlToFile(img!).then((value) => imageFile = value);
    Common.urlToFile(addImg!).then((value) => addressImageFile = value);

    return WillPopScope(
      onWillPop: () {
        // Navigator.pop(context);
        _scaffoldKey.currentState?.openDrawer();
        return Future.value(false);
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Column(
            children: [
              ExpansionPanelList.radio(
                animationDuration: const Duration(seconds: 1),
                children: [
                  ExpansionPanelRadio(
                    value: 1,
                    headerBuilder: (context, isExpanded) {
                      return ListTile(
                        leading: Image.asset(
                            "${AppIcons.membershipIconsBasePath}image_section.png"),
                        title: Text(
                          'Image'.tr,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                    body: Stack(
                      fit: StackFit.loose,
                      children: [
                        imageFile?.path != null
                            ? Image.file(
                                imageFile!,
                                width: 256,
                                height: 256,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                img ?? "",
                                height: 256,
                                width: 256,
                                filterQuality: FilterQuality.high,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const LoadingWidget();
                                },
                                cacheHeight: 256,
                                cacheWidth: 256,
                                errorBuilder: (context, error, stackTrace) =>
                                    Placeholder(
                                  color: Colors.pink.shade400,
                                  fallbackHeight: 256,
                                  fallbackWidth: 256,
                                ),
                              ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          left: 0,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 30),
                            child: ElevatedButton(
                              onPressed: () {
                                ImagePicker()
                                    .pickImage(source: ImageSource.gallery)
                                    .then((value) {
                                  if (value == null) return;
                                  setState(() {
                                    imageFile = File(value.path);
                                    imageFileName = value.path.split('/').last;
                                  });
                                });
                              },
                              child: Text('Choose Image'.tr),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ExpansionPanelRadio(
                    value: 2,
                    headerBuilder: (context, isExpanded) {
                      return ListTile(
                        leading: Image.asset(
                            "${AppIcons.membershipIconsBasePath}company_details_section.png"),
                        title: Text('Company Details'.tr,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),
                      );
                    },
                    body: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RequiredTextWidget(
                              title: "Company Name [English]".tr,
                            ),
                            TextFormField(
                              enabled: false,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              initialValue: widget.memberProfileModel
                                  ?.memberProfile?.companyNameEng,
                            ),
                            const SizedBox(height: 10),
                            RequiredTextWidget(
                                title: "Company Name [Arabic]".tr),
                            TextFormField(
                              enabled: false,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              initialValue: widget.memberProfileModel
                                  ?.memberProfile?.companyNameArabic,
                            ),
                            const SizedBox(height: 10),
                            RequiredTextWidget(title: "Mobile".tr),
                            TextFormField(
                              enabled: false,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              initialValue: widget
                                  .memberProfileModel?.memberProfile?.mobile,
                            ),
                            const SizedBox(height: 10),
                            RequiredTextWidget(title: "Extension".tr),
                            TextFormField(
                              enabled: true,
                              controller: mobileExtensionController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ExpansionPanelRadio(
                    value: 3,
                    headerBuilder: (context, isExpanded) {
                      return ListTile(
                        leading: Image.asset(
                            "${AppIcons.membershipIconsBasePath}country_details_section.png"),
                        title: Text(
                          'Country Details'.tr,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                    body: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RequiredTextWidget(title: "County".tr),
                            TextField(
                              enabled: true,
                              controller: countryNameController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 10),
                            RequiredTextWidget(title: "Country Short Name".tr),
                            TextFormField(
                              enabled: false,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              initialValue: widget.memberProfileModel
                                  ?.memberProfile?.address?.countryShortName,
                            ),
                            const SizedBox(height: 10),
                            RequiredTextWidget(title: "State".tr),
                            TextFormField(
                              enabled: false,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              initialValue: widget.memberProfileModel
                                  ?.memberProfile?.address?.stateName,
                            ),
                            const SizedBox(height: 10),
                            RequiredTextWidget(title: "City".tr),
                            TextFormField(
                              enabled: false,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              initialValue: widget.memberProfileModel
                                  ?.memberProfile?.address?.cityName,
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ExpansionPanelRadio(
                    value: 4,
                    headerBuilder: (context, isExpanded) {
                      return ListTile(
                        leading: Image.asset(
                            "${AppIcons.membershipIconsBasePath}country_zip_and_mobile_section.png"),
                        title: Text(
                          'Country Zip, & Mobile'.tr,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                    body: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RequiredTextWidget(title: "Zip".tr),
                            TextFormField(
                              enabled: false,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              initialValue: widget.memberProfileModel
                                  ?.memberProfile?.address?.zip,
                            ),
                            const SizedBox(height: 10),
                            RequiredTextWidget(title: "Address Line 1".tr),
                            TextFormField(
                              enabled: true,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              initialValue: widget
                                  .memberProfileModel?.memberProfile?.address1,
                            ),
                            const SizedBox(height: 10),
                            RequiredTextWidget(title: "Other Mobile Number".tr),
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      prefixIcon: IconButton(
                                        onPressed: () {
                                          showCountryPicker(
                                              context: context,
                                              onSelect: (Country country) {
                                                otherMobileController.text =
                                                    "+${country.phoneCode}";
                                              });
                                        },
                                        icon: Icon(
                                          Icons.flag_sharp,
                                          size: 40,
                                          color: Colors.green[900],
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    controller: otherMobileController,
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please enter mobile number".tr;
                                      }
                                      if (value.length < 13 ||
                                          value.length > 13) {
                                        return "Please enter valid mobile number"
                                            .tr;
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ExpansionPanelRadio(
                    value: 5,
                    headerBuilder: (context, isExpanded) {
                      return ListTile(
                        leading: Image.asset(
                            "${AppIcons.membershipIconsBasePath}other_details_section.png"),
                        title: Text(
                          'Other Details'.tr,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                    body: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RequiredTextWidget(
                                title: "Other Landline Number".tr),
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      prefixIcon: IconButton(
                                        onPressed: () {
                                          showCountryPicker(
                                              context: context,
                                              onSelect: (Country country) {
                                                otherLandlineController.text =
                                                    "+${country.phoneCode}";
                                              });
                                        },
                                        icon: Icon(
                                          Icons.flag_sharp,
                                          size: 40,
                                          color: Colors.green[900],
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    controller: otherLandlineController,
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please enter mobile number".tr;
                                      }
                                      if (value.length < 13 ||
                                          value.length > 13) {
                                        return "Please enter valid mobile number"
                                            .tr;
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            RequiredTextWidget(title: "District".tr),
                            TextFormField(
                              controller: districtController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 10),
                            RequiredTextWidget(title: "Website".tr),
                            CustomTextField(
                              hintText: "Website".tr,
                              controller: websiteController,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  ExpansionPanelRadio(
                    value: 6,
                    headerBuilder: (context, isExpanded) {
                      return ListTile(
                        leading: Image.asset(
                            "${AppIcons.membershipIconsBasePath}building_and_unit_section.png"),
                        title: Text(
                          'Building & Unit'.tr,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                    body: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RequiredTextWidget(title: "Building Number".tr),
                            CustomTextField(
                              hintText: "Building Number".tr,
                              controller: buildingNoController,
                            ),
                            const SizedBox(height: 10),
                            RequiredTextWidget(title: "Unit Number".tr),
                            CustomTextField(
                              hintText: "Unit Number".tr,
                              controller: unitNoController,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ExpansionPanelRadio(
                    value: 7,
                    headerBuilder: (context, isExpanded) {
                      return ListTile(
                        leading: Image.asset(
                            "${AppIcons.membershipIconsBasePath}qrcode_section.png"),
                        title: Text(
                          'QR Code'.tr,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                    body: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RequiredTextWidget(title: "QR-Code Number".tr),
                            CustomTextField(
                              hintText: "QR-Code Number".tr,
                              controller: qrCodeNoController,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ExpansionPanelRadio(
                    value: 8,
                    headerBuilder: (context, isExpanded) {
                      return ListTile(
                        leading: Image.asset(
                            "${AppIcons.membershipIconsBasePath}company_id_section.png"),
                        title: Text(
                          'Company ID'.tr,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                    body: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RequiredTextWidget(title: "Company ID".tr),
                            CustomTextField(
                              hintText: "Company ID".tr,
                              controller: companyIdController,
                              readOnly: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ExpansionPanelRadio(
                    value: 9,
                    headerBuilder: (context, isExpanded) {
                      return ListTile(
                        leading: Image.asset(
                            "${AppIcons.membershipIconsBasePath}company_id_section.png"),
                        title: Text(
                          'CR Number and Activities'.tr,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                    body: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RequiredTextWidget(title: "CR Number".tr),
                            CustomTextField(
                              hintText: "CR Number".tr,
                              controller: crNumberController,
                              readOnly: false,
                            ),
                            const SizedBox(height: 10),
                            PrimaryButtonWidget(
                              onPressed: () async {
                                // call api to validate cr number
                                if (crNumberController.text.trim().isEmpty) {
                                  Common.showToast("Please enter CR Number".tr);
                                  return;
                                }
                                AppDialogs.loadingDialog(context);
                                isValidate =
                                    await ValidateCrServices.validateCr(
                                        crNumberController.text);
                                if (isValidate) {
                                  AppDialogs.closeDialog();
                                  Common.showToast(
                                      "CR Number is valided, you can now update"
                                          .tr,
                                      backgroundColor: Colors.green);
                                } else {
                                  AppDialogs.closeDialog();
                                  Common.showToast(
                                      "CR Number is not valid, please enter valid CR Number"
                                          .tr,
                                      backgroundColor: Colors.red);
                                }
                              },
                              caption: "Validate CR Number".tr,
                            ).box.make().wFull(context),
                            const SizedBox(height: 10),
                            RequiredTextWidget(title: "Activities".tr),
                            CustomTextField(
                              hintText: "Activities".tr,
                              controller: activitiesController,
                              readOnly: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Card(
                elevation: 3,
                child: ListTile(
                  onTap: () {
                    // close the application
                    FlutterExitApp.exitApp();
                  },
                  leading: Image.asset(
                    "${AppIcons.membershipIconsBasePath}logout_section.png",
                  ),
                  title: Text(
                    "Log out".tr,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 100,
                ),
                child: Column(
                  children: [
                    Text(
                      'Address Photo'.tr,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    addressImageFile?.path != null
                        ? Image.file(addressImageFile!)
                        : Image.network(
                            addImg ?? "",
                            height: 80,
                            width: 80,

                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                              Icons.image_outlined,
                              size: 80,
                            ),
                            cacheHeight: 80,
                            cacheWidth: 80,
                            // loadingBuilder: (context, child, loadingProgress) =>
                            //     LoadingAnimationWidget.prograssiveDots(
                            //   color: Colors.pink,
                            //   size: 30,
                            // ),
                          ),
                    TextButton(
                      onPressed: () async {
                        await ImagePicker()
                            .pickImage(source: ImageSource.gallery)
                            .then((value) {
                          if (value == null) return;
                          setState(() {
                            addressImageFile = File(value.path);
                            addressImageFileName = value.path.split('/').last;
                          });
                        });
                      },
                      child: Text(
                        'Upload'.tr,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            if (isValidate) {
              AppDialogs.loadingDialog(context);
              await update(context);
              AppDialogs.closeDialog();
            } else {
              Common.showToast("Please validate CR Number".tr);
            }
          },
          label: Text('Update'.tr),
          icon: const Icon(Icons.update),
        ),
      ),
    );
  }

  update(BuildContext context) async {
    if (imageFile == null && addressImageFile == null) {
      Common.showToast('Please select image'.tr);
      return;
    }
    AppDialogs.loadingDialog(context);
    try {
      final int status = await MemberProfileServices.updateProfile(
        userId: widget.userId,
        image: imageFile,
        addressImage: addressImageFile,
        additionalNo: otherMobileController.text,
        address1: addressLine1Controller.text,
        address: addressLine2Controller.text,
        buildingNo: widget.memberProfileModel?.memberProfile?.buildingNo,
        companyNameEng:
            widget.memberProfileModel?.memberProfile?.companyNameEng,
        companyNameAr:
            widget.memberProfileModel?.memberProfile?.companyNameArabic,
        mobile: widget.memberProfileModel?.memberProfile?.mobile,
        mobileExtension: mobileExtensionController.text,
        countryName: countryNameController.text,
        cityName: widget.memberProfileModel?.memberProfile?.address?.cityName,
        countryShortName:
            widget.memberProfileModel?.memberProfile?.address?.countryShortName,
        stateName: widget.memberProfileModel?.memberProfile?.address?.stateName,
        zip: widget.memberProfileModel?.memberProfile?.address?.zip,
        otherLandline: otherLandlineController.text,
        district: districtController.text,
        website: websiteController.text,
        companyId: companyIdController.text,
        numberOfStaff: noOfStaffController.text,
        qrCode: qrCodeNoController.text,
        unitNo: unitNoController.text,
      );

      AppDialogs.closeDialog();
      if (status == 200) {
        Common.showToast(
          'Successfully Updated Profile'.tr,
          backgroundColor: Colors.purple,
        );
      } else {
        Common.showToast(
          'Failed to Update Profile'.tr,
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      AppDialogs.closeDialog();
      Common.showToast(
        'Failed to Update Profile'.tr,
        backgroundColor: Colors.red,
      );
    }
  }
}

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({
    super.key,
    required this.memberProfileModel,
  });

  final MemberProfileModel? memberProfileModel;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          bottom: TabBar(
            tabs: [
              Text(
                "Company Information".tr,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "Company Activities".tr,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    ImageWidget(
                      context,
                      imageUrl: "assets/images/company_information_image.png",
                    ),
                    const SizedBox(height: 10),
                    const Divider(thickness: 2, color: Colors.grey),
                    Row(
                      children: [
                        PrimaryTextWidget(text: "CR Number".tr + ": "),
                        PrimaryTextWidget(
                          text: memberProfileModel?.memberDetails?.crNumber ??
                              "null",
                          fontWeight: FontWeight.normal,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(thickness: 2, color: Colors.grey),
                    Row(
                      children: [
                        PrimaryTextWidget(text: "CR Document".tr + ": "),
                        PrimaryTextWidget(
                          text: memberProfileModel
                                  ?.memberDetails?.documentNumber ??
                              "null",
                          fontWeight: FontWeight.normal,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(thickness: 2, color: Colors.grey),
                    PrimaryTextWidget(text: "Company Name [Eng]".tr + ":"),
                    PrimaryTextWidget(
                      text: memberProfileModel?.memberProfile?.companyNameEng ??
                          "null",
                      fontWeight: FontWeight.normal,
                    ),
                    const SizedBox(height: 10),
                    const Divider(thickness: 2, color: Colors.grey),
                    Row(
                      children: [
                        PrimaryTextWidget(text: "Company GCP".tr + ": "),
                        PrimaryTextWidget(
                          text: memberProfileModel?.memberDetails?.companyGcp ??
                              "null",
                          fontWeight: FontWeight.normal,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(thickness: 2, color: Colors.grey),
                    Row(
                      children: [
                        PrimaryTextWidget(text: "Mobile".tr + ": "),
                        PrimaryTextWidget(
                          text: memberProfileModel?.memberProfile?.mobile ??
                              "null",
                          fontWeight: FontWeight.normal,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(thickness: 2, color: Colors.grey),
                    PrimaryTextWidget(text: "Membership Type".tr + ": "),
                    PrimaryTextWidget(
                      text: memberProfileModel?.memberDetails?.memberCategory ??
                          "null",
                      fontWeight: FontWeight.normal,
                    ),
                    const SizedBox(height: 10),
                    const Divider(thickness: 2, color: Colors.grey),
                    PrimaryTextWidget(text: "Products".tr + ": "),
                    Column(
                      children: [
                        FittedBox(
                          child: Row(
                            children: memberProfileModel
                                    ?.memberDetails?.products
                                    ?.map((e) => FittedBox(
                                          child: Container(
                                            margin: const EdgeInsets.all(5),
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              e,
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ))
                                    .toList() ??
                                [],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    ImageWidget(
                      context,
                      imageUrl: "assets/images/company_activity_image.png",
                    ),
                    const SizedBox(height: 10),
                    const Divider(thickness: 2, color: Colors.grey),
                    PrimaryTextWidget(text: "CR Activity".tr + ": "),
                    PrimaryTextWidget(
                      text: memberProfileModel?.memberDetails?.crActivity ??
                          "null",
                      fontWeight: FontWeight.normal,
                    ),
                    const SizedBox(height: 10),
                    const Divider(thickness: 2, color: Colors.grey),
                    PrimaryTextWidget(text: "CR Document Number".tr + ": "),
                    PrimaryTextWidget(
                      text: memberProfileModel?.memberDetails?.crDocument ??
                          "null",
                      fontWeight: FontWeight.normal,
                    ),
                    const SizedBox(height: 10),
                    const Divider(thickness: 2, color: Colors.grey),
                    PrimaryTextWidget(text: "Company Name [Arabic]".tr + ": "),
                    PrimaryTextWidget(
                      text: memberProfileModel
                              ?.memberProfile?.companyNameArabic ??
                          "null",
                      fontWeight: FontWeight.normal,
                    ),
                    const SizedBox(height: 10),
                    const Divider(thickness: 2, color: Colors.grey),
                    PrimaryTextWidget(text: "Contact Person".tr + ": "),
                    PrimaryTextWidget(
                      text: memberProfileModel?.memberDetails?.contactPerson ??
                          "null",
                      fontWeight: FontWeight.normal,
                    ),
                    const SizedBox(height: 10),
                    const Divider(thickness: 2, color: Colors.grey),
                    PrimaryTextWidget(text: "Company Landline".tr + ": "),
                    PrimaryTextWidget(
                      text:
                          memberProfileModel?.memberDetails?.companyLandLine ??
                              "null",
                      fontWeight: FontWeight.normal,
                    ),
                    const SizedBox(height: 10),
                    const Divider(thickness: 2, color: Colors.grey),
                    PrimaryTextWidget(text: "GCP".tr + ": "),
                    PrimaryTextWidget(
                      text: memberProfileModel?.memberDetails?.gpc ?? "null",
                      fontWeight: FontWeight.normal,
                    ),
                    const SizedBox(height: 10),
                    const Divider(thickness: 2, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TwoTextWidget extends StatelessWidget {
  const TwoTextWidget({
    super.key,
    this.title,
    this.subTitle,
  });

  final String? title;
  final String? subTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title ?? "null",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          subTitle ?? 'null',
        ),
        const SizedBox(height: 15),
        const Divider(thickness: 1),
      ],
    );
  }
}
