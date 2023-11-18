// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gs1_v2_project/constants/colors/app_colors.dart';
import 'package:gs1_v2_project/constants/images/other_images.dart';
import 'package:gs1_v2_project/models/product_contents_list_model.dart';
import 'package:gs1_v2_project/res/common/common.dart';
import 'package:gs1_v2_project/utils/colors.dart';
import 'package:gs1_v2_project/view-model/base-api/base_api_service.dart';
import 'package:gs1_v2_project/view-model/gtin-reporter/gtin_reporter_services.dart';
import 'package:gs1_v2_project/view/screens/widgets/expansion_row_widget.dart';
import 'package:gs1_v2_project/widgets/custom_image_widget.dart';
import 'package:gs1_v2_project/widgets/qr_code/qr_image.dart';

class GtinReporterScreen extends StatefulWidget {
  static const routeName = "/gtin-reporter";
  const GtinReporterScreen({super.key});

  @override
  State<GtinReporterScreen> createState() => _GtinReporterScreenState();
}

class _GtinReporterScreenState extends State<GtinReporterScreen> {
  String? gtin;
  @override
  void initState() {
    // get gtin from arguments as string
    Future.delayed(Duration(seconds: 1), () {
      gtin = ModalRoute.of(context)?.settings.arguments as String;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            height: 200,
            padding: const EdgeInsets.all(50),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryColor,
                  AppColors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Image.asset(OtherImages.logo),
          ),
          AppBar(
            backgroundColor: orangeColor,
            automaticallyImplyLeading: true,
            title: Text("GTIN Reporter"),
            centerTitle: true,
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Screen(
              gtin: ModalRoute.of(context)?.settings.arguments as String,
            ),
          ),
        ],
      ),
    );
  }
}

class Screen extends StatefulWidget {
  final String gtin;
  const Screen({super.key, required this.gtin});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController reportBarcodeController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  ProductContentsListModel? data;
  String? selectedOption;

