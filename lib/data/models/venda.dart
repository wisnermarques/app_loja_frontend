import 'item_venda.dart';

class Venda {
  final int? id;
  final DateTime? data;
  final int clienteId;
  final List<ItemVenda> itens;
  final double total;

  Venda({
    this.id,
    required this.clienteId,
    required this.itens,
    required this.total,
    this.data,
  });

  factory Venda.fromJson(Map<String, dynamic> json) {
    return Venda(
      id: json['id'],
      clienteId: json['cliente'], // Certifique-se de que a API retorna "cliente"
      data: json['data_venda'] != null
          ? DateTime.parse(json['data_venda']) // Verifique o nome do campo
          : null,
      itens: (json['itens'] as List)
          .map((item) => ItemVenda.fromJson(item))
          .toList(),
      total: double.tryParse(json['total'].toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cliente': clienteId, // Certifique-se de que a API espera "cliente"
      'itens': itens.map((item) => item.toJson()).toList(),
      'total': total.toStringAsFixed(2), // Verifique se a API espera string
      // 'id' e 'data' não são enviados na requisição POST
    };
  }

  @override
  String toString() {
    return 'Venda(id: $id, clienteId: $clienteId, itens: $itens, total: $total, data: $data)';
  }
}