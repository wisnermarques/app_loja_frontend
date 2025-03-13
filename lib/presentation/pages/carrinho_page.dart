import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/produto_viewmodel.dart';

class CarrinhoPage extends StatelessWidget {
  const CarrinhoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProdutoViewModel>(context);
    final carrinho = viewModel.carrinho;
    final total = carrinho.fold(0.0, (sum, item) => sum + item.preco);

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
                      final produto = carrinho[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: produto.imagemUrl.isNotEmpty
                                ? Image.network(
                                    produto.imagemUrl,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(Icons.image, size: 50, color: Colors.grey),
                          ),
                          title: Text(produto.nome,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          subtitle: Text('R\$ ${produto.preco.toStringAsFixed(2)}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove_circle, color: Colors.red),
                            onPressed: () {
                              viewModel.removerDoCarrinho(produto);
                            },
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
                      Text('Total: R\$ ${total.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12.0),
                      ElevatedButton(
                        onPressed: () {
                          if (carrinho.isNotEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Compra finalizada com sucesso!')),
                            );
                            viewModel.limparCarrinho();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                        ),
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
