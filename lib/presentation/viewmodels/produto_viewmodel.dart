import 'package:app_loja_frontend/data/models/item_venda.dart';
import 'package:flutter/material.dart';
import '../../data/models/produto_model.dart';
import '../../data/repository/produto_repository.dart';


class ProdutoViewModel with ChangeNotifier {
  final ProdutoRepository _produtoRepository;
  List<Produto> _produtos = [];
  final List<ItemVenda> _carrinho = [];
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
  List<ItemVenda> get carrinho => _carrinho;
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
  // print('Carregando página: $pagina');
  if (pagina <= 0 || pagina > _totalPaginas || _isLoadingMore) return;

  _paginaAtual = pagina;
  _isLoadingMore = true;
  notifyListeners();

  try {
    var resposta = await _produtoRepository.fetchProdutos(page: _paginaAtual);
    // print('Produtos carregados: ${resposta['produtos']}');
    if (pagina == 1) {
      _produtos = resposta['produtos'];
    } else {
      _produtos.addAll(resposta['produtos']);
    }
    _temMaisPaginas = resposta['nextPage'] != null;
    // print('Tem mais páginas: $_temMaisPaginas');
  } catch (e) {
    _errorMessage = 'Erro ao carregar produtos: $e';
    // print(_errorMessage);
  }

  _isLoadingMore = false;
  notifyListeners();
}

  /// Adiciona um produto ao carrinho como um ItemVenda
  void adicionarAoCarrinho(Produto produto) {
    // Verifica se o produto já está no carrinho
    final itemExistente = _carrinho.firstWhere(
      (item) => item.produtoId == produto.id,
      orElse: () => ItemVenda(
        produtoId: -1,
        quantidade: 0,
        precoUnitario: 0,
        produtoNome: '',
      ),
    );

    if (itemExistente.produtoId != -1) {
      // Se o produto já está no carrinho, aumenta a quantidade
      itemExistente.quantidade += 1;
    } else {
      // Se não está no carrinho, adiciona um novo ItemVenda
      _carrinho.add(
        ItemVenda(
          produtoId: produto.id,
          quantidade: 1, // Quantidade inicial
          precoUnitario: produto.preco,
          produtoNome: produto.nome,
        ),
      );
    }
    notifyListeners();
  }

  /// Remove um item do carrinho
  void removerDoCarrinho(ItemVenda item) {
    _carrinho.remove(item);
    notifyListeners();
  }

  /// Atualiza a quantidade de um item no carrinho
  void atualizarQuantidade(ItemVenda item, int novaQuantidade) {
    if (novaQuantidade <= 0) {
      removerDoCarrinho(item); // Remove o item se a quantidade for 0 ou negativa
    } else {
      item.quantidade = novaQuantidade;
      notifyListeners();
    }
  }

  /// Limpa o carrinho
  void limparCarrinho() {
    _carrinho.clear();
    notifyListeners();
  }
}
