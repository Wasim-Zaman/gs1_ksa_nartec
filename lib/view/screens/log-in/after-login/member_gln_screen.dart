import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gs1_v2_project/constants/colors/app_colors.dart';
import 'package:gs1_v2_project/controllers/login/gln/gln_controller.dart';
import 'package:gs1_v2_project/models/login-models/dashboard_model.dart';
import 'package:gs1_v2_project/models/login-models/gln_product_model.dart';
import 'package:gs1_v2_project/res/common/common.dart';
import 'package:gs1_v2_project/utils/app_dialogs.dart';
import 'package:gs1_v2_project/widgets/custom_drawer_widget.dart';

class MemberGLNScreen extends StatefulWidget {
  const MemberGLNScreen({super.key});
  static const String routeName = "/member-gln";

  @override
  State<MemberGLNScreen> createState() => _MemberGLNScreenState();
}

class _MemberGLNScreenState extends State<MemberGLNScreen> {
  // scaffold key
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<bool> isMarked = [];
  List<GLNProductsModel> table = [];

  List<double> longitude = [];
  List<double> latitude = [];

  double currentLat = 0;
  double currentLong = 0;

  // markers
  Set<Marker> markers = {};

  bool isLoaded = false;

  // args
  DashboardModel? response;
  int? userId;

  @override
  void initState() {
    Future.delayed(
      Duration.zero,
      () {
        final args = ModalRoute.of(context)!.settings.arguments as Map;
        response = args['response'] as DashboardModel;
        userId = args['userId'];
        AppDialogs.loadingDialog(context);
        GLNController.getData(userId.toString()).then((value) {
          setState(() {
            isMarked = List.filled(value.length, true);
            table = value;
            latitude =
                value.map((e) => double.parse(e.latitude.toString())).toList();
            longitude =
                value.map((e) => double.parse(e.longitude.toString())).toList();

            currentLat = latitude[0];
            currentLong = longitude[0];

            // setting up markers
            markers = table.map((data) {
              return Marker(
                markerId: MarkerId(data.glnId.toString()),
                position: LatLng(
                  double.parse(data.latitude.toString()),
                  double.parse(data.longitude.toString()),
                ),
                // infoWindow: InfoWindow(
                //   snippet: data.locationNameAr.toString(),
                // ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: Text(data.locationNameEn.toString()),
                      title: Text(data.locationNameAr.toString()),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Close'.tr),
                        ),
                      ],
                    ),
                  );
                },
              );
            }).toSet();

            isLoaded = true;
          });
          AppDialogs.closeDialog();
        }).onError((error, stackTrace) {
          setState(() {
            isMarked = List.filled(0, false);
            table = [];
          });
          AppDialogs.closeDialog();
          Common.showToast(error.toString().replaceAll("Exception:", ""));
        });
      },
    );
    super.initState();
  }

  late GoogleMapController mapController;

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void dispose() {
    scaffoldKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        scaffoldKey.currentState?.openDrawer();
        return false;
      },
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('Member GLN'.tr),
          centerTitle: true,
        ),
        drawer: CustomDrawerWidget(
          userId: response?.memberData?.user?.id ?? userId,
          response: response,
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.primaryColor,
                      width: 1,
                    ),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        showCheckboxColumn: false,
                        dataRowColor: MaterialStateColor.resolveWith(
                            (states) => Colors.grey.withOpacity(0.2)),
                        headingRowColor: MaterialStateColor.resolveWith(
                            (states) => AppColors.primaryColor),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.primaryColor,
                            width: 1,
                          ),
                        ),
                        border: TableBorder.all(
                          color: Colors.black,
                          width: 1,
                        ),
                        columns: [
                          DataColumn(
                            label: Text(
                              'Select'.tr,
                              style: TextStyle(color: AppColors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          DataColumn(
                              label: Text(
                            'GLN Id'.tr,
                            style: TextStyle(color: AppColors.white),
                            textAlign: TextAlign.center,
                          )),
                          DataColumn(
                              label: Text(
                            'gcp GLNID'.tr,
                            style: TextStyle(color: AppColors.white),
                            textAlign: TextAlign.center,
                          )),
                          DataColumn(
                              label: Text(
                            'location Name En'.tr,
                            style: TextStyle(color: AppColors.white),
                            textAlign: TextAlign.center,
                          )),
                          DataColumn(
                              label: Text(
                            'location Name Ar'.tr,
                            style: TextStyle(color: AppColors.white),
                            textAlign: TextAlign.center,
                          )),
                          DataColumn(
                              label: Text(
                            'GLN Barcode Number'.tr,
                            style: TextStyle(color: AppColors.white),
                            textAlign: TextAlign.center,
                          )),
                          DataColumn(
                              label: Text(
                            'Status'.tr,
                            style: TextStyle(color: AppColors.white),
                            textAlign: TextAlign.center,
                          )),
                        ],
                        rows: table.map((e) {
                          return DataRow(
                              onSelectChanged: (value) async {},
                              cells: [
                                DataCell(
                                  Checkbox(
                                    fillColor: MaterialStateColor.resolveWith(
                                        (states) => AppColors.primaryColor),
                                    value: isMarked[table.indexOf(e)],
                                    onChanged: (value) {
                                      setState(() {
                                        isMarked[table.indexOf(e)] = value!;

                                        if (value == false) {
                                          // remove lat and long from list
                                          latitude.removeAt(table.indexOf(e));
                                          longitude.removeAt(table.indexOf(e));
                                          // remove marker from map
                                          markers.removeWhere((element) =>
                                              element.markerId ==
                                              MarkerId(e.glnId.toString()));
                                        } else {
                                          // add lat and long to the list
                                          latitude.add(double.parse(
                                              e.latitude.toString()));
                                          longitude.add(double.parse(
                                              e.longitude.toString()));
                                          // add marker to the map
                                          markers.add(Marker(
                                            markerId:
                                                MarkerId(e.glnId.toString()),
                                            position: LatLng(
                                              double.parse(
                                                  e.latitude.toString()),
                                              double.parse(
                                                  e.longitude.toString()),
                                            ),
                                            infoWindow: InfoWindow(
                                              snippet:
                                                  e.locationNameAr.toString(),
                                            ),
                                          ));
                                        }
                                      });
                                    },
                                  ),
                                ),
                                DataCell(Text(e.glnId.toString())),
                                DataCell(Text(e.gcpGLNID ?? '')),
                                DataCell(Text(e.locationNameEn ?? '')),
                                DataCell(Text(e.locationNameAr ?? '')),
                                DataCell(Text(e.gLNBarcodeNumber ?? '')),
                                DataCell(Text(e.status ?? '')),
                              ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.greyColor,
                      width: 1,
                    ),
                  ),
                  child: isLoaded == false
                      ? const SizedBox.shrink()
                      : GoogleMap(
                          onMapCreated: (GoogleMapController controller) {
                            mapController = controller;
                          },
                          initialCameraPosition: CameraPosition(
                            // with current position using geolocator
                            target: latitude.isEmpty
                                ? LatLng(currentLat, currentLong)
                                : LatLng(
                                    latitude[0],
                                    longitude[0],
                                  ),
                            zoom: -14,
                          ),
                          polylines: {
                            Polyline(
                              polylineId: const PolylineId('route1'),
                              color: AppColors.green,
                              width: 5,
                              points: [
                                for (int i = 0; i < latitude.length; i++)
                                  LatLng(latitude[i], longitude[i]),
                              ],
                            ),
                          },
                          markers: markers,
                          buildingsEnabled: true,
                          compassEnabled: true,
                          indoorViewEnabled: true,
                          mapToolbarEnabled: true,
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
