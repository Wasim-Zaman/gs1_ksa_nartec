import 'dart:convert';

import 'package:gs1_v2_project/models/member-registration/member_category_model.dart';
import 'package:gs1_v2_project/utils/url.dart';
import 'package:http/http.dart' as http;

class GetAllMemberCategoriesService {
  static List<MemberCategoryModel> futureData = [];
  static Future<List<MemberCategoryModel>> getList() async {
    const String url = '${BaseUrl.gs1}/api/GetAllMemberCategory';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body) as List;
      for (var element in responseBody) {
        futureData.add(MemberCategoryModel.fromJson(element));
      }
      return futureData;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
