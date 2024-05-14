import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  late String _token;
  late int _userId;
  late String _username;

  AuthProvider() {
    _token = '';
    _userId = 0;
    _username = '';
  }

  String get token => _token;
  int get userId => _userId;
  String get username => _username;

  void setToken(String token) {
    _token = token;
    notifyListeners();
  }

  void setUserId(int userId) {
    _userId = userId;
    notifyListeners();
  }

  void setUsername(String username) {
    _username = username;
    notifyListeners();
  }
}
