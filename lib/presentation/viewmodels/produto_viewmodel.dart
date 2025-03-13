import 'package:flutter/material.dart';
import '../../data/models/produto_model.dart';
import '../../data/repository/produto_repository.dart';


class ProdutoViewModel with ChangeNotifier {
  final ProdutoRepository _produtoRepository;
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

  ProdutoViewModel(this._produtoRepository);

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
      var resposta = await _produtoRepository.fetchProdutos(page: _paginaAtual);
      _produtos = resposta['produtos'];

      // Verifica se há mais páginas
      _temMaisPaginas = resposta['nextPage'] != null;

      // Calcula o total de páginas (assumindo 10 produtos por página)
      int count = resposta['count'];
      int produtosPorPagina = 10;
      _totalPaginas = (count / produtosPorPagina).ceil();
    } catch (e) {
      _errorMessage = 'Erro ao carregar produtos: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  /// **Carrega mais produtos conforme a paginação**
  Future<void> carregarPagina(int pagina) async {
     _produtos = [];
  print('Carregando página: $pagina');
  if (pagina <= 0 || pagina > _totalPaginas || _isLoadingMore) return;

  _paginaAtual = pagina;
  _isLoadingMore = true;
  notifyListeners();

  try {
    var resposta = await _produtoRepository.fetchProdutos(page: _paginaAtual);
    print('Produtos carregados: ${resposta['produtos']}');
    if (pagina == 1) {
      _produtos = resposta['produtos'];
    } else {
      _produtos.addAll(resposta['produtos']);
    }
    _temMaisPaginas = resposta['nextPage'] != null;
    print('Tem mais páginas: $_temMaisPaginas');
  } catch (e) {
    _errorMessage = 'Erro ao carregar produtos: $e';
    print(_errorMessage);
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
}
