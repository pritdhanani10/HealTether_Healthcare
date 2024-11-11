import 'package:app/models/user.dart';
import 'package:app/services/UserService.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  List<User> _users = [];
  bool _loading = true;
  String _errorMessage = '';

  List<User> get users => _users;
  bool get loading => _loading;
  String get errorMessage => _errorMessage;

  final UserService _userService = UserService();

  UserProvider() {
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      _loading = true;
      _errorMessage = '';
      notifyListeners();

      _users = await _userService.fetchUsers();
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
