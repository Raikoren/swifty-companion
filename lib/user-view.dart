import 'package:flutter/material.dart';
import 'package:loader/loader.dart';
import 'package:swifty/intra-api.dart';

class UserView extends StatefulWidget {
  final String login;

  const UserView({Key? key, required this.login}) : super(key: key);

  @override
  State<UserView> createState() => _UserViewState();
}


class _UserViewState extends State<UserView> with LoadingMixin<UserView>{
  late ImageProvider userPfp;
  late Map user;
  bool loading = true;
  int _selectedItem = 0;

  @override
  Future<void> load() async {
    final Map userResponse = await IntraApi.instance.getUser(widget.login);
    final ImageProvider img = await IntraApi.instance.getUserPfp(user);
    setState(() {
      user = userResponse;
      userPfp = img;
    });
  }

  Future<void> refreshUser() async {
    setState(() => loading = true);
    load();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String login = widget.login;
    List<Widget> pages = <Widget>[
      Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 8),
            child: Center(
              child: Image(
                image: userPfp,
                height: 150,
              ),
            )
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 8),
            child: Text("$login aka ${user['first_name']} ${user['last_name']} who you can contact via mail ${user['email']}", style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold
            ),)
          ),
        ],
      ),
    ];
    if (loading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.login),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
      // hasError vient de  LoadingMixin
    } else if (hasError) {
      return Scaffold(
          appBar: AppBar(
            title: Text(widget.login),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            crossAxisAlignment: CrossAxisAlignment.start, // Align to left
            children: <Widget>[
              Center(
                child: Text("User ${widget.login} not found."),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Go back'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                  ),
                ),
              ),
            ],
          )
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.login),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => refreshUser(),
            ),
          ]
        ),
        body: Center(child: pages.elementAt(_selectedItem)),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Calls',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_boat),
              label: 'Camera',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.commit),
              label: 'Chats',
            ),
          ],
          onTap: _onItemTapped,
          currentIndex: _selectedItem,
        ),
      );
    }
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedItem= index;
    });
  }

}