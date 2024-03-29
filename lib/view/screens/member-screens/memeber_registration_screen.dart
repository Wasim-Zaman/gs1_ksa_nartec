// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, library_private_types_in_public_api

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gs1_v2_project/constants/colors/app_colors.dart';
import 'package:gs1_v2_project/models/member-registration/activities_model.dart';
import 'package:gs1_v2_project/models/member-registration/get_all_countries.dart';
import 'package:gs1_v2_project/models/member-registration/get_all_cr_model.dart';
import 'package:gs1_v2_project/models/member-registration/get_all_states_model.dart';
import 'package:gs1_v2_project/models/member-registration/get_products_by_category_model.dart';
import 'package:gs1_v2_project/res/common/common.dart';
import 'package:gs1_v2_project/utils/app_dialogs.dart';
import 'package:gs1_v2_project/utils/app_url_launcher.dart';
import 'package:gs1_v2_project/utils/url.dart';
import 'package:gs1_v2_project/view-model/member-registration/cr_activity_services.dart';
import 'package:gs1_v2_project/view-model/member-registration/get_all_countries_services.dart';
import 'package:gs1_v2_project/view-model/member-registration/get_products_by_category_services.dart';
import 'package:gs1_v2_project/view/screens/home/home_screen.dart';
import 'package:gs1_v2_project/view/screens/member-screens/get_barcode_screen.dart';
import 'package:gs1_v2_project/widgets/dropdown_widget.dart';
import 'package:gs1_v2_project/widgets/required_text_widget.dart';
import 'package:gs1_v2_project/widgets/text/title_text_widget.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:velocity_x/velocity_x.dart';

bool isFirstClicked = true;
bool isSecondClicked = false;
bool isThirdClicked = false;
bool isFourthClicked = false;

// submit loading
bool isSubmit = false;

enum PaymentGateway { bank, mada }

class MemberRegistrationScreen extends StatefulWidget {
  // final String document;
  // final String crNumber;
  // final bool hasCrNumber;
  const MemberRegistrationScreen({
    super.key,
    // required this.document,
    // required this.crNumber,
    // required this.hasCrNumber,
  });
  static const routeName = "/member-registration";

  @override
  State<MemberRegistrationScreen> createState() =>
      _MemberRegistrationScreenState();
}

class _MemberRegistrationScreenState extends State<MemberRegistrationScreen> {
  // controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController companyNameEnController = TextEditingController();
  TextEditingController companyNameArController = TextEditingController();
  TextEditingController contactPersonController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController searchGpcController = TextEditingController();
  TextEditingController addedGpcController = TextEditingController();
  TextEditingController landLineController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController extensionController = TextEditingController();
  TextEditingController documentNoContoller = TextEditingController();
  TextEditingController crNumberController = TextEditingController();
  TextEditingController crActivitiesController = TextEditingController();

  // global key for the form
  GlobalKey formKey = GlobalKey<FormState>();

  String? activityId;

  bool isChecked = false;

  // for drop down lists
  String? activityValue;
  String? countryName = 'Saudi Arabia'.tr;
  String? countryShortName;
  int countryId = 0;
  String? stateName;
  int? stateId;
  String? cityName;
  int? cityId;
  String? memberCategoryValue;
  num? memberCategoryId;
  String? quotation;
  String? allowOtherProducts;
  String? memberCategory;
  int? memberRegistrationFee;
  int? gtinYearlySubscriptionFee;
  String? otherProductsValue;
  String? gcpType;
  Set<String> otherProductsId = {};
  Set<num> otherProductsYearlyFee = {};
  Set<String> addedProducts = {};

  // for files
  File? pdfFile;
  String? pdfFileName;

  File? imageFile;
  String? imageFileName;

  // payment methods
  bool isBank = true;
  PaymentGateway paymentValue = PaymentGateway.bank;
  String? bankType = 'bank_transfer'.tr;

  // others
  Set<String> addedGPC = {};

  // for drop down lists
  final Set<String> countries = {};
  final Set<String> states = {};
  final Set<String> cities = {};
  List<String> otherProductsList = [];
  List<String> memberCategoryList = [];
  List<String> gpcList = [];
  Set<String> activities = {};
  List<String> categories = [
    "Non-Medical Category",
    "Medical Category",
    "Tobacco Category",
    "Cosmetics Category",
    "Pharma Category"
  ];

  // models list
  List<GetCountriesModel> countriesList = [];
  List<GetAllStatesModel> statesList = [];
  List<GetAllCrActivitiesModel> activitiesList = [];
  GetProductsByCategoryModel productsByCategoryModel =
      GetProductsByCategoryModel();

  String? selectedCategory;
  String? selectedCategoryValue;

  // arguments
  String? document;
  String? crNumber;
  bool? hasCrNumber;

  // form keys
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey4 = GlobalKey<FormState>();

