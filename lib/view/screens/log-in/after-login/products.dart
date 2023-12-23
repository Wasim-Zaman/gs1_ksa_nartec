import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gs1_v2_project/models/login-models/dashboard_model.dart';
import 'package:gs1_v2_project/view-model/login/after-login/products_services.dart';
import 'package:gs1_v2_project/widgets/custom_drawer_widget.dart';
import 'package:gs1_v2_project/widgets/loading/loading_widget.dart';

class Products extends StatefulWidget {
  const Products({super.key});
  static const String routeName = '/products';

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  // scaffold key
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  dispose() {
    scaffoldKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final response = args['response'] as DashboardModel;
    final userId = args['userId'] as int;
    print(response.memberData?.user?.id);
    print(response.memberData?.user?.id ?? userId);
    return WillPopScope(
      onWillPop: () async {
        scaffoldKey.currentState?.openDrawer();
        return false;
      },
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('Manage Products'.tr),
        ),
        drawer: CustomDrawerWidget(
          userId: response.memberData?.user?.id ?? userId,
          response: response,
        ),
        body: FutureBuilder(
          future: ProductsServices.getProducts(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingWidget();
            }
            if (!snapshot.hasData) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_sharp,
                      size: 100,
                    ),
                    Text('noDataFound'.tr),
                  ],
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline_sharp,
                      size: 100,
                    ),
                    Text('${snapshot.error}')
                  ],
                ),
              );
            }

            final snap = snapshot.data?.products;
            final imagePath = snapshot.data?.imagePath;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomBoxText(text: "Member Id".tr + ": $userId"),
                      CustomBoxText(
                        text: "GCP".tr +
                            ": ${response.memberData?.user?.gcpGLNID}",
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomBoxText(
                        text: response.memberData?.memberCategory
                            ?.memberCategoryDescription,
                      ),
                      const SizedBox(),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(thickness: 2),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snap?.length,
                      itemBuilder: (context, index) {
                        final productName = snap?[index].productnameenglish;
                        final barcode = snap?[index].barcode;
                        final brandName = snap?[index].brandName;
                        final frontImage =
                            "$imagePath/${snap?[index].frontImage}";

                        return Card(
                          elevation: 2,
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                frontImage.toString(),
                              ),
                              onBackgroundImageError: (exception, stackTrace) =>
                                  const Placeholder(
                                fallbackHeight: 30,
                                fallbackWidth: 30,
                              ),
                              // child: Image.network(
                              //   frontImage.toString(),
                              //   fit: BoxFit.contain,
                              //   errorBuilder: (context, error, stackTrace) =>
                              //       const Placeholder(
                              //     fallbackHeight: 30,
                              //     fallbackWidth: 30,
                              //   ),
                              // ),
                            ),
                            title: Text(
                              productName.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(barcode.toString()),
                            trailing: Text(brandName.toString()),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class CustomBoxText extends StatelessWidget {
  const CustomBoxText({
    super.key,
    this.text,
  });

  final String? text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: FittedBox(
          child: Text(
            text ?? "Text",
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
