import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swifty/intra-api.dart';
import 'package:swifty/login-view.dart';
import 'package:swifty/search-view.dart';
import 'package:swifty/user-view.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  IntraApi.instance.initValues(
      dotenv.env['CLIENT_ID']!, dotenv.env['CLIENT_SECRET']!, dotenv.env['URL']!);
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
            case '/' : return CupertinoPageRoute(builder: (_) => LoginView(), settings: routes);
            case '/user' : return CupertinoPageRoute(builder: (_) => UserView(login: routes.arguments as String), settings: routes);
            default : return CupertinoPageRoute(builder: (_) => const SearchView(), settings: routes);
          }
        }
    );
  }
}