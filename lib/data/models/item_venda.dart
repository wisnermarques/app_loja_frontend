class ItemVenda {
  final int produtoId;
  int quantidade;
  final double precoUnitario;
  final String produtoNome;

  ItemVenda({
    required this.produtoId,
    required this.quantidade,
    required this.precoUnitario,
    required this.produtoNome
  });

  factory ItemVenda.fromJson(Map<String, dynamic> json) {
    return ItemVenda(
      produtoId: json['produto'] ?? 0,
      quantidade: json['quantidade'] ?? 0,
      precoUnitario: double.tryParse(json['preco_unitario'].toString()) ?? 0.0,
      produtoNome: json['product_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'produto': produtoId,
      'quantidade': quantidade,
      'preco_unitario': precoUnitario.toStringAsFixed(2),
    };
  }

  @override
  String toString() {
    return 'ItemVenda(produtoId: $produtoId, quantidade: $quantidade, precoUnitario: $precoUnitario), produtoNome: $produtoNome';
  }
}