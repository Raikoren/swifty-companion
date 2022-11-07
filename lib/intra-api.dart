import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2_client/oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';

class IntraApi {
  late String urlBase;
  late String uid;
  late String secret;
  late String tkn;
  static final IntraApi instance = IntraApi._internal();

  IntraApi._internal();

  initValues(String uid, String secret, String url42) {
    this.uid = uid;
    this.secret = secret;
    this.urlBase = url42;
  }

  factory IntraApi() {
    return instance;
  }

  getToken() async {
    final res = await http.post(Uri.parse("https://$urlBase/oauth/token"), body: {
      "grant_type": "client_credentials",
      "client_id":
      "$uid",
      "client_secret":
      "$secret"
    });

    tkn = jsonDecode(res.body)["access_token"];
    return res;
  }

  checkToken() async {
    http.Response response = await http.get(Uri.https(urlBase, '/v2/oauth/token/info'), headers: {
      "Authorization": "bearer $tkn",
    });
    (response.isRedirect) ? getToken() : 0;
  }

  getUser(String login) async {
    checkToken();
    http.Response resp = await http.get(Uri.https(urlBase, "/v2/users/$login"), headers: {
      "Authorization": "bearer $tkn",
    });
    switch (resp.statusCode) {
      case 200 : return jsonDecode(resp.body);
      case 404 : throw Exception("User not found");
      default: throw Exception("Error retrieving user");
    }
  }

  Future<ImageProvider> getUserPfp(Map user) async {
    final String url = user['image_url'];
    final ImageProvider pfp = Image.network(url).image;

    return pfp;
  }
}
