import 'dart:convert';

import 'package:gs1_v2_project/models/member-registration/get_all_states_model.dart';
import 'package:gs1_v2_project/utils/url.dart';
import 'package:http/http.dart' as http;

class GetAllStatesServices {
  static List<GetAllStatesModel> futureData = [];
  static Future<List<GetAllStatesModel>> getList(int countryId) async {
    const String url = '${BaseUrl.gs1}/api/states/by/country';
    final response = await http.post(Uri.parse(url),
        body: json.encode({
          "country_id": countryId,
        }),
        headers: {
          'Content-Type': 'application/json',
        });

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body)['states'];
      for (var element in responseBody) {
        futureData.add(GetAllStatesModel.fromJson(element));
      }
      return futureData;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
