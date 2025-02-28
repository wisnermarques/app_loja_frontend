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
      id: json['id'],
      nome: json['nome'],
      descricao: json['descricao'],
      preco: double.tryParse(json['preco'].toString()) ?? 0.0,
      imagemUrl: json['imagem'] ?? '',
      estoque: json['estoque'],
    );
  }
}