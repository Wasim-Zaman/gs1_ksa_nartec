import 'package:flutter/material.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:gs1_v2_project/models/login-models/dashboard_model.dart';
import 'package:gs1_v2_project/models/login-models/subscription_model.dart';
import 'package:gs1_v2_project/view-model/login/after-login/subscription_list_services.dart';
import 'package:gs1_v2_project/view/screens/home/home_screen.dart';
import 'package:gs1_v2_project/view/screens/log-in/after-login/create_ticket_screen.dart';
import 'package:gs1_v2_project/view/screens/log-in/after-login/dashboard/dashboard.dart';
import 'package:gs1_v2_project/view/screens/log-in/after-login/help_desk_screen.dart';
import 'package:gs1_v2_project/view/screens/log-in/after-login/member_gln_screen.dart';
import 'package:gs1_v2_project/view/screens/log-in/after-login/member_profile_screen.dart';
import 'package:gs1_v2_project/view/screens/log-in/after-login/products.dart';
import 'package:gs1_v2_project/view/screens/log-in/after-login/sscc_screen.dart';
import 'package:gs1_v2_project/view/screens/log-in/after-login/subscribe_products_screen.dart';

class CustomDrawerWidget extends StatefulWidget {
  const CustomDrawerWidget({
    super.key,
    this.userId,
    this.response,
  });
  final int? userId;
  final DashboardModel? response;

  @override
  State<CustomDrawerWidget> createState() => _CustomDrawerWidgetState();
}

class _CustomDrawerWidgetState extends State<CustomDrawerWidget> {
  SubscriptionModel subscriptionModel = SubscriptionModel();
  bool isLoaded = false;

