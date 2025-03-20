import '../../services/api_service.dart';

class UserRepository {
  final ApiService apiService;

  UserRepository(this.apiService);

  Future<String> login(String username, String password) async {
    try {
      return await apiService.login(username, password);
    } catch (e) {
      throw Exception('Erro ao tentar realizar o login: $e');
    }
  }

  // Método para obter os dados do cliente pelo nome de usuário
  Future<Map<String, dynamic>> getClientePorUsername(String token, String username) async {
    try {
      return await apiService.getClientePorUsername(token, username);
    } catch (e) {
      throw Exception('Erro ao buscar cliente: $e');
    }
  }
}
