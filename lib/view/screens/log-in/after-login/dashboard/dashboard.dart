import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gs1_v2_project/models/login-models/dashboard_model.dart';
import 'package:gs1_v2_project/view/screens/log-in/after-login/dashboard/widgets/rectagular_widget.dart';
import 'package:gs1_v2_project/view/screens/log-in/widgets/text_widgets/primary_text_widget.dart';
import 'package:gs1_v2_project/widgets/custom_drawer_widget.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);
  static const String routeName = "/dashboard";

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // scaffold key
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final response = args['response'] as DashboardModel;
    final userId = args['userId'];

    return WillPopScope(
      onWillPop: () {
        _scaffoldKey.currentState!.openDrawer();
        return Future.value(false);
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text("Dashboard"),
          centerTitle: true,
        ),
        drawer: CustomDrawerWidget(
          userId: response.memberData?.user?.id ?? userId,
          response: response,
        ),
        body: ListView(
          children: [
            Screen(
              companyId: response.memberData?.user?.companyID,
              gcpGLNID: response.memberData?.user?.gcpGLNID,
              gcpExpiry: response.memberData?.user?.gcpExpiry,
              category: response
                  .memberData?.memberCategory?.memberCategoryDescription,
              totalNoOfBarcodes:
                  response.memberData?.memberCategory?.totalNoOfBarcodes,
              gtinRange: response.memberData?.gtinRange,
              issuedGTIN: response.memberData?.issuedGTIN,
              remainingGTIN: response.memberData?.remainingGTIN,
              issuedGLN: response.memberData?.issuedGLN,
              glnTotalBarcodes: response.memberData?.glnTotalBarcode,
              issuedSSC: response.memberData?.issuedSSCC,
              sscTotalBarcodes: response.memberData?.ssccTotalBarcode,
            ),
          ],
        ),
      ),
    );
  }
}

class Screen extends StatelessWidget {
  const Screen({
    super.key,
    this.companyId,
    this.gcpGLNID,
    this.gcpExpiry,
    this.issuedGTIN,
    this.remainingGTIN,
    this.category,
    this.totalNoOfBarcodes,
    this.gtinRange,
    this.issuedGLN,
    this.glnTotalBarcodes,
    this.issuedSSC,
    this.sscTotalBarcodes,
  });

  final String? companyId;
  final String? gcpGLNID;
  final String? gcpExpiry;
  final int? issuedGTIN;
  final int? remainingGTIN;
  final String? gtinRange;
  final int? issuedGLN;
  final int? glnTotalBarcodes;
  final int? issuedSSC;
  final int? sscTotalBarcodes;

  // member category
  final String? category;
  final String? totalNoOfBarcodes;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          PrimaryTextWidget(text: "yourSubscriptionWillExpireOn".tr),
          PrimaryTextWidget(text: gcpExpiry.toString()),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 100,
                  alignment: Alignment.center,
                  child: Image.asset("assets/images/dashboard_user.png"),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[300],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            PrimaryTextWidget(text: "GCP".tr + ":"),
                            PrimaryTextWidget(text: gcpGLNID.toString()),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            PrimaryTextWidget(text: "memberId".tr + ":"),
                            PrimaryTextWidget(text: companyId.toString()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(thickness: 3, color: Theme.of(context).primaryColor),
          Image.asset("assets/images/dashboard_barcode.png"),
          const SizedBox(height: 10),
          RectangularWidget(
            text1: category.toString(),
            text2: "$gtinRange" + " Range Of Barcodes".tr,
            text3: "$issuedGTIN" + " Barcodes Issued".tr,
            text4: "$remainingGTIN" + " Barcodes Remaining".tr,
          ),
          const SizedBox(height: 10),
          Divider(thickness: 3, color: Theme.of(context).primaryColor),
          const SizedBox(height: 10),
          Image.asset("assets/images/dashboard_location.png"),
          const SizedBox(height: 10),
          RectangularWidget(
            text1: "$issuedGLN " + "GLN Issued".tr,
            text2: "$glnTotalBarcodes " + "GLN Total Barcodes".tr,
            text3: "$issuedSSC " + "Issued SSC".tr,
            text4: "$sscTotalBarcodes " + "SSC Total Barcodes".tr,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
  });

  final String? text;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        alignment: Alignment.centerLeft,
        child: Text(
          '$text',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final LinearGradient? gradient;

  const CustomCard({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: gradient ??
              LinearGradient(
                colors: [
                  Colors.blue,
                  Colors.blue.shade900,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        ),
        // child: ListTile(
        //   dense: true,
        //   isThreeLine: true,
        //   leading: leading ?? const SizedBox.shrink(),
        //   title: title ?? const SizedBox.shrink(),
        //   subtitle: subtitle ?? const SizedBox.shrink(),
        //   trailing: trailing ?? const SizedBox.shrink(),
        // ),
        child: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(20),
          child: trailing,
        ));
  }
}
