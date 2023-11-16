import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gs1_v2_project/models/product_contents_list_model.dart';
import 'package:gs1_v2_project/utils/url.dart';
import 'package:http/http.dart' as http;

class BaseApiService {
  static ProductContentsListModel? myData;

  static Future<ProductContentsListModel> getData(BuildContext context,
      {String? gtin}) async {
    final http.Response response = await http.post(
        Uri.parse("${BaseUrl.gs1}/api/search/member/gtin"),
        body: json.encode({"gtin": gtin}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Host': BaseUrl.host,
        });

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
      final responseData = body['gtinArr'];
      myData = ProductContentsListModel.fromJson(responseData);
      return myData!;
    }
    return myData!;
  }
}
