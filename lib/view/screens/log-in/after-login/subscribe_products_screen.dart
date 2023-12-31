import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gs1_v2_project/constants/colors/app_colors.dart';
import 'package:gs1_v2_project/models/login-models/dashboard_model.dart';
import 'package:gs1_v2_project/models/login-models/profile/subscription_model.dart';
import 'package:gs1_v2_project/view-model/login/after-login/subscription_services.dart';
import 'package:gs1_v2_project/view/screens/log-in/after-login/renew_membership_screen.dart';
import 'package:gs1_v2_project/view/screens/log-in/widgets/text_widgets/table_header_text.dart';
import 'package:gs1_v2_project/widgets/custom_drawer_widget.dart';
import 'package:gs1_v2_project/widgets/loading/loading_widget.dart';
import 'package:velocity_x/velocity_x.dart';

class SubscribeProductsScreen extends StatefulWidget {
  const SubscribeProductsScreen({super.key});
  static const String routeName = 'subscribe-products-screen';

  @override
  State<SubscribeProductsScreen> createState() =>
      _SubscribeProductsScreenState();
}

class _SubscribeProductsScreenState extends State<SubscribeProductsScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  // scaffold key
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _pageController.dispose();
    scaffoldKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map;
    final response = args['response'] as DashboardModel;
    final userId = args['userId'];
    return WillPopScope(
      onWillPop: () async {
        scaffoldKey.currentState?.openDrawer();
        return false;
      },
      child: WillPopScope(
        onWillPop: () async {
          scaffoldKey.currentState?.openDrawer();
          return false;
        },
        child: Scaffold(
          key: scaffoldKey,
          drawer: CustomDrawerWidget(
            userId: response.memberData?.user?.id ?? userId,
            response: response,
          ),
          bottomNavigationBar: BottomNavyBar(
            showElevation: true,
            selectedIndex: _currentIndex,
            onItemSelected: (index) {
              setState(() => _currentIndex = index);
              _pageController.jumpToPage(index);
            },
            items: <BottomNavyBarItem>[
              BottomNavyBarItem(
                title: Text('GTIN Subscription'.tr),
                icon: const Icon(Icons.home),
                activeColor: Theme.of(context).primaryColor,
                inactiveColor: Theme.of(context).primaryColorLight,
              ),
              BottomNavyBarItem(
                title: Text('Other Subscription'.tr),
                icon: const Icon(Icons.apps),
                activeColor: Theme.of(context).primaryColor,
                inactiveColor: Theme.of(context).primaryColorLight,
              ),
            ],
          ),
          appBar: AppBar(
            title: Text("Subscribe Products".tr),
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 0,
          ),
          body: FutureBuilder(
            future: SubscriptionServices.getSubscription(userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingWidget();
              } else if (!snapshot.hasData) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 60,
                        color: AppColors.primaryColor,
                      ),
                      Text("No Data Found".tr),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {});
                        },
                        icon: const Icon(Icons.refresh),
                        label: Text("Refresh The Page".tr),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: (snapshot.error
                          .toString()
                          .toLowerCase()
                          .contains("Required to update your profile".tr))
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error,
                              color: Colors.yellow,
                              size: 80,
                            ),
                            snapshot.error
                                .toString()
                                .replaceAll("Exception:", "")
                                .text
                                .xl
                                .bold
                                .make()
                                .centered(),
                            const SizedBox(height: 20),
                            "Please update your profile to continue"
                                .tr
                                .text
                                .make()
                                .centered(),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error,
                              color: Colors.red,
                              size: 60,
                            ),
                            "${snapshot.error}"
                                .replaceAll("Exception:", "")
                                .text
                                .make()
                                .centered(),
                            10.heightBox,
                            // retry
                            ElevatedButton(
                              onPressed: () {
                                setState(() {});
                              },
                              child: Text("Retry".tr),
                            ),
                          ],
                        ),
                );
              }
              final response = snapshot.data;

              return PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                dragStartBehavior: DragStartBehavior.start,
                children: <Widget>[
                  _currentIndex == 0
                      ? GtinSubscription(
                          response: response!,
                          userId: userId.toString(),
                        )
                      : OtherSubscription(response: response!),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class OtherSubscription extends StatefulWidget {
  const OtherSubscription({super.key, required this.response});
  final SubscritionModel response;

  @override
  State<OtherSubscription> createState() => _OtherSubscriptionState();
}

class _OtherSubscriptionState extends State<OtherSubscription> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // ImageWidget(
                //   context,
                //   imageUrl: 'assets/images/subscribed_products_image.png',
                //   fit: BoxFit.contain,
                // ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        dataRowColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.08);
                            }
                            return Colors.white;
                          },
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        dividerThickness: 2,
                        border: const TableBorder(
                          horizontalInside: BorderSide(
                            color: Colors.grey,
                            width: 2,
                          ),
                          verticalInside: BorderSide(
                            color: Colors.grey,
                            width: 2,
                          ),
                        ),
                        columns: [
                          DataColumn(
                            label: TableHeaderText(text: 'Product'.tr),
                          ),
                          DataColumn(
                            label:
                                TableHeaderText(text: 'Registration Date'.tr),
                          ),
                          DataColumn(
                            label: TableHeaderText(text: 'Expiry'.tr),
                          ),
                        ],
                        rows: widget.response.otherSubscription!
                            .map(
                              (e) => DataRow(
                                cells: [
                                  DataCell(Text(widget
                                      .response.gtinSubscription!.gtin
                                      .toString())),
                                  DataCell(Text(widget
                                      .response.gtinSubscription!.registerDate
                                      .toString())),
                                  DataCell(Text(widget
                                      .response.gtinSubscription!.expiry
                                      .toString())),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GtinSubscription extends StatefulWidget {
  const GtinSubscription(
      {super.key, required this.response, required this.userId});
  final SubscritionModel response;
  final String userId;

  @override
  State<GtinSubscription> createState() => _GtinSubscriptionState();
}

class _GtinSubscriptionState extends State<GtinSubscription> {
  @override
  Widget build(BuildContext context) {
    // final gtin = widget.response.gtinSubscription;
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  "Your Subscription Will Expire On:".tr,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  widget.response.gtinSubscription!.expiry.toString(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Subscription Details".tr,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        dataRowColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.08);
                            }
                            return Colors.white;
                          },
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        dividerThickness: 2,
                        border: const TableBorder(
                          horizontalInside: BorderSide(
                            color: Colors.grey,
                            width: 2,
                          ),
                          verticalInside: BorderSide(
                            color: Colors.grey,
                            width: 2,
                          ),
                        ),
                        columns: [
                          DataColumn(
                            label: TableHeaderText(text: 'Product'.tr),
                          ),
                          DataColumn(
                            label:
                                TableHeaderText(text: 'Registration Date'.tr),
                          ),
                          DataColumn(
                            label: TableHeaderText(text: 'Expiry'.tr),
                          ),
                        ],
                        rows: [
                          DataRow(
                            cells: [
                              DataCell(Text(widget
                                  .response.gtinSubscription!.gtin
                                  .toString())),
                              DataCell(Text(widget
                                  .response.gtinSubscription!.registerDate
                                  .toString())),
                              DataCell(Text(widget
                                  .response.gtinSubscription!.expiry
                                  .toString())),
                            ],
                          ),
                        ].toList(),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
                // const Text(
                //   "Actions",
                //   style: TextStyle(
                //     fontSize: 30,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RenewMembershipScreen(
                            subscriptionModel: widget.response,
                            userId: widget.userId,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Theme.of(context).primaryColorDark,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                    child: Text("Renew Membership".tr),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