  @override
  void initState() {
    _formKey1.currentState?.validate();
    _formKey2.currentState?.validate();
    _formKey3.currentState?.validate();
    _formKey4.currentState?.validate();

    // crNumber = widget.crNumber;
    // hasCrNumber = widget.hasCrNumber;
    // document = widget.document;

    // getAllOtherProducts();
    // getAllMemberCategories();
    GetProductsByCategoryServices.getProductsByCategory(
      selectedCategory ?? categories[0],
    ).then((value) {
      productsByCategoryModel = value;
      memberCategoryList.clear();
      otherProductsList.clear();
      for (var element in value.gtinProducts!) {
        memberCategoryList.add(
          element.productName.toString(),
        );
      }
      for (var element in value.otherProducts!) {
        otherProductsList.add(
          element.productName.toString(),
        );
      }
    });
    GetAllCountriesServices.getList().then((countries) {
      countriesList = countries;
      for (var element in countries) {
        this.countries.add(element.nameEn.toString());
      }
      countryId = countriesList
          .firstWhere((element) => element.nameEn == countryName,
              orElse: () => GetCountriesModel(id: null))
          .id!;
    });

    selectedCategory = categories[0];
    Future.delayed(Duration.zero, () {
      websiteController.text = 'https://www.';
      landLineController.text = '+966';
      mobileController.text = '+966';
    });
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    companyNameEnController.dispose();
    companyNameArController.dispose();
    contactPersonController.dispose();
    zipCodeController.dispose();
    websiteController.dispose();
    searchGpcController.dispose();
    addedGpcController.dispose();
    landLineController.dispose();
    mobileController.dispose();
    extensionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 227, 231, 1),
      appBar: AppBar(
        title: Text("Member Registration".tr),
        leading: Container(
            margin: const EdgeInsets.all(10),
            child: Image.asset('assets/images/user_registration.png')),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).primaryColor,
                const Color.fromRGBO(226, 227, 231, 1),
                const Color.fromRGBO(226, 227, 231, 1),
                const Color.fromRGBO(226, 227, 231, 1),
                const Color.fromRGBO(226, 227, 231, 1),
                const Color.fromRGBO(226, 227, 231, 1),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: TabWidget(
                              isNextClicked: isFirstClicked, title: "1".tr)),
                      Expanded(
                          child: TabWidget(
                              isNextClicked: isSecondClicked, title: "2".tr)),
                      Expanded(
                          child: TabWidget(
                              isNextClicked: isThirdClicked, title: "3".tr)),
                      Expanded(
                          child: TabWidget(
                              isNextClicked: isFourthClicked, title: "4".tr)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          if (isFirstClicked)
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Form(
                                  key: _formKey1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      document.isNotEmptyAndNotNull
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                RequiredTextWidget(
                                                    title:
                                                        "Document Number".tr),
                                                const SizedBox(height: 5),
                                                CustomTextField(
                                                  controller:
                                                      documentNoContoller,
                                                  hintText:
                                                      "Document Number".tr,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return "Document Number is required"
                                                          .tr;
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                const SizedBox(height: 10),
                                              ],
                                            )
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // FutureBuilder(
                                                //     future: ActivitiesService
                                                //         .getActivities(
                                                //       crNumber.toString(),
                                                //     ),
                                                //     builder:
                                                //         (context, snapshot) {
                                                //       if (snapshot
                                                //               .connectionState ==
                                                //           ConnectionState
                                                //               .waiting) {
                                                //         return Center(
                                                //           child: SizedBox(
                                                //             height: 40,
                                                //             child:
                                                //                 LinearProgressIndicator(
                                                //               semanticsLabel:
                                                //                   "Loading".tr,
                                                //             ),
                                                //           ),
                                                //         );
                                                //       }
                                                //       if (snapshot.hasError) {
                                                //         return Center(
                                                //           child: Text(
                                                //             "Something went wrong, try again later"
                                                //                 .tr,
                                                //           ),
                                                //         );
                                                //       }
                                                //       final snap = snapshot.data
                                                //           as List<
                                                //               GetAllCrActivitiesModel>;
                                                //       activitiesList = snap;
                                                //       for (var element
                                                //           in activitiesList) {
                                                //         activities.add(element
                                                //             .activity
                                                //             .toString());
                                                //       }
                                                //       // if (activities
                                                //       //     .isNotEmpty) {
                                                //       //   activityValue =
                                                //       //       activities.first;
                                                //       // }
                                                //       return activities.isEmpty
                                                //           ? IconButton(
                                                //               onPressed: () {
                                                //                 setState(() {});
                                                //               },
                                                //               icon: const Icon(
                                                //                   Icons
                                                //                       .refresh))
                                                //           : SizedBox(
                                                //               height: 50,
                                                //               child: FittedBox(
                                                //                 child: DropdownButton(
                                                //                     value: activityValue,
                                                //                     items: activities
                                                //                         .map<DropdownMenuItem<String>>(
                                                //                           (String v) =>
                                                //                               DropdownMenuItem<String>(
                                                //                             value:
                                                //                                 v,
                                                //                             child:
                                                //                                 Column(
                                                //                               children: [
                                                //                                 FittedBox(
                                                //                                   child: Text(
                                                //                                     v,
                                                //                                     softWrap: true,
                                                //                                     style: const TextStyle(
                                                //                                       color: Colors.black,
                                                //                                       // fontSize: 10,
                                                //                                     ),
                                                //                                   ),
                                                //                                 ),
                                                //                               ],
                                                //                             ),
                                                //                           ),
                                                //                         )
                                                //                         .toList(),
                                                //                     onChanged: (String? newValue) {
                                                //                       setState(
                                                //                           () {
                                                //                         activityValue =
                                                //                             newValue;
                                                //                         activityId =
                                                //                             snap.firstWhere((element) {
                                                //                           return element.activity ==
                                                //                               newValue;
                                                //                         }).id;
                                                //                       });
                                                //                     }),
                                                //               ),
                                                //             );
                                                //     }),
                                              ],
                                            ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                RequiredTextWidget(
                                                    title: "CR No".tr),
                                                const SizedBox(height: 5),
                                                CustomTextField(
                                                  controller:
                                                      crNumberController,
                                                  hintText: "CR No".tr,
                                                  validator: (p0) {
                                                    if (p0!.isEmpty) {
                                                      return "CR Number is required"
                                                          .tr;
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                RequiredTextWidget(
                                                    title: "CR Activities".tr),
                                                const SizedBox(height: 5),
                                                CustomTextField(
                                                  controller:
                                                      crActivitiesController,
                                                  hintText: "CR Activities".tr,
                                                  validator: (p0) {
                                                    if (p0!.isEmpty) {
                                                      return "CR Activities is required"
                                                          .tr;
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      RequiredTextWidget(title: 'Email'.tr),
                                      const SizedBox(height: 5),
                                      CustomTextField(
                                        hintText: "Enter Valid Email".tr,
                                        controller: emailController,
                                        validator: (email) {
                                          if (EmailValidator.validate(email!)) {
                                            return null;
                                          } else {
                                            return 'Please enter a valid email'
                                                .tr;
                                          }
                                        },
                                      ),
                                      const SizedBox(height: 20),
                                      RequiredTextWidget(
                                          title: 'Company Name English'.tr),
                                      const SizedBox(height: 5),
                                      CustomTextField(
                                        hintText: "Company Name English".tr,
                                        controller: companyNameEnController,
                                        keyboardType: TextInputType.text,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Company Name is required'
                                                .tr;
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 20),
                                      RequiredTextWidget(
                                          title: 'Company Name Arabic'.tr),
                                      const SizedBox(height: 5),
                                      CustomTextField(
                                        hintText: "Company Name Arabic".tr,
                                        controller: companyNameArController,
                                        keyboardType: TextInputType.text,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Company Name is required'
                                                .tr;
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 20),
                                      TitleTextWidget(
                                          text: 'Contact Person'.tr),
                                      const SizedBox(height: 5),
                                      CustomTextField(
                                        hintText: "Contact Person".tr,
                                        controller: contactPersonController,
                                        keyboardType: TextInputType.text,
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                                NextPrevButtons(
                                  onNextClicked: () => setState(() {
                                    if (_formKey1.currentState!.validate()) {
                                      isFirstClicked = false;
                                      isSecondClicked = true;
                                    } else if (activitiesList.isEmpty) {
                                      Fluttertoast.showToast(
                                          msg: "Please enter valid CR Number"
                                              .tr);
                                    }
                                    // isFirstClicked = false;
                                    // isSecondClicked = true;
                                  }),
                                ),
                              ],
                            )
                          else if (isSecondClicked)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Form(
                                  key: _formKey2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TitleTextWidget(
                                          text: 'Company Landline'.tr),
                                      const SizedBox(height: 5),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          prefixIcon: GestureDetector(
                                            onTap: () {
                                              showCountryPicker(
                                                  context: context,
                                                  onSelect: (Country country) {
                                                    landLineController.text =
                                                        "+${country.phoneCode}";
                                                  });
                                            },
                                            child: Image.asset(
                                              'assets/images/landline.png',
                                            ),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        // hintText: "Company Landline",
                                        controller: landLineController,
                                        keyboardType: TextInputType.number,
                                      ),
                                      const SizedBox(height: 20),
                                      RequiredTextWidget(
                                          title: 'Mobile No (Omit Zero)'.tr),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                prefixIcon: GestureDetector(
                                                    onTap: () {
                                                      showCountryPicker(
                                                          context: context,
                                                          onSelect: (Country
                                                              country) {
                                                            mobileController
                                                                    .text =
                                                                "+${country.phoneCode}";
                                                          });
                                                    },
                                                    child: Image.asset(
                                                        'assets/images/mobile.png')),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              controller: mobileController,
                                              keyboardType:
                                                  TextInputType.number,
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "Please enter mobile number"
                                                      .tr;
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
                                      const SizedBox(height: 20),
                                      TitleTextWidget(text: 'Extension'.tr),
                                      const SizedBox(height: 5),
                                      CustomTextField(
                                        hintText: "Extension".tr,
                                        controller: extensionController,
                                      ),
                                      const SizedBox(height: 20),
                                      RequiredTextWidget(title: "Zip Code".tr),
                                      const SizedBox(height: 5),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          prefixIcon: Image.asset(
                                            'assets/images/zip.png',
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        // hintText: "Company Landline",
                                        controller: zipCodeController,
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Kindly provide zip code".tr;
                                          }

                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 20),
                                      const RequiredTextWidget(
                                          title: "https://www."),
                                      const SizedBox(height: 5),
                                      TextFormField(
                                        controller: websiteController,
                                        keyboardType: TextInputType.url,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Kindly provide website".tr;
                                          }
                                          if (!value.contains('https://')) {
                                            return "Kindly provide valid website"
                                                .tr;
                                          }

                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          prefixIcon: Image.asset(
                                            'assets/images/web.png',
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          errorStyle: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                NextPrevButtons(
                                  prevWidget: PreviousButtonWidget(
                                    onPressed: () => setState(() {
                                      isFirstClicked = true;
                                      isSecondClicked = false;
                                    }),
                                  ),
                                  onNextClicked: () => setState(() {
                                    if (_formKey2.currentState!.validate()) {
                                      isSecondClicked = false;
                                      isThirdClicked = true;
                                    }
                                    // isSecondClicked = false;
                                    // isThirdClicked = true;
                                  }),
                                ),
                              ],
                            )
                          else if (isThirdClicked)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // RequiredTextWidget(title: "Search GPC".tr),
                                    // const SizedBox(height: 5),
                                    // Row(
                                    //   children: [
                                    //     Expanded(
                                    //       flex: 4,
                                    //       child: Container(
                                    //         decoration: BoxDecoration(
                                    //           borderRadius:
                                    //               BorderRadius.circular(10),
                                    //           border: Border.all(
                                    //             color: Colors.grey,
                                    //           ),
                                    //         ),
                                    //         child: Autocomplete<String>(
                                    //           displayStringForOption:
                                    //               (option) => option,
                                    //           optionsBuilder:
                                    //               (textEditingValue) {
                                    //             if (textEditingValue.text ==
                                    //                 '') {
                                    //               return const Iterable<
                                    //                   String>.empty();
                                    //             }
                                    //             return gpcList
                                    //                 .where((String option) {
                                    //               return option.contains(
                                    //                   textEditingValue.text);
                                    //             });
                                    //           },
                                    //           onSelected: (String selection) {
                                    //             // _addedGpcController.text = selection;
                                    //             setState(() {
                                    //               addedGPC.add(selection);
                                    //             });
                                    //           },
                                    //         ),
                                    //       ),
                                    //     ),
                                    //     Expanded(
                                    //       child: GestureDetector(
                                    //         onTap: () async {
                                    //           AppDialogs.loadingDialog(context);
                                    //           final temp = GpcService.getGPC(
                                    //               searchGpcController.text);
                                    //           temp.then((value) {
                                    //             AppDialogs.closeDialog();
                                    //             gpcList.clear();
                                    //             searchGpcController.clear();

                                    //             for (var element in value) {
                                    //               gpcList.add(element.value!);
                                    //             }
                                    //           }).catchError((error) {
                                    //             AppDialogs.closeDialog();
                                    //             Fluttertoast.showToast(
                                    //                 msg: error.toString());
                                    //           });
                                    //         },
                                    //         child: Image.asset(
                                    //             'assets/images/search.png'),
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),

                                    // const SizedBox(height: 20),
                                    // RequiredTextWidget(title: "Added GPC".tr),
                                    // const SizedBox(height: 5),
                                    // Column(
                                    //     children: addedGPC
                                    //         .map((e) => ListTile(
                                    //               title: Text(e),
                                    //               trailing: IconButton(
                                    //                 onPressed: () {
                                    //                   setState(() {
                                    //                     addedGPC.remove(e);
                                    //                   });
                                    //                 },
                                    //                 icon: const Icon(
                                    //                   Icons.delete,
                                    //                   color: Colors.red,
                                    //                 ),
                                    //               ),
                                    //             ))
                                    //         .toList()),
                                    // const SizedBox(height: 20),
                                    // const Divider(thickness: 3),
                                    // RequiredTextWidget(
                                    //   title: "Select Country".tr,
                                    // ),
                                    // FutureBuilder(
                                    //     future:
                                    //         GetAllCountriesServices.getList(),
                                    //     builder: (context, snapshot) {
                                    //       if (snapshot.connectionState ==
                                    //           ConnectionState.waiting) {
                                    //         return const Center(
                                    //           child: SizedBox(
                                    //             height: 40,
                                    //             child:
                                    //                 LinearProgressIndicator(),
                                    //           ),
                                    //         );
                                    //       }
                                    //       if (snapshot.hasError) {
                                    //         return Center(
                                    //           child: Text(
                                    //               "Something went wrong, please try again later"
                                    //                   .tr),
                                    //         );
                                    //       }
                                    //       final snap = snapshot.data
                                    //           as List<GetCountriesModel>;
                                    //       countriesList = snap;
                                    //       countries.clear();
                                    //       for (var element in snap) {
                                    //         countries
                                    //             .add(element.nameEn.toString());
                                    //       }

                                    //       return SizedBox(
                                    //         height: 40,
                                    //         width: double.infinity,
                                    //         child: DropdownButton(
                                    //             value: countryName,
                                    //             isExpanded: true,
                                    //             items: countries
                                    //                 .map<
                                    //                     DropdownMenuItem<
                                    //                         String>>(
                                    //                   (String v) =>
                                    //                       DropdownMenuItem<
                                    //                           String>(
                                    //                     value: v,
                                    //                     child: AutoSizeText(v),
                                    //                   ),
                                    //                 )
                                    //                 .toList(),
                                    //             onChanged: (String? newValue) {
                                    //               setState(() {
                                    //                 countryName = newValue!;
                                    //                 stateName = null;
                                    //                 cityName = null;
                                    //                 cities.clear();
                                    //                 states.clear();
                                    //                 countryId = (snap
                                    //                     .firstWhere(
                                    //                         (element) =>
                                    //                             element
                                    //                                 .nameEn ==
                                    //                             countryName,
                                    //                         orElse: () =>
                                    //                             GetCountriesModel(
                                    //                                 id: null))
                                    //                     .id!);
                                    //               });
                                    //             }),
                                    //       );
                                    //     }),
                                    // const SizedBox(height: 20),
                                    // RequiredTextWidget(
                                    //     title: "Select State".tr),

                                    // FutureBuilder(
                                    //     future: GetAllStatesServices.getList(
                                    //         countryId),
                                    //     builder: (context, snapshot) {
                                    //       if (snapshot.connectionState ==
                                    //           ConnectionState.waiting) {
                                    //         return const Center(
                                    //           child: SizedBox(
                                    //               height: 40,
                                    //               child:
                                    //                   LinearProgressIndicator()),
                                    //         );
                                    //       }
                                    //       if (snapshot.hasError) {
                                    //         return Center(
                                    //           child: Column(
                                    //             children: [
                                    //               Text("Something went wrong"
                                    //                   .tr),
                                    //               TextButton(
                                    //                 onPressed: () {
                                    //                   setState(() {});
                                    //                 },
                                    //                 child: Text("Refresh".tr),
                                    //               ),
                                    //             ],
                                    //           ),
                                    //         );
                                    //       }
                                    //       final snap = snapshot.data
                                    //           as List<GetAllStatesModel>;
                                    //       statesList = snap;
                                    //       states.clear();

                                    //       for (var element in snap) {
                                    //         states.add(element.name.toString());
                                    //       }
                                    //       return SizedBox(
                                    //         width: double.infinity,
                                    //         height: 40,
                                    //         child: DropdownButton(
                                    //             value: stateName,
                                    //             isExpanded: true,
                                    //             items: states
                                    //                 .map<
                                    //                     DropdownMenuItem<
                                    //                         String>>(
                                    //                   (String v) =>
                                    //                       DropdownMenuItem<
                                    //                           String>(
                                    //                     value: v,
                                    //                     child: Text(v),
                                    //                   ),
                                    //                 )
                                    //                 .toList(),
                                    //             onChanged: (String? newValue) {
                                    //               setState(() {
                                    //                 stateName = newValue!;
                                    //                 cityName = null;
                                    //                 cities.clear();
                                    //                 stateId = (snap
                                    //                     .firstWhere(
                                    //                         (element) =>
                                    //                             element.name ==
                                    //                             stateName,
                                    //                         orElse: () =>
                                    //                             GetAllStatesModel(
                                    //                                 id: null))
                                    //                     .id!);
                                    //               });
                                    //             }),
                                    //       );
                                    //     }),
                                    // const SizedBox(height: 20),
                                    // RequiredTextWidget(title: "Select City".tr),
                                    // FutureBuilder(
                                    //     future: GetAllCitiesServices.getData(
                                    //         stateId ?? 0),
                                    //     builder: (context, snapshot) {
                                    //       if (snapshot.connectionState ==
                                    //           ConnectionState.waiting) {
                                    //         return const Center(
                                    //           child: SizedBox(
                                    //             height: 40,
                                    //             child:
                                    //                 LinearProgressIndicator(),
                                    //           ),
                                    //         );
                                    //       }
                                    //       if (snapshot.hasError) {
                                    //         return Center(
                                    //           child: Text(
                                    //               "Something went wrong, please try again later"
                                    //                   .tr),
                                    //         );
                                    //       }
                                    //       final snap = snapshot.data
                                    //           as List<GetAllCitiesModel>;

                                    //       states.clear();

                                    //       for (var element in snap) {
                                    //         // print(element.stateId);
                                    //         cities.add(element.name.toString());
                                    //       }
                                    //       return SizedBox(
                                    //         width: double.infinity,
                                    //         child: DropdownButton(
                                    //             value: cityName,
                                    //             isExpanded: true,
                                    //             items: cities
                                    //                 .map<
                                    //                     DropdownMenuItem<
                                    //                         String>>(
                                    //                   (String v) =>
                                    //                       DropdownMenuItem<
                                    //                           String>(
                                    //                     value: v,
                                    //                     child: Text(v),
                                    //                   ),
                                    //                 )
                                    //                 .toList(),
                                    //             onChanged: (String? newValue) {
                                    //               setState(() {
                                    //                 cityName = newValue!;
                                    //                 cityId = (snap
                                    //                     .firstWhere(
                                    //                         (element) =>
                                    //                             element.name ==
                                    //                             cityName,
                                    //                         orElse: () =>
                                    //                             GetAllCitiesModel(
                                    //                                 id: null))
                                    //                     .id);
                                    //               });
                                    //             }),
                                    //       );
                                    //     }),
                                    // const SizedBox(height: 20),
                                    RequiredTextWidget(
                                        title: "Select Category".tr),
                                    5.heightBox,
                                    DropdownWidget(
                                      list: categories,
                                      value: selectedCategory.toString(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedCategory = value;
                                          if (selectedCategory ==
                                              "Non-Medical Category") {
                                            selectedCategoryValue =
                                                "non_med_category";
                                          } else {
                                            selectedCategoryValue =
                                                "med_category";
                                          }
                                          GetProductsByCategoryServices
                                              .getProductsByCategory(
                                            selectedCategory.toString(),
                                          ).then((value) {
                                            memberCategoryList.clear();
                                            otherProductsList.clear();
                                            for (var element
                                                in value.gtinProducts!) {
                                              memberCategoryList.add(
                                                element.productName.toString(),
                                              );
                                            }
                                            for (var element
                                                in value.otherProducts!) {
                                              otherProductsList.add(
                                                element.productName.toString(),
                                              );
                                            }
                                          });
                                        });
                                      },
                                    ).box.make().wFull(context),
                                    const SizedBox(height: 20),
                                    RequiredTextWidget(title: "GTIN".tr),

                                    DropdownWidget(
                                      value: memberCategory ??
                                          memberCategoryList[0],
                                      list: memberCategoryList,
                                      onChanged: (value) {
                                        setState(() {
                                          memberCategory = value;
                                          memberCategoryId =
                                              productsByCategoryModel
                                                  .gtinProducts!
                                                  .firstWhere((element) =>
                                                      element.productName ==
                                                      value)
                                                  .productID;
                                        });
                                      },
                                    ).box.make().wFull(context),
                                    const SizedBox(height: 20),

                                    // const SizedBox(height: 20),
                                  ],
                                ),
                                NextPrevButtons(
                                  prevWidget: PreviousButtonWidget(
                                    onPressed: () => setState(() {
                                      isSecondClicked = true;
                                      isThirdClicked = false;
                                    }),
                                  ),
                                  onNextClicked: () => setState(() {
                                    isThirdClicked = false;
                                    isFourthClicked = true;
                                  }),
                                ),
                              ],
                            )
                          else if (isFourthClicked)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    allowOtherProducts == 'no'
                                        ? const SizedBox.shrink()
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              RequiredTextWidget(
                                                title: "Other Products".tr,
                                              ),
                                              addedProducts.isNotEmpty
                                                  ? ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          addedProducts.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Card(
                                                          child: ListTile(
                                                            trailing:
                                                                IconButton(
                                                                    onPressed: () =>
                                                                        setState(
                                                                            () {
                                                                          addedProducts
                                                                              .remove(
                                                                            addedProducts.elementAt(index),
                                                                          );
                                                                          otherProductsId
                                                                              .remove(
                                                                            otherProductsId.elementAt(index),
                                                                          );
                                                                        }),
                                                                    icon:
                                                                        const Icon(
                                                                      Icons
                                                                          .delete,
                                                                      color: Colors
                                                                          .red,
                                                                    )),
                                                            title: Text(
                                                              addedProducts
                                                                  .elementAt(
                                                                      index),
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 15,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    )
                                                  : const SizedBox(),
                                              DropdownWidget(
                                                value: otherProductsValue ??
                                                    otherProductsList.first,
                                                list: otherProductsList,
                                                onChanged: (value) {
                                                  setState(() {
                                                    otherProductsValue = value;

                                                    addedProducts.add(
                                                        otherProductsValue!);

                                                    final id = productsByCategoryModel
                                                        .otherProducts!
                                                        .firstWhere((element) =>
                                                            element
                                                                .productName ==
                                                            value)
                                                        .otherProdID;

                                                    otherProductsId
                                                        .add(id.toString());

                                                    for (var element
                                                        in productsByCategoryModel
                                                            .otherProducts!) {
                                                      if (element.productName ==
                                                          value) {
                                                        var yearly_fee =
                                                            num.tryParse(element
                                                                .yearlyFee!);

                                                        otherProductsYearlyFee
                                                            .add(yearly_fee!);
                                                      }
                                                    }
                                                  });
                                                },
                                              ).box.make().wFull(context),
                                            ],
                                          ),
                                    const SizedBox(height: 20),
                                    RequiredTextWidget(
                                      title: "Upload Company Documents".tr,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        TextButton.icon(
                                          onPressed: uploadPdf,
                                          icon: Image.asset(
                                            'assets/images/browse_pic.png',
                                            width: 30,
                                            height: 32,
                                            fit: BoxFit.contain,
                                          ),
                                          label: Text('Browse'.tr),
                                        ),
                                        pdfFileName != null
                                            ? Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      width: 200,
                                                      child: Text(
                                                        pdfFileName
                                                                    .toString()
                                                                    .length >
                                                                15
                                                            ? "${pdfFileName!.substring(0, 15)}....${pdfFileName!.substring(
                                                                pdfFileName!
                                                                        .length -
                                                                    4,
                                                                pdfFileName!
                                                                    .length,
                                                              )}"
                                                            : pdfFileName!,
                                                        softWrap: true,
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : const Expanded(
                                                flex: 3,
                                                child: SizedBox(),
                                              ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    RequiredTextWidget(
                                      title: "Upload national address (QR Code)"
                                          .tr,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        TextButton.icon(
                                          onPressed: uploadImage,
                                          label: Text('Browse'.tr),
                                          icon: Image.asset(
                                            'assets/images/browse_doc.png',
                                            width: 30,
                                            height: 32,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        imageFileName != null
                                            ? Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      width: 200,
                                                      child: Text(
                                                        imageFileName!.length >
                                                                15
                                                            ? "${imageFileName!.substring(0, 15)}....${imageFileName!.substring(
                                                                imageFileName!
                                                                        .length -
                                                                    4,
                                                                imageFileName!
                                                                    .length,
                                                              )}"
                                                            : imageFileName!,
                                                        softWrap: true,
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : const Expanded(
                                                flex: 3,
                                                child: SizedBox(),
                                              ),
                                      ],
                                    )
                                  ],
                                ),
                                Divider(
                                  thickness: 5,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(height: 20),
                                // payment gateway ui

                                const SubmissionText(),
                                const SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // bank transfer
                                      Column(
                                        children: [
                                          Container(
                                            color: const Color.fromRGBO(
                                                226, 227, 231, 1),
                                            width: 130,
                                            height: 100,
                                            child: Image.asset(
                                              'assets/images/band_transfer.png',
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Radio<PaymentGateway>(
                                                value: PaymentGateway.bank,
                                                groupValue: paymentValue,
                                                onChanged:
                                                    (PaymentGateway? value) {
                                                  setState(() {
                                                    paymentValue = value!;
                                                  });
                                                },
                                              ),
                                              Text('Bank'.tr),
                                            ],
                                          )
                                        ],
                                      ),
                                      // Column(
                                      //   children: [
                                      //     SizedBox(
                                      //       width: 130,
                                      //       height: 100,
                                      //       child: Image.asset(
                                      //         'assets/images/mada.png',
                                      //         fit: BoxFit.fill,
                                      //       ),
                                      //     ),
                                      //     Row(
                                      //       mainAxisAlignment:
                                      //           MainAxisAlignment.start,
                                      //       children: [
                                      //         Radio<PaymentGateway>(
                                      //           value: PaymentGateway.mada,
                                      //           groupValue: paymentValue,
                                      //           onChanged:
                                      //               (PaymentGateway? value) {
                                      //             setState(() {
                                      //               paymentValue = value!;
                                      //               if (paymentValue ==
                                      //                   PaymentGateway.mada) {
                                      //                 bankType =
                                      //                     "visa_transfer";
                                      //               } else {
                                      //                 bankType =
                                      //                     "bank_transfer";
                                      //               }
                                      //             });
                                      //           },
                                      //         ),
                                      //         const Text('Mada'),
                                      //       ],
                                      //     )
                                      //   ],
                                      // ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // create a check box for accepting terms and conditions
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Checkbox(
                                      value: isChecked,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          isChecked = value!;
                                        });
                                      },
                                    ),
                                    Text(
                                      "I accept the Terms and Conditions".tr,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Center(
                                  child: GestureDetector(
                                    onTap: () async {
                                      AppUrlLauncher.launchUrl(Uri.parse(
                                          "https://gs1ksa.org/index.php/TermsAndConditions"));
                                    },
                                    child: Text(
                                      "(Download Terms & Conditions)".tr,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.redColor,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  width: double.infinity,
                                  height: 40,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // do not submit the form if any of the value is empty
                                      if (!isChecked) {
                                        Common.showToast(
                                            "Please accept the terms and conditions"
                                                .tr);
                                      } else if (emailController.text.isEmpty ||
                                          companyNameEnController
                                              .text.isEmpty ||
                                          companyNameArController
                                              .text.isEmpty ||
                                          mobileController.text.isEmpty ||
                                          extensionController.text.isEmpty ||
                                          zipCodeController.text.isEmpty ||
                                          websiteController.text.isEmpty ||
                                          websiteController.text.length <= 9 ||
                                          // countryName == null ||
                                          // stateName == null ||
                                          // cityName == null ||
                                          // memberCategory == null ||
                                          pdfFile == null ||
                                          otherProductsList.isEmpty ||
                                          bankType == null) {
                                        Common.showToast(
                                            "Please fill the required fields"
                                                .tr);
                                      } else if (otherProductsList.length < 1) {
                                        Common.showToast(
                                            "Please select other products".tr);
                                      } else {
                                        addCrActivity();
                                      }
                                    },
                                    child:
                                        // isSubmit
                                        //     ? const Center(
                                        //         child: CircularProgressIndicator(
                                        //         color: Colors.white,
                                        //       ))
                                        //     :
                                        Text('Submit'.tr),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                NextPrevButtons(
                                  nextWidget: const SizedBox.shrink(),
                                  prevWidget: PreviousButtonWidget(
                                    onPressed: () => setState(() {
                                      isThirdClicked = true;
                                      isFourthClicked = false;
                                    }),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  submit({
    bool? termsAndConditions,
    String? allowOtherProducts,
    String? activity,
    String? crNumber,
    String? email,
    String? companyNameEng,
    String? companyNameAr,
    String? contactPerson,
    String? companyLandline,
    String? mobileNumber,
    String? mobileExtension,
    String? zipCode,
    String? website,
    List<String>? gpc, // search gpc
    String? countryId,
    String? countryName,
    String? countryShortName,
    String? stateId,
    String? stateName,
    String? cityId,
    String? cityName,
    String? memberCategory, // id
    List<String>? otherProduct, // member category product
    List<String>? product, // member category product
    List<String>? quotation,
    List<num>? registationFee,
    List<num>? yearlyFee,
    String? gcpType,
    List<String>? productType,
    List<num>? otherPrice,
    List<String>? otherProductId,
    String? paymentType,
    String? selectedCategoryValue,
  }) async {
    setState(() {
      isSubmit = true;
    });
    final gtinPrice = registationFee![0] + yearlyFee![0];
    num totalPrice = 0;
    otherPrice?.forEach((element) {
      totalPrice += element;
    });

    totalPrice += gtinPrice;
    // print('total price $totalPrice');

    yearlyFee = List.generate(otherProduct!.length + 1, (index) {
      if (index == 0) {
        return yearlyFee![0];
      } else {
        return otherProductsYearlyFee.elementAt(index - 1);
      }
    });
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${BaseUrl.gs1}/api/AddMember'),
    );

    request.fields['user_type'] = 'new';
    request.fields['allow_other_products'] = allowOtherProducts.toString();
    request.fields['activity'] = activity.toString();
    request.fields['cr_number'] = '$crNumber';
    request.fields['terms_conditions'] = '$termsAndConditions';

    request.fields['email'] = '$email';
    request.fields['company_name_eng'] = '$companyNameEng';
    request.fields['company_name_arabic'] = '$companyNameAr';
    request.fields['contactPerson'] = '$contactPerson';
    request.fields['companyLandline'] = '$companyLandline';
    request.fields['mobile_no'] = '$mobileNumber';
    request.fields['mbl_extension'] = '$mobileExtension';
    request.fields['zip_code'] = '$zipCode';
    request.fields['website'] = '$website';
    request.fields['gtin_category'] = "$selectedCategoryValue";

    final gpcArray = jsonEncode(gpc);
    request.fields['gpc'] =
        gpcArray.toString().replaceAll('[', '').replaceAll(']', '');

    request.fields['country_id'] = "17"; //'$countryId';
    request.fields['countryName'] = 'Saudi Arabia'; //'$countryName';
    request.fields['country_shortName'] = '$countryShortName';
    request.fields['state_id'] = "28"; // '$stateId';
    request.fields['stateName'] = 'Central Region'; //'$stateName';
    request.fields['city_id'] = "18"; //'$cityId';
    request.fields['cityName'] = 'Riyadh'; // '$cityName';
    request.fields['member_category'] = '$memberCategory';

    final otherProductsArray = jsonEncode(otherProduct);
    request.fields['other_products'] = otherProductsArray;
    // .toString()
    // .replaceFirst('[', '')
    // .replaceFirst(']', '');

    List<String> test = [];
    product?.forEach((element) {
      test.add(element.replaceAll(',', ''));
    });
    final productsArray = jsonEncode(test);
    request.fields['product'] = productsArray;
    // .toString()
    // .replaceFirst('[', '')
    // .replaceFirst(']', '')
    // .replaceAll('"', '');

    final quotationArray = jsonEncode(quotation);
    request.fields['quotation'] = quotationArray;
    // .toString().replaceFirst('[', '').replaceFirst(']', '');

    final registationFeeArray = jsonEncode(registationFee);
    request.fields['registration_fee'] = registationFeeArray;
    // .toString()
    // .replaceFirst('[', '')
    // .replaceFirst(']', '');

    final yearlyFeeArray = jsonEncode(yearlyFee);
    request.fields['yearly_fee'] = yearlyFeeArray;
    // .toString().replaceFirst('[', '').replaceFirst(']', '');

    request.fields['gtinprice'] = gtinPrice.toString();
    request.fields['pkgID'] = memberCategoryId.toString();
    request.fields['gcp_type'] = 'GCP'; //'$gcpType';

    final productTypeArray = jsonEncode(productType);
    request.fields['product_type'] = productTypeArray;
    // .toString().replaceFirst('[', '').replaceFirst(']', '');

    final otherProductsPriceArray = jsonEncode(otherPrice);
    request.fields['otherprice'] = otherProductsPriceArray;
    // .toString()
    // .replaceFirst('[', '')
    // .replaceFirst(']', '');

    final otherProductsIdArray = jsonEncode(otherProductId);
    request.fields['otherProdID'] = otherProductsIdArray;
    // .toString()
    // .replaceFirst('[', '')
    // .replaceFirst(']', '');

    request.fields['total'] = totalPrice.toString();
    request.fields['payment_type'] = paymentType.toString();

    if (imageFile != null) {
      // Add image file to request
      var imageStream = http.ByteStream(imageFile!.openRead());
      var imageLength = await imageFile?.length();
      var imageMultipartFile = http.MultipartFile(
          'address_image', imageStream, imageLength!,
          filename: imageFile?.path);
      request.files.add(imageMultipartFile);
    }

    // Add PDF file to request
    if (pdfFile == null) {
      // then pass null in the document field
    } else {
      var pdfStream = http.ByteStream(pdfFile!.openRead());
      var pdfLength = await pdfFile?.length();
      var pdfMultipartFile = http.MultipartFile(
          'documents', pdfStream, pdfLength!,
          filename: pdfFile?.path);
      request.files.add(pdfMultipartFile);
    }

    // getting response
    try {
      AppDialogs.loadingDialog(context);
      final response = await request.send();

      if (response.statusCode == 200) {
        AppDialogs.closeDialog();

        final responseBody = await response.stream.bytesToString();
        log('response body:---- $responseBody');

        Common.showToast('Registration successful'.tr);
        setState(() {
          isSubmit = false;
        });

        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      } else if (response.statusCode == 400 || response.statusCode == 422) {
        AppDialogs.closeDialog();
        Common.showToast("The current email or activity is already in used");
      } else {
        final responseBody = await response.stream.bytesToString();
        log('response body:---- $responseBody');

        AppDialogs.closeDialog();
        // showSpinner = false;
        Fluttertoast.showToast(
          msg: 'Something went wrong, please try again'.tr,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        setState(() {
          isSubmit = false;
        });
      }
    } catch (error) {
      //
      AppDialogs.closeDialog();
      setState(() {
        isSubmit = false;
      });
    }
  }

  addCrActivity() async {
    try {
      AppDialogs.loadingDialog(context);
      ActivitiesModel model = await CrActivityServices.addActivity(
        cr: crNumberController.text,
        activity: crActivitiesController.text,
        status: 1,
      );
      AppDialogs.closeDialog();
      await Future.delayed(Duration(seconds: 1));
      // when the activity is added successfully, lets register the user now
      submit(
        termsAndConditions: isChecked,
        selectedCategoryValue: selectedCategoryValue,
        gcpType: gcpType,
        memberCategory: memberCategory,
        paymentType: bankType,
        allowOtherProducts: allowOtherProducts,
        activity: model.activity, //activityValue ?? document,
        crNumber: model.cr, //crNumber ?? documentNoContoller.text,
        email: emailController.text,
        companyNameEng: companyNameEnController.text,
        companyNameAr: companyNameArController.text,
        contactPerson: contactPersonController.text,
        companyLandline: landLineController.text,
        mobileNumber: mobileController.text,
        mobileExtension: extensionController.text,
        zipCode: zipCodeController.text,
        website: websiteController.text,
        gpc: addedGPC.toList(),
        countryId: countryId.toString(),
        countryName: countryName,
        countryShortName: countryShortName,
        stateId: stateId.toString(),
        stateName: stateName,
        cityId: cityId.toString(),
        cityName: cityName,
        otherProduct: addedProducts.toList(),
        otherProductId: otherProductsId.toList(),
        quotation: List.generate(
            addedProducts.isEmpty ? 1 : addedProducts.length + 1, (index) {
          if (index == 0) {
            return quotation.toString();
          } else {
            return "no";
          }
        }),
        registationFee: List.generate(
            addedProducts.isEmpty ? 1 : addedProducts.length + 1, (index) {
          if (index == 0) {
            return memberRegistrationFee ?? 0;
          } else {
            return 0;
          }
        }),
        yearlyFee: [gtinYearlySubscriptionFee ?? 0, ...otherProductsYearlyFee],
        otherPrice: otherProductsYearlyFee.toList(),
        product: [
          memberCategoryValue ?? "",
          ...addedProducts.toList(),
        ],
        productType: addedProducts.isEmpty
            ? ['gtin']
            : List.generate(addedProducts.length + 1, (index) {
                if (index == 0) {
                  return "gtin";
                } else {
                  return "other";
                }
              }),
      );
    } catch (err) {
      AppDialogs.closeDialog();
      Common.showToast(err.toString());
      print(err);
    }
  }

  Future uploadPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      pdfFile = File(result.files.single.path ?? "");
      setState(() {
        pdfFileName = pdfFile?.path.split('/').last;
      });
    } else {
      // User canceled the picker
    }
  }

  Future uploadImage() async {
    final imagePicker = ImagePicker();
    // var dio = Dio();
    try {
      // pick image
      final pickedImage = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      // check if image is picked
      if (pickedImage != null) {
        setState(() {
          imageFile = File(pickedImage.path);
          imageFileName = imageFile?.path.split('/').last;
        });
      }
    } catch (error) {
      rethrow;
    }
  }
}

class SubmissionText extends StatelessWidget {
  const SubmissionText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        'Payment Methods'.toUpperCase(),
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 25,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class Screen2 extends StatelessWidget {
  const Screen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class Screen3 extends StatelessWidget {
  const Screen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class TabWidget extends StatelessWidget {
  const TabWidget({
    super.key,
    this.isNextClicked,
    this.title,
  });

  final bool? isNextClicked;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: isNextClicked! ? 25 : 15,
          backgroundColor: isNextClicked!
              ? const Color.fromRGBO(4, 215, 25, 1)
              : Theme.of(context).primaryColor,
          child: Text(
            title!,
            style: TextStyle(
              color: isNextClicked! ? Colors.black : Colors.white,
              fontSize: 20,
            ),
          ),
        ),
        Container(
          height: 20,
          width: 80,
          alignment: Alignment.center,
          color: isNextClicked!
              ? const Color.fromRGBO(4, 215, 25, 1)
              : Theme.of(context).primaryColor,
          child: Text(
            "Step".tr,
            style: TextStyle(
              fontSize: 17,
              color: isNextClicked! ? Colors.black : Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class NextPrevButtons extends StatelessWidget {
  const NextPrevButtons({
    super.key,
    this.onNextClicked,
    this.onPrevClicked,
    this.prevWidget,
    this.nextWidget,
  });
  final VoidCallback? onNextClicked;
  final VoidCallback? onPrevClicked;
  final Widget? prevWidget;
  final Widget? nextWidget;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        prevWidget ?? const SizedBox.shrink(),
        GestureDetector(
          onTap: onNextClicked,
          child: nextWidget ??
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Text(
                      'Next'.tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.keyboard_double_arrow_right,
                      color: Colors.white,
                      size: 28,
                    ),
                  ],
                ),
              ),
        ),
      ],
    );
  }
}

class FileUploaderWidget extends StatefulWidget {
  const FileUploaderWidget({Key? key}) : super(key: key);

  @override
  _FileUploaderWidgetState createState() => _FileUploaderWidgetState();
}

class _FileUploaderWidgetState extends State<FileUploaderWidget> {
  File? selectedFile;

  void _selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: _selectFile,
          child: Text('Select File'.tr),
        ),
        // if (_selectedFile != null) Text(_selectedFile!.path),
        // ElevatedButton(
        //   onPressed: _uploadFile,
        //   child: Text('Upload File'),
        // ),
      ],
    );
  }
}

class PreviousButtonWidget extends StatelessWidget {
  const PreviousButtonWidget({super.key, this.onPressed});
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              Icons.keyboard_double_arrow_left,
              color: Colors.white,
              size: 28,
            ),
            SizedBox(width: 10),
            Text(
              'Prev'.tr,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
