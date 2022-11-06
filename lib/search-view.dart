import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final loginInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            Navigator.pushNamed(context,'/');
          },
          child: Image.asset("ressources/logo.png", height: 40),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/");
            },
            icon: const Icon(Icons.info_outline))
        ],
      ),
      body: Column(
        children: <Widget>[
          // Premier Widget, un simple texte
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 8),
            child: Text("Looking for someone ?", style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold),
            ),
          ),
          // Deuxieme Widget, le TextField à remplir avec le login
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter a login',
              ),
              controller: loginInput,
              textInputAction: TextInputAction.search,
              inputFormatters: [ FilteringTextInputFormatter(RegExp(r'[a-z\-]'), allow: true) ],
              enableSuggestions: true,
              onSubmitted: (String login) {
                if (login.isNotEmpty) {
                  Navigator.pushNamed(context, '/user', arguments: login);
                }
              },
            ),
          ),
          // Troisième Widget, le button pour démarrer la recherche
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.search),
              label: const Text("Search"),
              onPressed: () {
                if (loginInput.text.isNotEmpty) {
                  Navigator.pushNamed(context, "/user", arguments: loginInput.text.toLowerCase());
                  loginInput.clear();
                }
              }
            ),
          )
        ],
      )
    );
  }
}