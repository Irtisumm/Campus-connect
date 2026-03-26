import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isAdmin = false;
  String? _userId;
  String? _userName;

  bool get isAuthenticated => _isAuthenticated;
  bool get isAdmin => _isAdmin;
  String? get userId => _userId;
  String? get userName => _userName;

  // Student accounts (can be expanded via registration approval)
  final Map<String, Map<String, String>> _studentAccounts = {
    'S001': {'password': 'pass123', 'name': 'Ahmad Rizwan'},
    'S002': {'password': 'pass123', 'name': 'Fatima Hassan'},
    'S003': {'password': 'pass123', 'name': 'Mohammad Ali'},
  };

  static const _adminAccounts = {
    'ADMIN001': {'password': 'admin123', 'name': 'Admin Panel'},
    'ADMIN002': {'password': 'admin123', 'name': 'Manager Account'},
  };

  Future<bool> login(String id, String password, bool isAdminLogin) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final accounts = isAdminLogin ? _adminAccounts : _studentAccounts;
    final account = accounts[id];

    if (account == null || account['password'] != password) {
      return false;
    }

    _isAuthenticated = true;
    _isAdmin = isAdminLogin;
    _userId = id;
    _userName = account['name'];
    notifyListeners();
    return true;
  }

  void logout() {
    _isAuthenticated = false;
    _isAdmin = false;
    _userId = null;
    _userName = null;
    notifyListeners();
  }

  void switchRole(String id, String password, bool toAdmin) async {
    logout();
    await Future.delayed(const Duration(milliseconds: 300));
    await login(id, password, toAdmin);
  }

  // Register a new student account (after admin approval, the account gets added)
  void addApprovedStudent(String studentId, String password, String name) {
    _studentAccounts[studentId] = {'password': password, 'name': name};
    notifyListeners();
  }

  // Check if a student ID is already taken
  bool isStudentIdTaken(String studentId) {
    return _studentAccounts.containsKey(studentId);
  }
}
