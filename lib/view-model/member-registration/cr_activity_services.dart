import 'dart:convert';

import 'package:gs1_v2_project/models/member-registration/activities_model.dart';
import 'package:gs1_v2_project/utils/url.dart';
import 'package:http/http.dart' as http;

class CrActivityServices {
  static Future<ActivitiesModel> addActivity({
    required String cr,
    required String activity,
    required int status,
  }) async {
    final String url = "${BaseUrl.gs1}/api/cr/add";
    var body = jsonEncode(
      {"cr": cr, "activity": activity, "status": status},
    );

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      var responseBody = jsonDecode(response.body);
      return ActivitiesModel.fromJson(responseBody['data']);
    } else if (response.statusCode == 400) {
      throw Exception("Activity | CR already exists");
    } else {
      throw Exception("Failed to add activity");
    }
  }
}