  @override
  void initState() {
    SubscriptionListServices.getSubscription(widget.userId!).then((response) {
      setState(() {
        subscriptionModel = response;
        isLoaded = true;
      });
    }).catchError((e) {
      print(e);
      // setState(() {
      //   isLoaded = true;
      // });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.contain,
            ),
          ),
          ListTile(
            leading: Image.asset('assets/images/dashboard_icon.png'),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                Dashboard.routeName,
                arguments: {
                  'response': widget.response,
                  'userId': widget.response?.memberData?.user?.id,
                },
              );
            },
          ),
          const Divider(thickness: 2),
          ListTile(
            leading: Image.asset('assets/images/membership_icon.png'),
            title: const Text("Membership Details"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                MemberProfileScreen.routeName,
                arguments: {
                  'response': widget.response,
                  'userId': widget.response?.memberData?.user?.id,
                },
              );
            },
          ),
          const Divider(thickness: 2),
          !isLoaded
              ? ExpansionTile(
                  title: const Text("Manage Products"),
                  leading: Image.asset('assets/images/products_icon.png'),
                  children: const [
                    ListTile(
                      title: Text("Loading..."),
                    ),
                  ],
                )
              : ExpansionTile(
                  title: const Text("Manage Products"),
                  leading: Image.asset('assets/images/products_icon.png'),
                  children: [
                    ...subscriptionModel.otherSubscription!
                        .map((e) => ListTile(
                              title: Text(e.otherProduct.toString()),
                              onTap: () {
                                if (e.otherProdID == 4) {
                                  Navigator.of(context).pushReplacementNamed(
                                      MemberGLNScreen.routeName,
                                      arguments: {
                                        'response': widget.response,
                                        'userId': widget
                                            .response?.memberData?.user?.id,
                                      });
                                } else {
                                  Navigator.of(context).pushReplacementNamed(
                                      SSCCScreen.routeName,
                                      arguments: {
                                        'response': widget.response,
                                        'userId': widget
                                            .response?.memberData?.user?.id,
                                      });
                                }
                              },
                            ))
                        .toList(),
                    ListTile(
                      title: Text(
                          subscriptionModel.gtinSubscription!.gtin.toString()),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed(
                            Products.routeName,
                            arguments: {
                              'response': widget.response,
                              'userId': widget.response?.memberData?.user?.id,
                            });
                      },
                    ),
                  ],
                ),
          // FutureBuilder(
          //     future: SubscriptionListServices.getSubscriptionList(
          //         widget.userId!),
          //     builder: (context, snapshot) {
          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         return ExpansionTile(
          //           title: const Text('Manage Products'),
          //           leading:
          //               Image.asset('assets/images/products_icon.png'),
          //         );
          //       }
          //       if (!snapshot.hasData) {
          //         return const Center(
          //           child: SizedBox.shrink(),
          //         );
          //       }
          //       if (snapshot.hasError) {
          //         return const SizedBox.shrink();
          //       }
          //       final subscriptionList = snapshot.data;
          //       return ExpansionTile(
          //         title: const Text('Manage Products'),
          //         leading: Image.asset('assets/images/products_icon.png'),
          //         children: List.generate(
          //             subscriptionList?.products?.length ?? 0,
          //             (index) => ListTile(
          //                   title: subscriptionList?.products?[index]
          //                               .toString()
          //                               .startsWith('Category') ==
          //                           true
          //                       ? const Text("GTIN")
          //                       : Text(
          //                           '${subscriptionList?.products?[index]}',
          //                         ),
          //                   onTap: () {
          //                     if (subscriptionList?.products?[index]
          //                             .toString()
          //                             .startsWith('Category') ==
          //                         true) {
          //                       // navigate to gtin
          //                       Navigator.of(context)
          //                           .pushReplacementNamed(
          //                               Products.routeName,
          //                               arguments: {
          //                             'response': widget.response,
          //                             'userId': widget
          //                                 .response?.memberData?.user?.id,
          //                           });
          //                     }
          //                     if (subscriptionList?.products?[index]
          //                             .toLowerCase()
          //                             .contains('gln') ==
          //                         true) {
          //                       Navigator.of(context)
          //                           .pushReplacementNamed(
          //                               MemberGLNScreen.routeName,
          //                               arguments: {
          //                             'response': widget.response,
          //                             'userId': widget
          //                                 .response?.memberData?.user?.id,
          //                           });
          //                     } else if (subscriptionList
          //                             ?.products?[index]
          //                             .toLowerCase()
          //                             .contains("sscc") ==
          //                         true) {
          //                       Navigator.of(context)
          //                           .pushReplacementNamed(
          //                               SSCCScreen.routeName,
          //                               arguments: {
          //                             'response': widget.response,
          //                             'userId': widget
          //                                 .response?.memberData?.user?.id,
          //                           });
          //                     } else if (subscriptionList
          //                             ?.products?[index]
          //                             .toLowerCase()
          //                             .contains("udi") ==
          //                         true) {
          //                       // UDI.....
          //                     } else if (subscriptionList
          //                             ?.products?[index]
          //                             .toLowerCase()
          //                             .contains("gtin products") ==
          //                         true) {
          //                       Navigator.of(context)
          //                           .pushReplacementNamed(
          //                               Products.routeName,
          //                               arguments: {
          //                             'response': widget.response,
          //                             'userId': widget
          //                                 .response?.memberData?.user?.id,
          //                           });
          //                     }
          //                   },
          //                 )),
          //       );
          //     }),
          const Divider(thickness: 2),
          ListTile(
            leading: Image.asset('assets/images/help_desk_icon.png'),
            title: const Text("Help Desk"),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(HelpDeskScreen.routeName, arguments: {
                'response': widget.response,
                'userId': widget.response?.memberData?.user?.id,
              });
            },
          ),
          const Divider(thickness: 2),
          ListTile(
            leading: Image.asset('assets/images/create_tickets_icon.png'),
            title: const Text("Create Ticket"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                  CreateTicketScreen.routeName,
                  arguments: {
                    'response': widget.response,
                    'userId': widget.response?.memberData?.user?.id,
                  });
            },
          ),
          const Divider(thickness: 2),
          ListTile(
            leading: Image.asset('assets/images/subscribed_products_icon.png'),
            title: const Text("Subscribe Products"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                  SubscribeProductsScreen.routeName,
                  arguments: {
                    'response': widget.response,
                    'userId': widget.response?.memberData?.user?.id,
                  });
            },
          ),
          const Divider(thickness: 2),
          ListTile(
            leading: Image.asset('assets/images/home_icon.png'),
            title: const Text("Home"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
            },
          ),
          const Divider(thickness: 2),
          ListTile(
            leading: Image.asset('assets/images/logout_icon.png'),
            title: const Text("Log Out"),
            onTap: () {
              // call this to exit app
              FlutterExitApp.exitApp();
            },
          ),
          const Divider(thickness: 2),
        ],
      ),
    );
  }
}
