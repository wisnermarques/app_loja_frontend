import 'package:flutter/material.dart';
import '../../data/repository/user_repository.dart';

class UserViewModel with ChangeNotifier {
  final UserRepository _userRepository;

  String? _token;
  String? _username;
  String? _errorMessage;
  bool _isLoading = false;

  UserViewModel(this._userRepository);

  String? get token => _token;
  String? get username => _username;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _token != null;

  Future<bool> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      _errorMessage = 'Por favor, preencha todos os campos.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _token = await _userRepository.login(username, password);
      _username = username;
      notifyListeners();
      return true;
    } on Exception catch (e) {
      _token = null;
      _username = null;
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _token = null;
    _username = null;
    _errorMessage = null;
    notifyListeners();
  }

  void clearErrorMessage() {
    _errorMessage = null;
    notifyListeners();
  }
}