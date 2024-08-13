import 'package:flutter/foundation.dart';

class UseUser extends ChangeNotifier {
  String _userName = '植田 雄太';
  String _userEmail = 'yuta.ueda.fromosaka@gmail.com';

  get userName => _userName;

  get userEmail => _userEmail;

  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }
}
