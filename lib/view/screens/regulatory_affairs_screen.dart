import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gs1_v2_project/models/product_contents_list_model.dart';
import 'package:gs1_v2_project/utils/colors.dart';
import 'package:gs1_v2_project/view-model/base-api/base_api_service.dart';
import 'package:gs1_v2_project/view/screens/custom_and_border_check_screen.dart';
import 'package:gs1_v2_project/view/screens/grids/package_composition_grid_screen.dart';
import 'package:gs1_v2_project/view/screens/grids/product_safety_grid.dart';
import 'package:gs1_v2_project/widgets/custom_appbar_widget.dart';
import 'package:gs1_v2_project/widgets/custom_image_widget.dart';
import 'package:gs1_v2_project/widgets/home_appbar_widget.dart';

class RegulatoryAffairsScreen extends StatefulWidget {
  const RegulatoryAffairsScreen({super.key});

  static const routeName = '/regulatory-Affairs-Screen';

  @override
  State<RegulatoryAffairsScreen> createState() =>
      _RegulatoryAffairsScreenState();
}

class _RegulatoryAffairsScreenState extends State<RegulatoryAffairsScreen> {
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
          if (snapshot.hasData) {
            final data = snapshot.data;
            return ListView(
              children: [
                customAppBarWidget(
                  title: "Regulatory Affairs".tr,
                  backgroundColor: Colors.green[900],
                ),
                Screen(data: data),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Center(
                child: Text(snapshot.error.toString()),
              ),
            );
          } else {
            return Center(
              child: Center(
                child: Text('Something went wrong'.tr),
              ),
            );
          }
        },
      ),
    );
  }
}

class Screen extends StatelessWidget {
  const Screen({
    super.key,
    required this.data,
  });

  final ProductContentsListModel? data;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomImageWidget(imageUrl: data?.productImageUrl),
            const SizedBox(height: 10),
            Text(
              "${data?.productName} - ${data?.productDescription}",
              style: const TextStyle(
                color: purpleColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "GTIN".tr + ": ${data?.gtin}",
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const Divider(thickness: 2),
            TabsWidget(data: data!),
          ],
        ),
      ),
    );
  }
}

class TabsWidget extends StatelessWidget {
  const TabsWidget({
    super.key,
    required this.data,
  });
  final ProductContentsListModel data;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomListTileButton(
          title: "Product Safety (Conformance)".tr,
          onPressed: () {
            Navigator.of(context).pushNamed(
              ProductSafetyGrid.routeName,
              arguments: data,
            );
          },
        ),
        CustomListTileButton(
          title: "Packaging Composition".tr,
          onPressed: () {
            Navigator.of(context).pushNamed(
              PackageCompositionGridScreen.routeName,
              arguments: data,
            );
          },
        ),
        CustomListTileButton(
          title: "Customs & Border Check".tr,
          onPressed: () {
            // Navigator.of(context)
            //     .pushNamed(CustomAndBorderCheckScreen.routeName);
            Navigator.of(context).pushNamed(
              CustomAndBorderCheckScreen.routeName,
              arguments: data,
            );
          },
        ),
        CustomListTileButton(title: "Quality Assurance".tr, onPressed: () {}),
        CustomListTileButton(title: "ISO Compliance".tr, onPressed: () {}),
        CustomListTileButton(title: "SASO Conformance".tr, onPressed: () {}),
      ],
    );
  }
}

class CustomListTileButton extends StatelessWidget {
  const CustomListTileButton({
    super.key,
    this.title,
    this.onPressed,
  });

  final String? title;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        title: Text(title ?? 'Title'),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: pinkColor,
          size: 15,
        ),
        onTap: onPressed ?? () {},
      ),
    );
  }
}
