import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gs1_v2_project/view-model/base-api/base_api_service.dart';
import 'package:gs1_v2_project/widgets/custom_appbar_widget.dart';
import 'package:gs1_v2_project/widgets/home_appbar_widget.dart';

import 'widgets/expansion_panel_widget.dart';
import 'widgets/first_expansion_widget.dart';
import 'widgets/item.dart';
import 'widgets/second_expansion_widget.dart';

class CustomAndBorderCheckScreen extends StatefulWidget {
  const CustomAndBorderCheckScreen({super.key});
  static const routeName = '/custom-&-border-check-Screen';

  @override
  State<CustomAndBorderCheckScreen> createState() =>
      _CustomAndBorderCheckScreenState();
}

class _CustomAndBorderCheckScreenState
    extends State<CustomAndBorderCheckScreen> {
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
      appBar: HomeAppBarWidget(context),
      body: FutureBuilder(
        future: BaseApiService.getData(context, gtin: gtin.toString()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong'.tr),
            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: Text('noDataFound'.tr),
            );
          }
          final data = snapshot.data;
          return SizedBox(
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.height * 1,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  customAppBarWidget(
                    backgroundColor: Colors.green[900],
                    title: "Custom & Border Check".tr,
                  ),
                  ExpansionPanelWidget(
                    items: [
                      Item(
                        headers: 'Company Verification'.tr,
                        body: FirstExpansionWidget(
                          companyName: data?.companyName,
                          licenseKey: data?.licenceKey,
                          licenseType: data?.licenceType,
                          companyAddress: data?.address,
                          companyWebsite: data?.website,
                          globalLocationNumber: data?.gcpGLNID,
                        ),
                        isExpanded: false,
                      ),
                    ],
                  ),
                  ExpansionPanelWidget(
                    items: [
                      Item(
                        headers: 'Product Verification'.tr,
                        body: SecondExpansionWidget(
                          brandName: data?.brandName,
                          gtin: data?.gtin,
                          imgURL: data?.productImageUrl,
                          productName: data?.productName,
                          productDescription: data?.productDescription,
                          companyName: data?.companyName,
                          countryOfSale: data?.countryOfSaleCode,
                          globalProductContent: data?.gpcCategoryCode,
                          netContent: data?.gcpGLNID,
                        ),
                        isExpanded: false,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
