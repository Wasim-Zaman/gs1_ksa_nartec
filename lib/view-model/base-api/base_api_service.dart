import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gs1_v2_project/models/product_contents_list_model.dart';
import 'package:gs1_v2_project/utils/url.dart';
import 'package:http/http.dart' as http;

class BaseApiService {
  static Future<ProductContentsListModel> getData(BuildContext context,
      {required String gtin}) async {
    ProductContentsListModel myData = ProductContentsListModel();
    final http.Response response = await http.post(
        Uri.parse("${BaseUrl.gs1}/api/search/member/gtin"),
        body: json.encode({"gtin": gtin}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Host': BaseUrl.host,
        });
    print(gtin);
    log(response.body);
    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
      final responseData = body['gtinArr'];
      // if responseData is of type list
      if (responseData is List) {
        return myData;
      }
      myData = ProductContentsListModel.fromJson(responseData);
      return myData;
    }
    return myData;
  }
}
