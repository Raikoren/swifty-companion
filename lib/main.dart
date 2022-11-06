import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swifty/intra-api.dart';
import 'package:swifty/login-view.dart';
import 'package:swifty/search-view.dart';
import 'package:swifty/user-view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final IntraApi intraApi = IntraApi();

    return MaterialApp(
        title: 'Flutter App',
        theme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: Colors.deepOrange,
            appBarTheme: const AppBarTheme(backgroundColor: Colors.deepOrange)
        ),
        onGenerateRoute: (RouteSettings routes) {
          switch( routes.name ) {
            case '/' : return CupertinoPageRoute(builder: (_) => LoginView(intraApi: intraApi), settings: routes);
            case '/user' : return CupertinoPageRoute(builder: (_) => UserView(intraApi: intraApi, login: routes.arguments as String), settings: routes);
            default : return CupertinoPageRoute(builder: (_) => const SearchView(), settings: routes);
          }
        }
    );
  }
}