class Produto {
  final int id;
  final String nome;
  final String descricao;
  final double preco;
  final String imagemUrl;
  final int estoque;

  Produto({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.imagemUrl,
    required this.estoque,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'] ?? 0, // Valor padrão para id
      nome: json['nome'] ?? '', // Valor padrão para nome
      descricao: json['descricao'] ?? '', // Valor padrão para descricao
      preco: double.tryParse(json['preco'].toString()) ?? 0.0, // Conversão segura para double
      imagemUrl: json['imagem'] ?? '', // Valor padrão para imagemUrl
      estoque: json['estoque'] ?? 0, // Valor padrão para estoque
    );
  }

  @override
  String toString() {
    return 'Produto(id: $id, nome: $nome, descricao: $descricao, preco: $preco, imagemUrl: $imagemUrl, estoque: $estoque)';
  }
}