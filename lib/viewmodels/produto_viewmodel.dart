import 'package:flutter/material.dart';
import '../models/produto_model.dart';
import '../services/api_service.dart';

class ProdutoViewModel with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Produto> _produtos = [];
  final List<Produto> _carrinho = [];
  bool _isLoading = false;
  bool _isLoadingMore = false; // Indica se está carregando mais produtos
  String? _token;
  String? _username;
  String? _errorMessage;

  int _paginaAtual = 1; // Página inicial
  bool _temMaisPaginas = true; // Indica se há mais páginas para carregar
  int _totalPaginas = 1; // Total de páginas, ajustado conforme a resposta da API

  List<Produto> get produtos => _produtos;
  List<Produto> get carrinho => _carrinho;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get isLoggedIn => _token != null;
  String? get username => _username;
  String? get errorMessage => _errorMessage;
  bool get temMaisPaginas => _temMaisPaginas;
  int get paginaAtual => _paginaAtual;
  int get totalPaginas => _totalPaginas;

  /// **Carrega os produtos iniciais**
  Future<void> carregarProdutos() async {
    _isLoading = true;
    _paginaAtual = 1;
    _temMaisPaginas = true;
    _errorMessage = null;
    notifyListeners();

    try {
      var resposta = await _apiService.getProdutos(page: _paginaAtual);
      _produtos = resposta['produtos']; // Ajuste para a chave 'produtos'

      // Verifica se há mais páginas
      _temMaisPaginas = resposta['nextPage'] != null;

      // Calcula o total de páginas (assumindo 10 produtos por página)
      int count = resposta['count']; // Ajuste conforme a API
      int produtosPorPagina = 10; // Defina conforme sua API
      _totalPaginas = (count / produtosPorPagina).ceil(); // Arredonda para cima
    } catch (e) {
      _errorMessage = 'Erro ao carregar produtos: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  /// **Carrega mais produtos conforme a paginação**
  Future<void> carregarPagina(int pagina) async {
    if (pagina <= 0 || pagina > _totalPaginas || _isLoadingMore) return;

    _paginaAtual = pagina;
    _isLoadingMore = true;
    notifyListeners();

    try {
      var resposta = await _apiService.getProdutos(page: _paginaAtual);
      if (pagina == 1) {
        _produtos = resposta['produtos']; // Ajuste para a chave 'produtos'
      } else {
        _produtos.addAll(resposta['produtos']); // Ajuste para a chave 'produtos'
      }
      _temMaisPaginas = resposta['nextPage'] != null;
    } catch (e) {
      _errorMessage = 'Erro ao carregar produtos: $e';
    }

    _isLoadingMore = false;
    notifyListeners();
  }

  /// **Adiciona um produto ao carrinho**
  void adicionarAoCarrinho(Produto produto) {
    _carrinho.add(produto);
    notifyListeners();
  }

  /// **Remove um produto do carrinho**
  void removerDoCarrinho(Produto produto) {
    _carrinho.remove(produto);
    notifyListeners();
  }

  /// **Limpa o carrinho**
  void limparCarrinho() {
    _carrinho.clear();
    notifyListeners();
  }

  /// **Realiza o login e armazena o token**
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _token = await _apiService.login(username, password);
      _username = username;
      notifyListeners();
      return true;
    } catch (e) {
      _token = null;
      _username = null;
      _errorMessage = 'Erro ao fazer login: Credenciais inválidas';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// **Realiza o logout**
  void logout() {
    _token = null;
    _username = null;
    _carrinho.clear();
    notifyListeners();
  }
}