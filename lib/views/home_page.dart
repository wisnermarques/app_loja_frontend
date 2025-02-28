import 'package:flutter/material.dart';
import '../viewmodels/produto_viewmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late ProdutoViewModel viewModel;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    viewModel = ProdutoViewModel();
    _carregarProdutos();
  }

  Future<void> _carregarProdutos() async {
    try {
      await viewModel.carregarProdutos();
    } catch (error) {
      errorMessage = 'Erro: \$error';
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : viewModel.produtos.isEmpty
                  ? const Center(child: Text('Nenhum produto encontrado.'))
                  : ListView.builder(
                      itemCount: viewModel.produtos.length,
                      itemBuilder: (context, index) {
                        final produto = viewModel.produtos[index];
                        return ListTile(
                          title: Text(produto.nome),
                          subtitle: Text('R\$ ${produto.preco.toStringAsFixed(2)}'),
                        );
                      },
                    ),
    );
  }
}
