import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/produto_model.dart';
import '../viewmodels/produto_viewmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _carregarProdutos();
    });
  }

  Future<void> _carregarProdutos() async {
    final viewModel = Provider.of<ProdutoViewModel>(context, listen: false);
    try {
      await viewModel.carregarProdutos();
    } catch (error) {
      // Trate o erro de forma apropriada
    }
  }

  void _logout() {
    final viewModel = Provider.of<ProdutoViewModel>(context, listen: false);
    viewModel.logout();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        actions: [
          Consumer<ProdutoViewModel>(
            builder: (context, viewModel, child) {
              final isLoggedIn = viewModel.isLoggedIn;
              final username = viewModel.username;

              return isLoggedIn
                  ? Row(
                      children: [
                        Text(
                          username ?? 'Usuário',
                          style: const TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        IconButton(
                          icon: const Icon(Icons.logout, color: Colors.white),
                          onPressed: _logout,
                        ),
                      ],
                    )
                  : IconButton(
                      icon: const Icon(Icons.person, color: Colors.white),
                      onPressed: () {
                        Navigator.popAndPushNamed(context, '/login');
                      },
                    );
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: _buildBody(),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueAccent,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Página Inicial'),
            onTap: () {
              Navigator.popAndPushNamed(context, '/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Carrinho'),
            onTap: () {
              Navigator.popAndPushNamed(context, '/carrinho');
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sair'),
            onTap: _logout,
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Pesquisar produto...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
          const SizedBox(height: 10),
          Expanded(child: _buildProductList()),
          _buildPaginationControls(),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return Consumer<ProdutoViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.errorMessage != null) {
          return Center(
            child: Text(
              viewModel.errorMessage!,
              style: const TextStyle(fontSize: 18, color: Colors.red),
            ),
          );
        }

        final produtosFiltrados = viewModel.produtos
            .where((produto) => produto.nome.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();

        return produtosFiltrados.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Nenhum produto encontrado.',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _carregarProdutos,
                    child: const Text('Recarregar'),
                  ),
                ],
              )
            : ListView.builder(
                itemCount: produtosFiltrados.length,
                itemBuilder: (context, index) {
                  final produto = produtosFiltrados[index];
                  return _buildProductCard(produto, viewModel);
                },
              );
      },
    );
  }

  Widget _buildPaginationControls() {
    return Consumer<ProdutoViewModel>(
      builder: (context, viewModel, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: viewModel.paginaAtual > 1 ? () => viewModel.carregarPagina(viewModel.paginaAtual - 1) : null,
            ),
            ...List.generate(viewModel.totalPaginas, (index) {
              return TextButton(
                onPressed: () => viewModel.carregarPagina(index + 1),
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontWeight: viewModel.paginaAtual == index + 1 ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              );
            }),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: viewModel.paginaAtual < viewModel.totalPaginas ? () => viewModel.carregarPagina(viewModel.paginaAtual + 1) : null,
            ),
          ],
        );
      },
    );
  }

  Widget _buildProductCard(Produto produto, ProdutoViewModel viewModel) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produto.nome,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    produto.descricao,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'R\$ ${produto.preco.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12.0),
                  ElevatedButton(
          onPressed: () {
            if (viewModel.isLoggedIn) {
              viewModel.adicionarAoCarrinho(produto);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Produto adicionado ao carrinho!')),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Faça login para adicionar ao carrinho!')),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text('Comprar'),
        ),
                ],
              ),
            ),
            const SizedBox(width: 12.0),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: produto.imagemUrl.isNotEmpty
                  ? Image.network(
                      produto.imagemUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.image,
                            size: 100, color: Colors.grey);
                      },
                    )
                  : const Icon(Icons.image, size: 100, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}