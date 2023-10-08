import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gs1_v2_project/constants/colors/app_colors.dart';
import 'package:gs1_v2_project/models/login-models/profile/subscription_model.dart';
import 'package:gs1_v2_project/res/common/common.dart';
import 'package:gs1_v2_project/utils/app_dialogs.dart';
import 'package:gs1_v2_project/view-model/login/after-login/renewal_services.dart';
import 'package:gs1_v2_project/widgets/required_text_widget.dart';

class RenewMembershipScreen extends StatefulWidget {
  final SubscritionModel subscriptionModel;
  final String userId;
  const RenewMembershipScreen(
      {super.key, required this.subscriptionModel, required this.userId});
  static const String routeName = '/renew-membership-screen';

  @override
  State<RenewMembershipScreen> createState() => _RenewMembershipScreenState();
}

class _RenewMembershipScreenState extends State<RenewMembershipScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final productController = TextEditingController();
  final barcodesController = TextEditingController();
  final yearlySubscriptionFeeController = TextEditingController();
  late SubscritionModel subscriptionModel;
  late String userId;

  @override
  void dispose() {
    productController.dispose();
    barcodesController.dispose();
    yearlySubscriptionFeeController.dispose();
    _formKey.currentState?.dispose();
    _scaffoldKey.currentState?.dispose();
    super.dispose();
  }

  continueToPayment() async {
    AppDialogs.loadingDialog(context);

    RenewalServices.proceedRenewal(
      userId,
      subscritionModel: subscriptionModel,
    ).then((_) {
      AppDialogs.closeDialog();
      Common.showToast(
        'Renewal Successful'.tr,
        backgroundColor: Colors.blue,
      );
      Navigator.of(context).pop();
    }).catchError((e) {
      AppDialogs.closeDialog();
      Common.showToast(
        e.toString(),
        backgroundColor: Colors.red,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    subscriptionModel = widget.subscriptionModel;
    userId = widget.userId;

    final int expiryYear = int.parse(
        subscriptionModel.gtinSubscription?.expiry?.substring(0, 4) ?? '0');
    final int nextExpiryYear = expiryYear + 1;

    productController.text = subscriptionModel.gtinSubscription?.gtin ?? '';
    yearlySubscriptionFeeController.text =
        subscriptionModel.gtinSubscription?.yearlyFee.toString() ?? '';
    barcodesController.text =
        subscriptionModel.gtinSubscription?.totalNoOfBarcodes ?? '';
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        actions: [
          ElevatedButton.icon(
            label: Text('Continue to payment'.tr),
            onPressed: continueToPayment,
            icon: const Icon(Icons.save),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Expiry Year'.tr + ': $expiryYear',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20),
              RequiredTextWidget(title: "Product Name".tr),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  // labelText: 'Renewal Year',
                ),
                controller: productController,
                enabled: false,
              ),
              const SizedBox(height: 20),
              RequiredTextWidget(title: "Total Number Of Barcodes".tr),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  // labelText: 'Renewal Year',
                ),
                enabled: false,
                controller: barcodesController,
              ),
              const SizedBox(height: 20),
              RequiredTextWidget(title: "Yearly Subscription Fee".tr),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  // labelText: 'Renewal Year',
                ),
                enabled: false,
                controller: yearlySubscriptionFeeController,
              ),
              const SizedBox(height: 30),
              Text(
                'Next Expiry Year'.tr + ': $nextExpiryYear',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20),
              const Divider(thickness: 2),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    if (subscriptionModel.otherSubscription?.isEmpty ?? true) {
                      return Center(child: Text('noDataFound'.tr));
                    }
                    return Dismissible(
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 4,
                        ),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      key:
                          ValueKey(subscriptionModel.otherSubscription?[index]),
                      onDismissed: (direction) {
                        setState(() {
                          subscriptionModel.otherSubscription?.removeAt(index);
                        });
                      },
                      child: Card(
                        elevation: 5,
                        color: Colors.grey.shade200,
                        child: Table(
                          children: [
                            TableRow(
                              children: [
                                Text(
                                  'Product'.tr,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  subscriptionModel.otherSubscription?[index]
                                          .otherProduct ??
                                      '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Text(
                                  'Price'.tr,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  subscriptionModel
                                          .otherSubscription?[index].otherprice
                                          .toString() ??
                                      'Null',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Text(
                                  'Registered Date'.tr,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  subscriptionModel.otherSubscription?[index]
                                          .registerDate ??
                                      'Null',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: subscriptionModel.otherSubscription?.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
