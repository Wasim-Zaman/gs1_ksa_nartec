// ignore_for_file: file_names, avoid_print

import 'dart:convert';

import 'package:gs1_v2_project/models/login-models/gln_product_model.dart';
import 'package:gs1_v2_project/utils/url.dart';
import 'package:http/http.dart' as http;

class GLNController {
  static Future<List<GLNProductsModel>> getData(String userId) async {
    String url = "${BaseUrl.gs1}/api/member/gln/list";

    final uri = Uri.parse(url);

    final body = {"user_id": userId};

    final headers = <String, String>{
      "Content-Type": "application/json",
      "Authorization":
          "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IklyZmFuIiwiaWF0IjoxNTE2MjM5MDIyfQ.vx1SEIP27zyDm9NoNbJRrKo-r6kRaVHNagsMVTToU6A",
      "Host": BaseUrl.host,
      "Accept": "application/json"
    };

    try {
      var response =
          await http.post(uri, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        var listOfProducts = data['GlnProducts'] as List;
        List<GLNProductsModel> products =
            listOfProducts.map((e) => GLNProductsModel.fromJson(e)).toList();
        return products;
      } else {
        var data = json.decode(response.body);

        var msg = data['message'];
        throw Exception(msg);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
