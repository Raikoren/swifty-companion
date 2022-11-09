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
  ImageProvider userPfp = Image.asset("ressources/logo.png", height: 40).image;
  late Map user;
  late List<Widget> pages;
  late double level;
  late List<Map<String, dynamic>> projects;
  bool loading = true;
  int _selectedItem = 0;

  @override
  Future<void> load() async {
    final Map userResponse = await IntraApi.instance.getUser(widget.login);
    final ImageProvider img = await IntraApi.instance.getUserPfp(userResponse['image']['versions']['medium']);
    setState(() {
      user = userResponse;
      userPfp = img;
      loading = false;
    });
  }

  Future<void> refreshUser() async {
    setState(() => loading = true);
    final Map userRefreshed = await IntraApi.instance.getUser(widget.login);
    setState(() {
      user = userRefreshed;
      loading = false;
    });
  }

  double getLvl(Map last) {
    var res = last['level'] - last['level'].floor();
    return res;
  }

  @override
  Widget build(BuildContext context) {
    if (loading == true) {
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
              ),
            ),
          ],
        )
      );
    } else {
      level = getLvl(user['cursus_users'].last);
      pages = <Widget>[
        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 8),
              child: Center(
                child: CircleAvatar(
                    backgroundColor: Colors.deepOrange,
                    radius: 105,
                    child: CircleAvatar(
                      backgroundImage: userPfp,
                      radius: 100,
                    )
                ),
              )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: LinearProgressIndicator(
                value: level,
                semanticsLabel: user['cursus_users'].last['level'].toString(),
                minHeight: 20.0,
              )
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                    child: Text("${user['first_name']} ${user['last_name']} aka ${widget.login}", style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold
                    ),)
                )),
            Center(
              child: Text("level: ${user['cursus_users'].last['level']}\nmail: ${user['email']}\nlocation: ${user['location'] ?? "not connected"}\nwallet: ${user['wallet']}\ncorrection point: ${user['correction_point']}"),
            )
          ],
        ),
        Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: () {
                if (user['projects_users'].isEmpty) {
                  return <Widget> [
                    const Center(child: Text('No project were found for this user.'))
                  ];
                } else {
                  return <Widget> [
                    for(Map project in user['projects_users'])
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child: () {
                          late String title;
                          late IconData icon;
                          late Color color;

                          if (project['status'] == "finished") {
                            title = "${project['project']['name']}\n${project['final_mark']}/100";
                            if (project['validated?'] == true) {
                              color = Colors.lightGreenAccent;
                              icon = Icons.check;
                            } else {
                              color = Colors.redAccent;
                              icon = Icons.cancel;
                            }
                          } else {
                            color = Colors.white54;
                            icon = Icons.watch_later;
                            title = "${project['project']['name']}: ${project['status']}";
                          }
                          return ListTile(
                            title: Text(title, style: TextStyle(color: color)),
                            trailing: Icon(icon, color: color,),
                          );
                        }(),
                      ),
                  ];
                }
              }()
            ),
          )
        )
      ];
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
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_added_rounded),
              label: 'Projects',
            )
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