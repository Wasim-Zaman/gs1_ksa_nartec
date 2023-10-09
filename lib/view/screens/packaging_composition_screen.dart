import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gs1_v2_project/models/package_composition_model.dart';
import 'package:gs1_v2_project/widgets/custom_appbar_widget.dart';
import 'package:gs1_v2_project/widgets/custom_image_widget.dart';
import 'package:gs1_v2_project/widgets/home_appbar_widget.dart';

class PackagingCompositionScreen extends StatelessWidget {
  static const routeName = "/packaging-composition-screen";
  const PackagingCompositionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PkgCmpModel dataModel =
        ModalRoute.of(context)!.settings.arguments as PkgCmpModel;
    return Scaffold(
      appBar: HomeAppBarWidget(context),
      body: ListView(
        children: [
          customAppBarWidget(
            title: "Packaging Composition".tr,
            backgroundColor: Colors.green[900],
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PageSingleInstance(
                  imageUrl: dataModel.logo,
                  title: dataModel.title,
                  gtin: dataModel.gTIN,
                  consumerProductVariant: dataModel.consumerProductVariant,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PageSingleInstance extends StatelessWidget {
  const PageSingleInstance({
    super.key,
    this.imageUrl,
    this.title,
    this.gtin,
    this.consumerProductVariant,
  });

  final String? imageUrl;
  final String? title;
  final String? gtin;
  final String? consumerProductVariant;

  firstSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomImageWidget(imageUrl: imageUrl),
      ],
    );
  }

  secondSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? "",
          softWrap: true,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "GTIN".tr + ": $gtin",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 10),
        Text(
          "Consumer Product Variant".tr + ": $consumerProductVariant",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
          textAlign: TextAlign.left,
        ),
        const Divider(thickness: 3),
      ],
    );
  }

  thirdSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomRowWidget(heading: "Packaging".tr),
        CustomRowWidget(heading: "Material".tr),
        CustomRowWidget(heading: "Recyclability".tr),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          firstSection(),
          secondSection(context),
          thirdSection(),
          const SizedBox(height: 20),
          Text(
            "Data provided by Dal Giardino".tr,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomRowWidget extends StatelessWidget {
  const CustomRowWidget({
    super.key,
    this.heading,
    this.value,
  });
  final String? heading;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                heading ?? "",
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                value ?? "",
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
