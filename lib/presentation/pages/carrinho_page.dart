import 'package:app_loja_frontend/presentation/viewmodels/user_viewmodel.dart';
import 'package:app_loja_frontend/presentation/viewmodels/venda_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/venda.dart';
import '../viewmodels/produto_viewmodel.dart';

class CarrinhoPage extends StatelessWidget {
  const CarrinhoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProdutoViewModel>(context);
    final vendaViewModel = Provider.of<VendaViewModel>(context);
    final userViewModel = Provider.of<UserViewModel>(context);
    final carrinho = viewModel.carrinho;

    // Calcular o total
    final total = carrinho.fold(
      0.0,
      (sum, item) => sum + (item.precoUnitario * item.quantidade),
    );

    Future<void> finalizarCompra(BuildContext context) async {
      if (carrinho.isEmpty) return;

      int? clienteId = await userViewModel.getClienteId();

      if (clienteId == null) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao obter cliente. Faça login novamente.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final venda = Venda(
        clienteId: clienteId,
        itens: carrinho,
        total: total,
      );

      print('Token antes de realizar a venda: ${userViewModel.token}');
      print('Venda a ser enviada: ${venda.toJson()}');

      await vendaViewModel.realizarVenda(userViewModel.token!, venda);
      viewModel.limparCarrinho();

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Compra finalizada com sucesso!')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
        backgroundColor: Colors.blueAccent,
      ),
      body: carrinho.isEmpty
          ? const Center(
              child: Text('Seu carrinho está vazio.',
                  style: TextStyle(fontSize: 18)),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: carrinho.length,
                    itemBuilder: (context, index) {
                      final item = carrinho[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: ListTile(
                          title: Text(item.produtoNome),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Preço Unitário: R\$ ${item.precoUnitario.toStringAsFixed(2)}'),
                              Text('Quantidade: ${item.quantidade}'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  viewModel.atualizarQuantidade(item, item.quantidade - 1);
                                },
                              ),
                              Text('${item.quantidade}'),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  viewModel.atualizarQuantidade(item, item.quantidade + 1);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text('Total: R\$ ${total.toStringAsFixed(2)}'),
                      ElevatedButton(
                        onPressed: () async {
                          await finalizarCompra(context);
                        },
                        child: const Text('Finalizar Compra'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}