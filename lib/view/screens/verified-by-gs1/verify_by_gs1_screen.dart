// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:gs1_v2_project/blocs/gtin/gtin_bloc.dart';
import 'package:gs1_v2_project/models/product_contents_list_model.dart';
import 'package:gs1_v2_project/view/screens/widgets/expansion_row_widget.dart';
import 'package:gs1_v2_project/widgets/custom_appbar_widget.dart';
import 'package:gs1_v2_project/widgets/custom_image_widget.dart';
import 'package:gs1_v2_project/widgets/home_appbar_widget.dart';

class VerifyByGS1Screen extends StatefulWidget {
  const VerifyByGS1Screen({super.key});
  static const routeName = "/verify_by_gs1_screen";

  @override
  State<VerifyByGS1Screen> createState() => _VerifyByGS1ScreenState();
}

class _VerifyByGS1ScreenState extends State<VerifyByGS1Screen> {
  String? gtin;
  GtinBloc gtinBloc = GtinBloc();
  @override
  void initState() {
    // get gtin from arguments as string
    // add event to bloc
    Future.delayed(Duration(seconds: 1), () {
      gtin = ModalRoute.of(context)?.settings.arguments as String?;
      gtinBloc = gtinBloc
        ..add(GtinGetDataEvent(
          context,
          gtin: gtin.toString(),
        ));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('rebuild');
    return Scaffold(
      appBar: HomeAppBarWidget(context),
      body: BlocConsumer<GtinBloc, GtinState>(
        bloc: gtinBloc,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is GtinLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GtinErrorState) {
            Center(
              child: Column(
                children: [
                  Image.asset('assets/images/404.jpeg'),
                  const SizedBox(height: 10),
                  Text("The page you are trying to access does not exist"),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          gtinBloc.add(GtinGetDataEvent(
                            context,
                            gtin: gtin.toString(),
                          ));
                        },
                        child: const Text('Reload'),
                      ),
                      // Back button
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Go back'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else if (state is GtinSuccessState) {
            print(state.model?.brandName.toString());
            return Screen(
              countryOfSale: state.model?.countryOfSaleCode,
              globalProductCategory: state.model?.gpcCategoryCode,
              gtinNumber: state.model?.gtin,
              netContent: state.model?.gcpGLNID,
              productBrand: state.model?.brandName,
              productDescription: state.model?.productDescription,
              productImageUrl: state.model?.productImageUrl,
              data: state.model,
            );
          }
          return Container();
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
          Column(
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
          ),
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
