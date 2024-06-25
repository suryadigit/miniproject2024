import 'package:flutter/material.dart';

class UserController extends ChangeNotifier {
  String? _userEmail;

  String? get userEmail => _userEmail;

  void loginUser(String email) {
    _userEmail = email;
    notifyListeners();
  }

  void logoutUser() {
    _userEmail = null;
    notifyListeners();
  }
}
