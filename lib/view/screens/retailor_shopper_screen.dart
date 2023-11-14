// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gs1_v2_project/models/product_contents_list_model.dart';
import 'package:gs1_v2_project/providers/product.dart';
import 'package:gs1_v2_project/utils/colors.dart';
import 'package:gs1_v2_project/view-model/base-api/base_api_service.dart';
import 'package:gs1_v2_project/view/screens/grids/logistic_info_grid_screen.dart';
import 'package:gs1_v2_project/view/screens/grids/product_contents_grid_screen.dart';
import 'package:gs1_v2_project/view/screens/grids/recipe_grid_screen.dart';
import 'package:gs1_v2_project/widgets/custom_image_widget.dart';
import 'package:gs1_v2_project/widgets/home_appbar_widget.dart';
import 'package:gs1_v2_project/widgets/secondary_appbar_widget.dart';
import 'package:provider/provider.dart';

class RetailorShopperScreen extends StatefulWidget {
  const RetailorShopperScreen({super.key});

  static const routeName = '/retailor_shopper_screen';

  @override
  State<RetailorShopperScreen> createState() => _RetailorShopperScreenState();
}

class _RetailorShopperScreenState extends State<RetailorShopperScreen> {
  String? gtin;
  @override
  void initState() {
    // get gtin from arguments as string
    Future.delayed(Duration(seconds: 1), () {
      gtin = ModalRoute.of(context)?.settings.arguments as String;
    });
    super.initState();
  }

  // ProductContentsListModel? myData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBarWidget(context),
      body: FutureBuilder(
        future: BaseApiService.getData(context, gtin: gtin),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            final data = snapshot.data;
            return ChangeNotifierProvider(
              create: (context) => Product(
                gtin: data.gtin!,
                productImageUrl: data.productImageUrl!,
                productDescription: data.productDescription!,
                productName: data.productName!,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SecondaryAppBarWidget(
                      title1: "Retailer".tr,
                      title2: "",
                      color: pinkColor,
                      leadingIcon: Icons.shopping_cart,
                      backgroundColor: yellowAppBarColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomImageWidget(imageUrl: data!.productImageUrl),
                          const SizedBox(height: 10),
                          Text(
                            "${data.productName} - ${data.productDescription}",
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
                          TabsWidget(data: data),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return RefreshIndicator(
              onRefresh: () => BaseApiService.getData(context),
              child: Center(
                child: Center(
                  child: Text(snapshot.error.toString()),
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
    required this.data,
  });
  final ProductContentsListModel data;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomListTileButton(
          title: "Ingredients & Allergens".tr,
          onPressed: () {
            Navigator.pushNamed(
              context,
              ProductContentsGridScreen.routeName,
              arguments: data,
            );
          },
        ),
        CustomListTileButton(
          title: "Recipes".tr,
          onPressed: () {
            Navigator.pushNamed(
              context,
              RecipeGridScreen.routeName,
              arguments: data,
            );
          },
        ),
        CustomListTileButton(
          title: "Logistics information".tr,
          onPressed: () {
            Navigator.pushNamed(
              context,
              LogisticInfoGridScreen.routeName,
              arguments: data,
            );
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

// class ProductImage extends StatelessWidget {
//   const ProductImage({
//     super.key,
//     required this.data,
//   });

//   final ProductContentsListModel? data;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       height: MediaQuery.of(context).size.height * 0.3,
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(20),
//         child: Card(
//           elevation: 6,
//           child: Image.network(
//             data!.productImageUrl!,
//             fit: BoxFit.contain,
//             alignment: Alignment.center,
//           ),
//         ),
//       ),
//     );
//   }
// }
