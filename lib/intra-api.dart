import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2_client/oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:swifty/model.dart';

class IntraApi {
  final String urlBase = "api.intra.42.fr";
  late final OAuth2Helper _oAuth2Helper;
  late String tkn;

  final OAuth2Client session = OAuth2Client(
    authorizeUrl: 'https://api.intra.42.fr/oauth/authorize',
    tokenUrl: 'https://api.intra.42.fr/oauth/token',
    // Si un jour je trouve comment bein redirect je l'utiliserai pour get token
    redirectUri: 'my.app:/',
    customUriScheme: 'my.app',
  );

  IntraApi() {
    _oAuth2Helper = OAuth2Helper(
      session,
      grantType: OAuth2Helper.authorizationCode,
      clientId: 'u-s4t2ud-dd96f8e2b8b1c668fc4ae3a1dde89dc8829b3e95353bd0ede86257bef450ac58',
      clientSecret: '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',
      scopes: ['public', 'profile', 'projects'],
    );
  }

  getToken() async {
    final res = await http.post(Uri.parse(session.tokenUrl), body: {
      "grant_type": "client_credentials",
      "client_id":
      "u-s4t2ud-dd96f8e2b8b1c668fc4ae3a1dde89dc8829b3e95353bd0ede86257bef450ac58",
      "client_secret":
      "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"
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
      case 200 : return User.toObject(jsonDecode(resp.body));
      case 404 : throw Exception("User not found");
      default: throw Exception("Error retrieving user");
    }
  }

  Future<ImageProvider> getUserPfp(User user) async {
    final List<String> split = user.pfp.split("/");
    final String last = split.removeLast();
    final String mediumUrl = split.join("/") + "/medium_" + last;

    http.Response r = await http.get(Uri.parse(mediumUrl));
    if (r.statusCode == 200) {
      return MemoryImage(r.bodyBytes);
    } else {
      r = await http.get(Uri.parse(mediumUrl));
      if (r.statusCode == 200) {
        return MemoryImage(r.bodyBytes);
      } else {
        return const NetworkImage("https://cdn.intra.42.fr/users/medium_default.jpg");
      }
    }
  }
}
