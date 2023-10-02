import 'dart:convert';

import 'package:gs1_v2_project/models/member-registration/documents_model.dart';
import 'package:gs1_v2_project/utils/url.dart';
import 'package:http/http.dart' as http;

class DocumentServices {
  static const String url = ("${BaseUrl.gs1}/api/documents");

  static Future<List<DocumentsModel>> getDocuments() {
    return http.get(Uri.parse(url)).then((response) {
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body) as List;
        final List<DocumentsModel> documents = responseBody
            .map((document) => DocumentsModel.fromJson(document))
            .toList();
        return documents;
      } else {
        throw Exception('Failed to load documents');
      }
    });
  }
}
