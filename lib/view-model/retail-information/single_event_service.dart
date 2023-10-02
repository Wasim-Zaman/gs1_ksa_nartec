import 'dart:convert';

import 'package:gs1_v2_project/models/single_event_model.dart';
import 'package:gs1_v2_project/utils/url.dart';
import 'package:http/http.dart' as http;

class SingleEventService {
  static Future<List<SingleEventModel>> getFutureData(String trxGLNIDTo) async {
    List<SingleEventModel> futureData = [];

    final response = await http.post(
      Uri.parse(URL.singleEvent),
      body: json.encode(
        {
          "GLNID_TO": trxGLNIDTo,
        },
      ),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Host": "gtrack.info",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
      final responseData = body['signleEvent'] as List;
      for (var element in responseData) {
        futureData.add(SingleEventModel.fromJson(element));
      }
      return futureData;
    } else {
      return futureData;
    }
  }
}
