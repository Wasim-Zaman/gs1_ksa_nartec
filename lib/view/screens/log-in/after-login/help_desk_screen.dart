import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gs1_v2_project/constants/colors/app_colors.dart';
import 'package:gs1_v2_project/models/login-models/dashboard_model.dart';
import 'package:gs1_v2_project/view-model/login/after-login/help_desk_services.dart';
import 'package:gs1_v2_project/view/screens/log-in/widgets/text_widgets/table_header_text.dart';
import 'package:gs1_v2_project/widgets/custom_drawer_widget.dart';
import 'package:gs1_v2_project/widgets/images/image_widget.dart';
import 'package:gs1_v2_project/widgets/loading/loading_widget.dart';
import 'package:gs1_v2_project/widgets/required_text_widget.dart';
import 'package:velocity_x/velocity_x.dart';

class HelpDeskScreen extends StatefulWidget {
  const HelpDeskScreen({super.key});
  static const String routeName = 'help-desk-screen';

  @override
  State<HelpDeskScreen> createState() => _HelpDeskScreenState();
}

class _HelpDeskScreenState extends State<HelpDeskScreen> {
  // scaffold key
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // dispose the key
  @override
  void dispose() {
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
      child: Scaffold(
        key: scaffoldKey,
        drawer: CustomDrawerWidget(
          userId: response.memberData?.user?.id ?? userId,
          response: response,
        ),
        appBar: AppBar(
          title: Text("Help Desk".tr),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
        ),
        body: FutureBuilder(
          future: HelpDeskServices.getData(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingWidget();
            } else if (snapshot.hasError) {
              return Center(
                child: (snapshot.error
                        .toString()
                        .toLowerCase()
                        .contains("required to update your profile".tr))
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
                          Icon(
                            Icons.error_outline_sharp,
                            size: 100,
                          ),
                          Text('Something went wrong'.tr),
                        ],
                      ),
              );
            } else if (!snapshot.hasData) {
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: AppColors.primaryColor,
                    ),
                    Text("noDataFound".tr),
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
            }

            final snap = snapshot.data;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ImageWidget(
                          context,
                          imageUrl: "assets/images/help_desk_image.png",
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: RequiredTextWidget(title: "Ticket Details".tr),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: DataTable(
                                dataRowColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states
                                        .contains(MaterialState.selected)) {
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
                                  border:
                                      Border.all(color: Colors.grey, width: 1),
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
                                    label: TableHeaderText(
                                        text: 'Ticket Number'.tr),
                                  ),
                                  DataColumn(
                                    label: TableHeaderText(text: 'Title'.tr),
                                  ),
                                  DataColumn(
                                    label:
                                        TableHeaderText(text: 'Assigned To'.tr),
                                  ),
                                  DataColumn(
                                    label: TableHeaderText(text: 'Status'.tr),
                                  ),
                                ],
                                rows: snap!
                                    .map(
                                      (e) => DataRow(
                                        cells: [
                                          DataCell(Text(e.ticketNo.toString())),
                                          DataCell(Text(e.title.toString())),
                                          DataCell(
                                              Text(e.assignedTo.toString())),
                                          DataCell(Text(e.status.toString())),
                                        ],
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: 50,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  scaffoldKey.currentState?.openDrawer();
                                },
                                label: Text('Back'.tr),
                                icon: const Icon(
                                  Icons.arrow_circle_left_outlined,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: 50,
                              child: TextFormField(
                                initialValue: snap.length.toString(),
                                decoration: InputDecoration(
                                  labelText: 'Total Tickets'.tr,
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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
