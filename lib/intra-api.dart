import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

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
    urlBase = url42;
  }

  factory IntraApi() {
    return instance;
  }

  getToken() async {
    final res = await http.post(Uri.parse("https://$urlBase/oauth/token"), body: {
      "grant_type": "client_credentials",
      "client_id":
      uid,
      "client_secret":
      secret
    });

    tkn = jsonDecode(res.body)["access_token"];
    return res;
  }

  getUser(String login) async {
    http.Response resp = await http.get(Uri.https(urlBase, "/v2/users/$login"), headers: {
      "Authorization": "bearer $tkn",
    });
    switch (resp.statusCode) {
      case 200 : return jsonDecode(resp.body);
      case 401 : {
        getToken();
        await Future.delayed(const Duration(seconds: 1));
        return getUser(login);
      }
      case 404 : throw Exception("User not found");
      default: throw Exception("Error retrieving user");
    }
  }

  Future<ImageProvider> getUserPfp(String link) async {
    final ImageProvider pfp = Image.network(link).image;

    return pfp;
  }
}
