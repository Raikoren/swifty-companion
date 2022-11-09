import 'package:flutter/material.dart';
import 'package:swifty/intra-api.dart';
import 'package:swifty/search-view.dart';

class LoginView extends StatefulWidget {
  const LoginView({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String _tokenInfo = 'Waiting...';

  void _initOAuth() async {
    var tokenResp = await IntraApi.instance.getToken();
    setState(() {
      _tokenInfo = tokenResp.toString();
    });
  }

  @override
  void initState() {
    super.initState();

    _initOAuth();
  }

  @override
  Widget build(BuildContext context) {
    if (_tokenInfo != 'Waiting...') {
      return const SearchView();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('OAuth'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Token Info: ' + _tokenInfo),
      ),
    );
  }
}