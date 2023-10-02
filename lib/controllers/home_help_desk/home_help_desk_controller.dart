import 'dart:convert';

import 'package:gs1_v2_project/models/home/home_help_desk_model.dart';
import 'package:gs1_v2_project/utils/url.dart';
import 'package:http/http.dart' as http;

class HomeHelpDeskController {
  static Future<HomeHelpDeskModel> getHelpDeskData() async {
    final url = Uri.parse("${BaseUrl.gs1}/api/page/HelpDeskMe");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return HomeHelpDeskModel.fromJson(data['page']);
      } else {
        throw ("Something went wrong");
      }
    } catch (e) {
      if (e.toString().contains("SocketException")) {
        throw ("No Internet Connection");
      } else {
        throw ("Something went wrong");
      }
    }
  }
}
