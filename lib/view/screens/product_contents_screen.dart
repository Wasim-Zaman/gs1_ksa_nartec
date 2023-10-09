import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gs1_v2_project/models/product_contents_list_model.dart';
import 'package:gs1_v2_project/utils/colors.dart';
import 'package:gs1_v2_project/view-model/base-api/base_api_service.dart';
import 'package:gs1_v2_project/view/screens/promotional_offers_screen.dart';
import 'package:gs1_v2_project/view/screens/safety_information_screen.dart';
import 'package:gs1_v2_project/widgets/custom_image_widget.dart';
import 'package:gs1_v2_project/widgets/home_appbar_widget.dart';
import 'package:gs1_v2_project/widgets/secondary_appbar_widget.dart';

class ProductContentsScreen extends StatelessWidget {
  const ProductContentsScreen({super.key});

  static const routeName = '/product-contents';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBarWidget(context),
      body: FutureBuilder(
        future: BaseApiService.getData(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            final data = snapshot.data;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SecondaryAppBarWidget(
                      title1: "Retailer".tr,
                      title2: "",
                      color: Colors.pink,
                      leadingIcon: Icons.shopping_cart,
                      backgroundColor: Color.fromARGB(255, 229, 219, 134),
                    ),
                    CustomImageWidget(imageUrl: data!.productImageUrl),
                    const SizedBox(height: 10),
                    Text(
                      "${data.brandName} - ${data.companyName}",
                      softWrap: true,
                      style: const TextStyle(
                        color: purpleColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      "GTIN".tr + ": ${data.gtin}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const TabsWidget(routeName: routeName),
                  ],
                ),
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

class TabsWidget extends StatelessWidget {
  const TabsWidget({
    super.key,
    required this.routeName,
  });

  final String routeName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomListTileButton(
          title: "Safety Information".tr,
          onPressed: () {
            Navigator.pushNamed(context, SafetyInformationScreen.routeName);
          },
        ),
        CustomListTileButton(
          title: "Promotional Offers".tr,
          onPressed: () {
            Navigator.pushNamed(context, PromotionalOffersScreen.routeName);
          },
        ),
        CustomListTileButton(
          title: "Product Contents".tr,
          onPressed: () {
            Navigator.pushNamed(context, ProductContentsScreen.routeName);
          },
        ),
        CustomListTileButton(
          title: "Product Conrormance".tr,
          onPressed: () {
            Navigator.pushNamed(context, ProductContentsScreen.routeName);
          },
        ),
        CustomListTileButton(
          title: "Product Composition".tr,
          onPressed: () {
            Navigator.pushNamed(context, ProductContentsScreen.routeName);
          },
        ),
        CustomListTileButton(
          title: "Customs And Border Check".tr,
          onPressed: () {
            Navigator.pushNamed(context, ProductContentsScreen.routeName);
          },
        ),
        CustomListTileButton(
          title: "Product Tracking".tr,
          onPressed: () {
            Navigator.pushNamed(context, ProductContentsScreen.routeName);
          },
        ),
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
        title: Text(title ?? ''),
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

class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.data,
  });

  final ProductContentsListModel? data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Card(
          elevation: 6,
          child: Image.network(
            data!.productImageUrl!,
            fit: BoxFit.contain,
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }
}
