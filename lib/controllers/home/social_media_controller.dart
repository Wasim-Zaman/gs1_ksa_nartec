import 'dart:convert';

import 'package:gs1_v2_project/models/home/social_media_model.dart';
import 'package:gs1_v2_project/utils/url.dart';
import 'package:http/http.dart' as http;

class SocialMediaController {
  static Future<SocialMediaModel> getSocialMedias() async {
    final url = Uri.parse("${BaseUrl.gs1}/api/social/links");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return SocialMediaModel.fromJson(body);
      } else {
        throw "Something went wrong";
      }
    } catch (error) {
      if (error.toString() ==
          "SocketException: Failed host lookup: 'gs1eg.org' (OS Error: No address associated with hostname, errno = 7)") {
        throw "No Internet Connection";
      } else {
        throw "Something went wrong";
      }
    }
  }
}
