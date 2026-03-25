import 'package:flutter/material.dart';
import 'auth_service.dart';

class AppState extends ChangeNotifier {
  late AuthService _authService;

  bool get isAuthenticated => _authService.isAuthenticated;
  bool get isAdmin => _authService.isAdmin;
  String? get userId => _authService.userId;

  AppState() {
    _authService = AuthService();
  }

  Future<bool> loginUser(String id, String password, bool isAdmin) async {
    return await _authService.login(id, password, isAdmin);
  }

  void logout() {
    _authService.logout();
    notifyListeners();
  }

  Future<bool> switchRole(String id, String password, bool toAdmin) async {
    final result = await _authService.login(id, password, toAdmin);
    if (result) notifyListeners();
    return result;
  }
}
