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
      _notifyListenersAfterBuild();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    _notifyListenersAfterBuild();

    try {
      _token = await _userRepository.login(username, password);
      _username = username;
      _notifyListenersAfterBuild();
      return true;
    } on Exception catch (e) {
      _token = null;
      _username = null;
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      _notifyListenersAfterBuild();
    }
  }

  void logout() {
    _token = null;
    _username = null;
    _errorMessage = null;
    _notifyListenersAfterBuild();
  }

  void clearErrorMessage() {
    _errorMessage = null;
    _notifyListenersAfterBuild();
  }

  Future<Map<String, dynamic>?> fetchClienteData() async {
    if (_token == null || _username == null) {
      _errorMessage = 'Usuário não está logado.';
      _notifyListenersAfterBuild();
      return null;
    }

    _isLoading = true;
    _notifyListenersAfterBuild();

    try {
      Map<String, dynamic> clienteData =
          await _userRepository.getClientePorUsername(_token!, _username!);

      return clienteData;
    } catch (e) {
      _errorMessage = e.toString();
      _notifyListenersAfterBuild();
      return null;
    } finally {
      _isLoading = false;
      _notifyListenersAfterBuild();
    }
  }

  Future<int?> getClienteId() async {
    if (_token == null || _username == null) {
      _errorMessage = 'Usuário não está logado.';
      _notifyListenersAfterBuild();
      print("Erro: Usuário não está logado."); // Debug
      return null;
    }

    _isLoading = true;
    _notifyListenersAfterBuild();
    print("Buscando clienteId para $_username..."); // Debug

    try {
      Map<String, dynamic> clienteData =
          await _userRepository.getClientePorUsername(_token!, _username!);

      print("Dados do cliente recebidos: $clienteData"); // Debug

      if (clienteData.containsKey('id')) {
        int clienteId = clienteData['id'];
        print("Cliente ID encontrado: $clienteId"); // Debug
        return clienteId;
      } else {
        print("Erro: 'id' não encontrado nos dados retornados."); // Debug
        return null;
      }
    } catch (e) {
      _errorMessage = 'Erro ao buscar clienteId: $e';
      print("Erro ao buscar clienteId: $e"); // Debug
      _notifyListenersAfterBuild();
      return null;
    } finally {
      _isLoading = false;
      _notifyListenersAfterBuild();
    }
  }

  void _notifyListenersAfterBuild() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}
