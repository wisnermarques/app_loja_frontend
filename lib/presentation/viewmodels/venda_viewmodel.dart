import 'package:flutter/material.dart';
import '../../data/models/venda.dart';
import '../../data/repository/venda_repository.dart';

class VendaViewModel with ChangeNotifier {
  final VendaRepository _vendaRepository;
  bool _isLoading = false;
  String? _errorMessage;
  List<Venda> _vendas = [];

  VendaViewModel(this._vendaRepository);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Venda> get vendas => _vendas;

  /// **Realiza uma venda**
  Future<bool> realizarVenda(String token, Venda venda) async {
    _setLoading(true);

    try {
      await _vendaRepository.cadastrarVenda(token, venda);
      _setLoading(false);
      return true; // Indica sucesso
    } catch (e) {
      _setError('Erro ao registrar venda: $e');
      return false; // Indica falha
    }
  }

  /// **Obtém as vendas de um cliente**
  Future<List<Venda>> obterVendasPorCliente(String token, int clienteId) async {
    _setLoading(true);

    try {
      _vendas = await _vendaRepository.getVendasPorCliente(token, clienteId);
      _setLoading(false);
      return _vendas;
    } catch (e) {
      _setError('Erro ao obter vendas do cliente: $e');
      return []; // Retorna uma lista vazia em caso de erro
    }
  }

    /// **Define o estado de carregamento e notifica os ouvintes**
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// **Define mensagens de erro e notifica os ouvintes**
  void _setError(String message) {
    _errorMessage = message;
    _isLoading = false;
    notifyListeners();
  }
}
