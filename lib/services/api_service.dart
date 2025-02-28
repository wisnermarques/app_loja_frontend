import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/produto_model.dart';

class ApiService {
  final String baseUrl = 'http://127.0.0.1:8000/api';

Future<List<Produto>> getProdutos() async {
  final response = await http.get(Uri.parse('$baseUrl/produtos/'));

  if (response.statusCode == 200) {
    String decodedBody = utf8.decode(response.bodyBytes); // Garante que a decodificação está correta
    List<dynamic> data = json.decode(decodedBody);
    return data.map((json) => Produto.fromJson(json)).toList();
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
}
