import 'package:flutter/material.dart';
import '../models/produto_model.dart';
import '../services/api_service.dart';

class ProdutoViewModel with ChangeNotifier {
    final ApiService _apiService = ApiService();
    List<Produto> _produtos = [];
    bool _isLoading = false;

    List<Produto> get produtos => _produtos;
    bool get isLoading => _isLoading;

    Future<void> carregarProdutos() async {
        _isLoading = true;
        notifyListeners();

        try {
            _produtos = await _apiService.getProdutos();
            print('Produtos carregados: $_produtos');  // Debug
        } catch (e) {
            print('Erro ao carregar produtos: $e');  // Debug
        }

        _isLoading = false;
        notifyListeners();
    }
}