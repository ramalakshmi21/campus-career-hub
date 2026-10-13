import 'package:flutter/material.dart';
import '../models/student_model.dart';
import '../data/demo_data.dart';
import '../services/storage_service.dart';
import '../utils/app_constants.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool _rememberMe = false;
  String? _errorMessage;
  Student? _currentStudent;

  bool get isAuthenticated => _isAuthenticated;
  bool get rememberMe => _rememberMe;
  String? get errorMessage => _errorMessage;
  Student? get currentStudent => _currentStudent;

  AuthProvider() {
    _checkSavedLogin();
  }

  void _checkSavedLogin() {
    final bool savedLogin = StorageService.getBool(StorageService.keyIsLoggedIn, defaultValue: false);
    if (savedLogin) {
      _isAuthenticated = true;
      _currentStudent = DemoData.initialStudent;
      notifyListeners();
    }
  }

  void setRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  bool login(String usernameOrEmail, String password) {
    final cleanInput = usernameOrEmail.trim().toLowerCase();
    final cleanPass = password.trim();

    if (cleanInput.isEmpty || cleanPass.isEmpty) {
      _errorMessage = 'Please enter both Student ID/Email and password';
      notifyListeners();
      return false;
    }

    final isEmailMatch = cleanInput == AppConstants.demoEmail.toLowerCase();
    final isIdMatch = cleanInput == AppConstants.demoStudentId.toLowerCase();
    final isPassMatch = cleanPass == AppConstants.demoPassword;

    // Support demo login or standard test inputs
    if ((isEmailMatch || isIdMatch || cleanInput.contains('demo') || cleanInput.contains('student')) &&
        (isPassMatch || cleanPass.length >= 6)) {
      _isAuthenticated = true;
      _currentStudent = DemoData.initialStudent;
      _errorMessage = null;

      if (_rememberMe) {
        StorageService.setBool(StorageService.keyIsLoggedIn, true);
        StorageService.setString(StorageService.keyStudentEmail, cleanInput);
      }
      notifyListeners();
      return true;
    } else {
      _errorMessage = 'Invalid credentials. Use Demo Login or check Student ID.';
      notifyListeners();
      return false;
    }
  }

  void demoLogin() {
    _isAuthenticated = true;
    _currentStudent = DemoData.initialStudent;
    _errorMessage = null;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    _currentStudent = null;
    _errorMessage = null;
    StorageService.remove(StorageService.keyIsLoggedIn);
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
