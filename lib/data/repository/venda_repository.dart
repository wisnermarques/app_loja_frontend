import '../../services/api_service.dart';
import '../models/venda.dart';


class VendaRepository {
  final ApiService apiService;

  VendaRepository(this.apiService);

  Future<void> cadastrarVenda(String token, Venda venda) async {
    try {
      await apiService.cadastrarVenda(token, venda);
    } catch (e) {
      throw Exception('Erro ao cadastrar venda: $e');
    }
  }

  // Método para obter as vendas de um cliente específico
  Future<List<Venda>> getVendasPorCliente(String token, int clienteId) async {
    try {
      return await apiService.getVendasPorCliente(token, clienteId);
    } catch (e) {
      throw Exception('Erro ao obter vendas do cliente: $e');
    }
  }
}
