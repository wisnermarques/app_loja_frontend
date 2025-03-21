import 'package:flutter/material.dart';

import '../../data/models/cliente_model.dart';
import '../../data/repository/cliente_repository.dart';


class ClienteViewModel extends ChangeNotifier {
  final ClienteRepository clienteRepository;
  Cliente? _cliente;
  bool _isLoading = false;
  String? _errorMessage;

  ClienteViewModel(this.clienteRepository);

  Cliente? get cliente => _cliente;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Método para registrar um novo cliente
  Future<void> registerCliente(Cliente cliente, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await clienteRepository.registerCliente(cliente, password);
      _cliente = cliente;
    } catch (e) {
      _errorMessage = 'Erro ao registrar cliente: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Método para buscar cliente pelo username
  Future<void> fetchCliente(String token, String username) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _cliente = await clienteRepository.getClientePorUsername(token, username);
    } catch (e) {
      _errorMessage = 'Erro ao buscar cliente: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
