import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/models/produto_model.dart';
import '../data/models/venda.dart';

class ApiService {
  final String baseUrl = 'http://127.0.0.1:8000/api';

  Future<Map<String, dynamic>> getProdutos({int page = 1}) async {
    final response = await http.get(Uri.parse('$baseUrl/produtos/?page=$page'));

    if (response.statusCode == 200) {
      String decodedBody =
          utf8.decode(response.bodyBytes); // Garante a decodificação correta
      Map<String, dynamic> data = json.decode(decodedBody);

      List<Produto> produtos = (data['results'] as List)
          .map((json) => Produto.fromJson(json))
          .toList();

      return {
        'produtos': produtos,
        'count': data['count'],
        'nextPage': data['next'], // URL da próxima página
        'previousPage': data['previous'], // URL da página anterior
      };
    } else {
      throw Exception('Falha ao carregar produtos');
    }
  }

  Future<void> cadastrarProduto(String token, Produto produto) async {
    final response = await http.post(
      Uri.parse('$baseUrl/produtos/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'nome': produto.nome,
        'descricao': produto.descricao,
        'preco': produto.preco,
        'imagem': produto.imagemUrl,
        'estoque': produto.estoque,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Falha ao cadastrar produto');
    }
  }

  // Método de login
  Future<String> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/token/'), // Substitua pelo endpoint correto de login
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Decodifica a resposta JSON para obter o token
      Map<String, dynamic> data = json.decode(response.body);
      String token = data['access'];
      return token;
    } else {
      throw Exception('Falha ao fazer login');
    }
  }

  Future<void> cadastrarVenda(String token, Venda venda) async {
    final response = await http.post(
      Uri.parse('$baseUrl/vendas/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(venda.toJson()), // Converte a venda para JSON
    );

    if (response.statusCode != 201) {
      throw Exception('Falha ao cadastrar venda');
    }
  }

  // Método corrigido para obter as vendas de um cliente específico
  Future<List<Venda>> getVendasPorCliente(String token, int clienteId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/vendas/cliente/$clienteId/'),
      headers: {
        'Authorization': 'Bearer $token', // Inclui o Bearer Token no header
      },
    );

    if (response.statusCode == 200) {
      String decodedBody =
          utf8.decode(response.bodyBytes); // Garante a decodificação correta
      Map<String, dynamic> data = json.decode(decodedBody);

      // Verifica se a resposta contém a chave "results"
      if (data.containsKey('results')) {
        List<Venda> vendas = (data['results'] as List)
            .map((json) => Venda.fromJson(json))
            .toList();
        return vendas;
      } else {
        throw Exception(
            'Formato de resposta inválido: chave "results" não encontrada');
      }
    } else {
      throw Exception('Falha ao carregar vendas: ${response.statusCode}');
    }
  }

  // Método para obter os dados de um cliente pelo nome de usuário
  Future<Map<String, dynamic>> getClientePorUsername(
      String token, String username) async {
    final response = await http.get(
      Uri.parse('$baseUrl/clientes/username/$username/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      String decodedBody = utf8.decode(response.bodyBytes);
      Map<String, dynamic> data = json.decode(decodedBody);

      return data; // Retorna o próprio JSON, sem acessar ['results']
    } else if (response.statusCode == 404) {
      throw Exception('Cliente não encontrado');
    } else {
      throw Exception(
          'Erro ao buscar cliente (Status: ${response.statusCode})');
    }
  }
}
