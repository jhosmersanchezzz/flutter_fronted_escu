import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  late String _token; // Variable para almacenar el token
  late int _userId; // Variable para almacenar el ID del usuario
  late String _username; // Variable para almacenar el nombre de usuario

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
