import 'dart:convert';

import 'package:gs1_v2_project/models/login-models/profile/subscription_list_model.dart';
import 'package:gs1_v2_project/models/login-models/subscription_model.dart';
import 'package:gs1_v2_project/utils/url.dart';
import 'package:http/http.dart' as http;

class SubscriptionListServices {
  static Future<SubscriptionModel> getSubscription(int userId) async {
    const String url = "${BaseUrl.gs1}/api/member/subscription";

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          "user_id": userId,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Host': BaseUrl.host,
        },
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return SubscriptionModel.fromJson(body);
      } else {
        throw Exception('Unable to fetch member subscription');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<SubscriptionListModel> getSubscriptionList(int userId) async {
    const String url = "${BaseUrl.gs1}/api/member/subscription/list";

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          "user_id": userId,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Host': BaseUrl.host,
        },
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return SubscriptionListModel.fromJson(body);
      } else {
        throw Exception('Unable to fetch member subscription');
      }
    } catch (e) {
      rethrow;
    }
  }
}
