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
    final result = await _authService.login(id, password, isAdmin);
    if (result) notifyListeners();
    return result;
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

  // Register a new student account (called after admin approval)
  void addApprovedStudent(String studentId, String password, String name) {
    _authService.addApprovedStudent(studentId, password, name);
  }

  bool isStudentIdTaken(String studentId) {
    return _authService.isStudentIdTaken(studentId);
  }
}
