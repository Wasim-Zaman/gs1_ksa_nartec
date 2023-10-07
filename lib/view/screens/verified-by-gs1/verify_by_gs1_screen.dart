// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gs1_v2_project/models/product_contents_list_model.dart';
import 'package:gs1_v2_project/view-model/base-api/base_api_service.dart';
import 'package:gs1_v2_project/view/screens/widgets/expansion_row_widget.dart';
import 'package:gs1_v2_project/widgets/custom_appbar_widget.dart';
import 'package:gs1_v2_project/widgets/custom_image_widget.dart';
import 'package:gs1_v2_project/widgets/home_appbar_widget.dart';

class VerifyByGS1Screen extends StatelessWidget {
  const VerifyByGS1Screen({super.key});
  static const routeName = "/verify_by_gs1_screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBarWidget(context),
      body: FutureBuilder(
        future: BaseApiService.getData(context),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Text('noDataFound'.tr));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data;
          return Screen(
            countryOfSale: data?.countryOfSaleCode,
            globalProductCategory: data?.gpcCategoryCode,
            gtinNumber: data?.gtin,
            netContent: data?.gcpGLNID,
            productBrand: data?.brandName,
            productDescription: data?.productDescription,
            productImageUrl: data?.productImageUrl,
            data: data,
          );
        },
      ),
    );
  }
}

class Screen extends StatelessWidget {
  Screen({
    super.key,
    this.productImageUrl,
    this.gtinNumber,
    this.productDescription,
    this.productBrand,
    this.globalProductCategory,
    this.netContent,
    this.countryOfSale,
    this.data,
  });

  final String? productImageUrl;
  final String? gtinNumber;
  final String? productDescription;
  final String? productBrand;
  final String? globalProductCategory;
  final String? netContent;
  final String? countryOfSale;
  ProductContentsListModel? data;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder(
              future: BaseApiService.getData(context),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {}
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                data = snapshot.data;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customAppBarWidget(
                      backgroundColor: Colors.green.shade400,
                      title: "GS1 Saudi Arabia".tr,
                    ),
                    CustomImageWidget(imageUrl: data?.productImageUrl),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${data?.productName} - ${data?.productDescription}",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // gtin
                          Text(
                            "GTIN".tr + ": ${data?.gtin}",
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(thickness: 2),
                  ],
                );
              }),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                GridWidget(
                  gtinNumber: gtinNumber,
                  productBrand: productBrand,
                  productDescription: productDescription,
                  productImageUrl: productImageUrl,
                  globalProductCategory: globalProductCategory,
                  netContent: netContent,
                  countryOfSale: countryOfSale,
                ),
              ],
            ),
          ),
        ],
      ),
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
          keyy: "GTIN".tr,
          value: gtinNumber ?? "null",
          fontSize: 18,
        ),
        const Divider(thickness: 2),
        ExpansionRowWidget(
          keyy: "Brand Name".tr,
          value: productBrand ?? "null",
          fontSize: 18,
        ),
        const Divider(thickness: 2),
        ExpansionRowWidget(
          keyy: "Product Description".tr,
          value: productDescription ?? "null",
          fontSize: 18,
        ),
        const Divider(thickness: 2),
        ExpansionRowWidget(
          keyy: "Product Image Url".tr,
          value: productImageUrl ?? "null",
          fontSize: 18,
        ),
        const Divider(thickness: 2),
        ExpansionRowWidget(
          keyy: "Global Product Category".tr,
          value: globalProductCategory ?? "null",
          fontSize: 18,
        ),
        const Divider(thickness: 2),
        ExpansionRowWidget(
          keyy: "Net Content".tr,
          value: netContent ?? "null",
          fontSize: 18,
        ),
        const Divider(thickness: 2),
        ExpansionRowWidget(
            keyy: "Country of Sale".tr,
            value: countryOfSale ?? "null",
            fontSize: 18),
      ],
    );
  }
}

class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green[200],
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ListTile(
        leading: Image.asset(
          "assets/images/gs1-logo.png",
          width: 100,
        ),
        title: Text(
          "Complete Data".tr,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          "This number is registered to company. Al Wifaq Factory For Children Cosmetics"
              .tr,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
