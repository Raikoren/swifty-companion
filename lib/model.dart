import 'dart:convert';

class User {
  final String login;
  final String fname;
  final String lname;
  final String mail;
  final String pfp;
  final String title;

  User({
    required this.login,
    required this.fname,
    required this.lname,
    required this.mail,
    required this.pfp,
    required this.title,
  });



  factory User.toObject(Map<String, dynamic> file) {
    // Récupération et parsing pour avoir le titre du login
    final String title = () {
      if (file["titles_user"] != null && (file["titles_user"] as List).isNotEmpty) {
        final selectedTitle = file["titles_user"].firstWhere((_) => _["selected"] == true);
        if (selectedTitle) {
          final int titleId = file["titles_users"].firstWhere((_) => _["selected"] == true)["title_id"];
          final String realTitle = file["titles"].firstWhere((_) => _["id"] == titleId);
          return selectedTitle;
        }
      }
      return "";
    }();

    //Builder
    User user =User(
        login: file["login"],
        fname: file["first_name"],
        lname: file["last_name"],
        mail: file["email"],
        pfp: file["image_url"],
        title: title
    );

    return user;
  }

  @override
  String echo() {
    return "$login, A.K.A. $fname $lname";
  }
}