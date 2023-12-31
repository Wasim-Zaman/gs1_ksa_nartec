// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gs1_v2_project/models/product_contents_list_model.dart';
import 'package:gs1_v2_project/models/safety_info_model.dart';
import 'package:gs1_v2_project/utils/colors.dart';
import 'package:gs1_v2_project/view-model/product-safety/product_safety_services.dart';
import 'package:gs1_v2_project/view/screens/safety_information_screen.dart';

class ProductSafetyGrid extends StatelessWidget {
  static const routeName = "/product-safety-grid-screen";
  const ProductSafetyGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductContentsListModel dataModel =
        ModalRoute.of(context)!.settings.arguments as ProductContentsListModel;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          backgroundColor: darkBlue,
          foregroundColor: whiteColor,
          title: Column(
            children: [
              Text("GTIN".tr + ":"),
              Text(dataModel.gtin!),
            ],
          ),
          centerTitle: true,
        ),
      ),
      body: dataModel == null
          ? Center(
              child: Text("Data list is empty".tr),
            )
          : FutureBuilder(
              future: ProductSafetyServices.getFutureData(context,
                  gtin: dataModel.gtin!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final List<SafetyInfoModel>? safetyModel = snapshot.data;

                return safetyModel == null
                    ? Center(child: Text("noDataFound".tr))
                    : ListView.builder(
                        itemCount: safetyModel.length,
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              SafetyInformationScreen.routeName,
                              arguments: safetyModel,
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            child: Card(
                              elevation: 5,
                              shadowColor: darkBlue,
                              child: ListTile(
                                title: Text(
                                  "${safetyModel[index].safetyDetailedInformation}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: darkBlue,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
              },
            ),
    );
  }
}
