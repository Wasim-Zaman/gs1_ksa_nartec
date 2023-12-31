import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gs1_v2_project/models/product_contents_list_model.dart';
import 'package:gs1_v2_project/utils/colors.dart';
import 'package:gs1_v2_project/view-model/ingredients/ingredients_services.dart';
import 'package:gs1_v2_project/view/screens/logistic_information_screen.dart';

class LogisticInfoGridScreen extends StatelessWidget {
  static const routeName = "/logistic_info_grid_screen";
  const LogisticInfoGridScreen({super.key});

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
      body: dataModel.isBlank == true
          ? Center(
              child: Text("noDataFound".tr),
            )
          : FutureBuilder(
              future: IngredientsServices.getFutureData(
                context,
                gtin: dataModel.gtin,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final data = snapshot.data;
                final dataModel = ModalRoute.of(context)!.settings.arguments
                    as ProductContentsListModel;
                return data == null
                    ? Center(child: Text('noDataFound'.tr))
                    : ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              LogisticInformationScreen.routeName,
                              arguments: {
                                "id": data[index].iD,
                                "gtin": dataModel.gtin,
                                'dataModel': dataModel,
                              },
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
                                leading: CircleAvatar(
                                  backgroundColor: darkBlue,
                                  child: Text(
                                    data[index].iD.toString(),
                                    style: const TextStyle(
                                      color: whiteColor,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  data[index].productAllergenInformation ??
                                      "null",
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
