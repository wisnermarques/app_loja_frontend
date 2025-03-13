import '../../services/api_service.dart';
import '../models/produto_model.dart';

class ProdutoRepository {
  final ApiService apiService;

  ProdutoRepository(this.apiService);

  Future<Map<String, dynamic>> fetchProdutos({int page = 1}) async {
    try {
      return await apiService.getProdutos(page: page);
    } catch (e) {
      throw Exception('Erro ao buscar produtos: $e');
    }
  }

  Future<void> addProduto(String token, Produto produto) async {
    try {
      await apiService.cadastrarProduto(token, produto);
    } catch (e) {
      throw Exception('Erro ao cadastrar produto: $e');
    }
  }
}
