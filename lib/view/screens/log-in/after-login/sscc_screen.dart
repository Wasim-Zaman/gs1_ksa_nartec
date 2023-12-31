import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gs1_v2_project/models/login-models/dashboard_model.dart';
import 'package:gs1_v2_project/view-model/login/after-login/sscc_services.dart';
import 'package:gs1_v2_project/view/screens/log-in/widgets/text_widgets/table_header_text.dart';
import 'package:gs1_v2_project/widgets/custom_drawer_widget.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SSCCScreen extends StatefulWidget {
  const SSCCScreen({super.key});
  static const String routeName = 'sscc-screen';

  @override
  State<SSCCScreen> createState() => _SSCCScreenState();
}

class _SSCCScreenState extends State<SSCCScreen> {
  final scaffodKey = GlobalKey<ScaffoldState>();
  @override
  void dispose() {
    super.dispose();
    scaffodKey.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map;
    final response = args['response'] as DashboardModel;
    final userId = args['userId'];
    return WillPopScope(
      onWillPop: () async {
        scaffodKey.currentState?.openDrawer();
        return false;
      },
      child: Scaffold(
        key: scaffodKey,
        drawer: CustomDrawerWidget(
          userId: response.memberData?.user?.id ?? userId,
          response: response,
        ),
        appBar: AppBar(
          title: Text("Member SSCC".tr),
          elevation: 0,
        ),
        body: FutureBuilder(
          future: SSCCServices.getSSCC(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.threeArchedCircle(
                  color: Theme.of(context).primaryColor,
                  size: 70,
                ),
              );
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Something Went Wrong'.tr),
                        TextButton(
                          onPressed: () {
                            setState(() {});
                          },
                          child: Text(
                            'Retry'.tr,
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            }

            final snap = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                          dataRowColor:
                              MaterialStateProperty.resolveWith<Color>(
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
                              label: TableHeaderText(text: 'GCP GLNID'.tr),
                            ),
                            DataColumn(
                              label: TableHeaderText(
                                  text: 'SSCC Barcode Number'.tr),
                            ),
                            DataColumn(
                              label: TableHeaderText(text: 'SSCC Type'.tr),
                            ),
                          ],
                          rows: snap!
                              .map(
                                (e) => DataRow(
                                  cells: [
                                    DataCell(Text(e.gcpGLNID.toString())),
                                    DataCell(
                                        Text(e.sSCCBarcodeNumber.toString())),
                                    DataCell(Text(e.ssccType.toString())),
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
            );
          },
        ),
      ),
    );
  }
}
