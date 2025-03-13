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
}
