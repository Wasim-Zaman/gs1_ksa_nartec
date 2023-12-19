import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gs1_v2_project/models/product_contents_list_model.dart';
import 'package:gs1_v2_project/utils/app_navigator.dart';
import 'package:gs1_v2_project/view-model/base-api/base_api_service.dart';
import 'package:gs1_v2_project/view/screens/offers_nearMe_screen.dart';
import 'package:gs1_v2_project/view/screens/scanning/barcode_scanning_screen.dart';
import 'package:gs1_v2_project/widgets/buttons/primary_button_widget.dart';
import 'package:gs1_v2_project/widgets/custom_image_widget.dart';
import 'package:gs1_v2_project/widgets/home_appbar_widget.dart';
import 'package:gs1_v2_project/widgets/secondary_appbar_widget.dart';

class RetailInformationScreen extends StatefulWidget {
  const RetailInformationScreen({super.key});

  static const routeName = '/retail-information-screen';

  @override
  State<RetailInformationScreen> createState() =>
      _RetailInformationScreenState();
}

class _RetailInformationScreenState extends State<RetailInformationScreen> {
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
        future: BaseApiService.getData(
          context,
          gtin: ModalRoute.of(context)?.settings.arguments as String,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                children: [
                  Image.asset('assets/images/404.jpeg'),
                  const SizedBox(height: 10),
                  Text("The page you are trying to access does not exist"),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {});
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
          } else if (!snapshot.hasData) {
            return Center(
              child: Column(
                children: [
                  Image.asset('assets/images/404.jpeg'),
                  const SizedBox(height: 10),
                  Text("It seems like there is no data for this GTIN"),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {});
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
          }
          final data = snapshot.data;
          return ListView(
            children: [
              const SecondaryAppBarWidget(),
              Screen(
                data: data,
              ),
            ],
          );
        },
      ),
    );
  }
}

class Screen extends StatelessWidget {
  const Screen({
    super.key,
    this.data,
  });

  final ProductContentsListModel? data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          // First Section
          CustomImageWidget(imageUrl: data?.productImageUrl),
          const SizedBox(height: 20),
          // title
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
          // amount
          const SizedBox(height: 10),

          PrimaryButtonWidget(
            caption: 'Scan another barcode'.tr,
            onPressed: () {
              AppNavigator.goToPage(
                context: context,
                screen: BarcodeScanningScreen(
                  icon: "retail-information",
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          // Second Section
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                CustomReusableButton(
                  text: "Offers Near Me".tr,
                  onTap: () => Navigator.of(context).pushNamed(
                    OffersNearMeScreen.routeName,
                    arguments: data,
                  ),
                ),
                CustomReusableButton(text: "Competitive Price".tr),
                CustomReusableButton(text: "Top Seller".tr),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomReusableButton extends StatelessWidget {
  const CustomReusableButton({
    super.key,
    this.text,
    this.onTap,
  });

  final String? text;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: ListTile(
        onTap: onTap ?? () {},
        title: Text(text ?? ""),
      ),
    );
  }
}