  // List of Images
  List<File>? imageList = [];
  List<String>? imageListUrl = [];
  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          tileColor: Colors.greenAccent,
          leading: Image.asset(OtherImages.verified_by_gs1),
          title: Text("Complete Data"),
          subtitle: Text("This number is registered to company:"),
        ),
        SizedBox(height: 20),
        FutureBuilder(
            future: BaseApiService.getData(context, gtin: widget.gtin),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {}
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              data = snapshot.data;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child:
                            CustomImageWidget(imageUrl: data?.productImageUrl),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            QRImage(data: data?.productImageUrl ?? ""),
                            Text("${data?.gtin} | ${data?.brandName}"),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Padding(
                  //   padding: const EdgeInsets.all(10.0),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Text(
                  //         "${data?.productName} - ${data?.productDescription}",
                  //         style: const TextStyle(
                  //           fontSize: 20,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //       const SizedBox(height: 10),
                  //       // gtin
                  //       Text(
                  //         "GTIN".tr + ": ${data?.gtin}",
                  //         style: const TextStyle(fontSize: 18),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  GridWidget(
                    gtinNumber: data?.gtin.toString(),
                    productBrand: data?.brandName,
                    productDescription: data?.productDescription,
                    productImageUrl: data?.productImageUrl,
                    globalProductCategory: data?.gpcCategoryCode,
                    netContent: data?.gcpGLNID,
                    countryOfSale: data?.countryOfSaleCode,
                  ),
                  const Divider(thickness: 2),
                ],
              );
            }),

        const SizedBox(height: 10),
        // Comments section
        CustomTextWidget(text: "Write your comment here".tr),
        TextFormField(
          maxLines: 5,
          controller: _commentController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),

        CustomTextWidget(text: "Report Barcode".tr),
        TextFormField(
          maxLines: 3,
          controller: reportBarcodeController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),

        CustomTextWidget(text: "Mobile Number".tr),
        TextFormField(
          controller: mobileNoController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),

        CustomTextWidget(text: "Email".tr),
        TextFormField(
          controller: emailController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        // action section
        CustomTextWidget(text: "Select your action".tr),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: darkBlue),
          ),
          child: FittedBox(
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                hint: FittedBox(
                  child: Text('Select an action'.tr),
                ), // Optional text to show as a hint
                value: selectedOption,
                onChanged: (newValue) {
                  setState(() {
                    selectedOption = newValue;
                  });
                },
                items: [
                  DropdownMenuItem(
                    value: 'Photos Are Not Correct'.tr,
                    child: Text(
                      'Photos Are Not Correct'.tr,
                      style: TextStyle(color: darkBlue),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Missing GPC Brick Code'.tr,
                    child: Text(
                      'Missing GPC Brick Code'.tr,
                      style: TextStyle(color: darkBlue),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Brand Owner Is Incorrect'.tr,
                    child: Text(
                      'Brand Owner Is Incorrect'.tr,
                      style: TextStyle(color: darkBlue),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Country Of Sale Is Wrong'.tr,
                    child: Text(
                      'Country Of Sale Is Wrong'.tr,
                      style: TextStyle(color: darkBlue),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Unit Of Measuremet Is Incorrect'.tr,
                    child: Text(
                      'Unit Of Measuremet Is Incorrect'.tr,
                      style: TextStyle(color: darkBlue),
                    ),
                  ),
                  DropdownMenuItem(
                    value:
                        'Product Description Not Matching On Physical Product'
                            .tr,
                    child: Text(
                      'Product Description Not Matching On Physical Product'.tr,
                      style: TextStyle(color: darkBlue),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // photo button
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TakePhotoButton(
              onPressed: () async {
                Common.pickFileFromCamera().then((value) {
                  imageList?.add(value!);
                  imageList?.forEach((image) {
                    Common.convertFileToWebpUrl(image)
                        .then((value) => imageListUrl?.add(value));
                    setState(() {});
                  });
                });
              },
            ),
          ],
        ),
        // multiple images
        imageList!.isEmpty
            ? const SizedBox.shrink()
            : SizedBox(
                height: MediaQuery.of(context).size.height * 0.20,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: imageList?.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.file(
                            imageList![index],
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: CircleAvatar(
                            child: CloseButton(
                              onPressed: () {
                                setState(() {
                                  imageList?.removeAt(index);
                                  imageListUrl?.removeAt(index);
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
        // proceed button
        const SizedBox(height: 30),
        ProceedButton(
          data: data,
          comments: _commentController.text,
          reportBarcode: reportBarcodeController.text,
          email: emailController.text,
          mobileNo: mobileNoController.text,
          option: selectedOption,
          images: imageList,
        ),
      ],
    );
  }
}

class ProceedButton extends StatelessWidget {
  const ProceedButton({
    super.key,
    this.data,
    this.comments,
    this.reportBarcode,
    this.mobileNo,
    this.email,
    this.option,
    this.images,
  });
  final ProductContentsListModel? data;
  final String? comments;
  final String? reportBarcode;
  final String? mobileNo;
  final String? email;
  final String? option;
  final List<File>? images;

  onPressed() async {
    Common.showToast("Just a moment...");
    try {
      await GtinReporterServices.proceesGtin(
        email: email,
        gtinComment: comments,
        gtinReportAction: option,
        mobileNo: mobileNo,
        reportBarcode: reportBarcode,
        reporterImages: images,
      );
      Common.showToast('Thank you for your submission!');
    } catch (e) {
      Common.showToast(e.toString(), backgroundColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: ElevatedButton.icon(
        icon: const Icon(
          Icons.arrow_forward,
          color: whiteColor,
        ),
        onPressed: onPressed,
        label: const Text(
          "Proceed",
          style: TextStyle(
            color: whiteColor,
          ),
        ),
      ),
    );
  }
}

class TakePhotoButton extends StatelessWidget {
  const TakePhotoButton({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: orangeColor,
      ),
      child: const Text('Take Photo of'),
    );
  }
}

class CustomTextWidget extends StatelessWidget {
  const CustomTextWidget({
    super.key,
    this.text,
  });
  final String? text;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
          text: text ?? "Write your comments here",
          style: const TextStyle(
            color: darkBlue,
            fontSize: 18,
          ),
          children: const [
            TextSpan(
              text: " *",
              style: TextStyle(
                color: Colors.red,
                fontSize: 18,
              ),
            ),
          ]),
      softWrap: true,
    );
  }
}

class GridWidget extends StatelessWidget {
  const GridWidget({
    super.key,
    required this.gtinNumber,
    required this.productBrand,
    required this.productDescription,
    required this.productImageUrl,
    required this.globalProductCategory,
    required this.netContent,
    required this.countryOfSale,
  });

  final String? gtinNumber;
  final String? productBrand;
  final String? productDescription;
  final String? productImageUrl;
  final String? globalProductCategory;
  final String? netContent;
  final String? countryOfSale;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExpansionRowWidget(
          keyy: "GTIN",
          value: gtinNumber ?? "null",
          fontSize: 18,
        ),

        ExpansionRowWidget(
          keyy: "Brand Name",
          value: productBrand ?? "null",
          fontSize: 18,
        ),

        ExpansionRowWidget(
          keyy: "Product Description",
          value: productDescription ?? "null",
          fontSize: 18,
        ),

        ExpansionRowWidget(
          keyy: "Product Image Url",
          value: productImageUrl ?? "null",
          fontSize: 18,
        ),

        ExpansionRowWidget(
          keyy: "Global Product Category",
          value: globalProductCategory ?? "null",
          fontSize: 18,
        ),

        ExpansionRowWidget(
          keyy: "Net Content",
          value: netContent ?? "null",
          fontSize: 18,
        ),

        ExpansionRowWidget(
            keyy: "Country of Sale",
            value: countryOfSale ?? "null",
            fontSize: 18),
        // CustomKeyValueWidget(
        //   heading: "GTIN",
        //   value: gtinNumber ?? "1234567890123",
        //   headFlex: 2,
        //   valueFlex: 3,
        // ),
        // CustomKeyValueWidget(
        //   heading: "Brand Name",
        //   value: productBrand ?? "1234567890123",
        //   headFlex: 2,
        //   valueFlex: 3,
        // ),
        // CustomKeyValueWidget(
        //   heading: "Product Description",
        //   value: productDescription ?? "1234567890123",
        //   headFlex: 2,
        //   valueFlex: 3,
        // ),
        // CustomKeyValueWidget(
        //   heading: "Product Image Url",
        //   value: productImageUrl ?? "1234567890123",
        //   headFlex: 2,
        //   valueFlex: 3,
        // ),
        // CustomKeyValueWidget(
        //   heading: "Global Product Category",
        //   value: globalProductCategory ?? "1234567890123",
        //   headFlex: 2,
        //   valueFlex: 3,
        // ),
        // CustomKeyValueWidget(
        //   heading: "Net Content",
        //   value: netContent ?? "1234567890123",
        //   headFlex: 2,
        //   valueFlex: 3,
        // ),
        // CustomKeyValueWidget(
        //   heading: "Country of Sale",
        //   value: countryOfSale ?? "1234567890123",
        //   headFlex: 2,
        //   valueFlex: 3,
        // ),
      ],
    );
  }
}
