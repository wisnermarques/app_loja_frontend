import '../../services/api_service.dart';
import '../models/cliente_model.dart';

class ClienteRepository {
  final ApiService apiService;

  ClienteRepository(this.apiService);

  // Método para registrar um novo cliente
  Future<void> registerCliente(Cliente cliente, String password) async {
    try {
      await apiService.register(cliente, password);
    } catch (e) {
      throw Exception('Erro ao registrar cliente: $e');
    }
  }

  // Método para buscar cliente pelo username
  Future<Cliente> getClientePorUsername(String token, String username) async {
    try {
      final data = await apiService.getClientePorUsername(token, username);
      return Cliente.fromJson(data);
    } catch (e) {
      throw Exception('Erro ao buscar cliente: $e');
    }
  }
}
