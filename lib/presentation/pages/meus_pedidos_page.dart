import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Importação para formatação de data e valores monetários
import '../../presentation/viewmodels/user_viewmodel.dart';
import '../../presentation/viewmodels/venda_viewmodel.dart';
import '../../data/models/venda.dart';

class ClientePageVenda extends StatefulWidget {
  const ClientePageVenda({super.key});

  @override
  ClientePageVendaState createState() => ClientePageVendaState();
}

class ClientePageVendaState extends State<ClientePageVenda> {
  late VendaViewModel _vendaViewModel;
  late UserViewModel _userViewModel;
  bool _isLoading = true;
  int? _clienteId;
  String? _token;
  int _selectedIndex = 0; // Índice da página selecionada

  @override
  void initState() {
    super.initState();
    _loadClienteData();
  }

  Future<void> _loadClienteData() async {
    _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    _vendaViewModel = Provider.of<VendaViewModel>(context, listen: false);

    _token = _userViewModel.token;
    if (_token == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    _clienteId = await _userViewModel.getClienteId();
    if (_clienteId != null) {
      await _vendaViewModel.obterVendasPorCliente(_token!, _clienteId!);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _logout() {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    userViewModel.logout();
    setState(() {});
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navegação entre as páginas
    switch (index) {
      case 0:
        Navigator.popAndPushNamed(context, '/');
        break;
      case 1:
        Navigator.pushNamed(context, '/carrinho');
        break;
      case 2:
        Navigator.popAndPushNamed(context, '/meus-pedidos');
        break;
      case 3:
        Navigator.popAndPushNamed(context, '/sobre');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Minhas Vendas")),
      drawer: _buildDrawer(context),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _clienteId == null
              ? const Center(
                  child: Text("Você deve estar logado para visualizar seus pedidos!!!"))
              : Consumer<VendaViewModel>(
                  builder: (context, vendaViewModel, child) {
                    if (vendaViewModel.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (vendaViewModel.vendas.isEmpty) {
                      return const Center(
                          child: Text("Nenhuma venda encontrada."));
                    }
                    return ListView.builder(
                      itemCount: vendaViewModel.vendas.length,
                      itemBuilder: (context, index) {
                        Venda venda = vendaViewModel.vendas[index];

                        // Formatação da data
                        String dataFormatada = venda.data != null
                            ? DateFormat('dd/MM/yyyy').format(venda.data!)
                            : "Data desconhecida";

                        // Lista de produtos com preço e quantidade
                        String produtosDetalhados = venda.itens.map((item) {
                          return "${item.produtoNome} (x${item.quantidade}) - R\$ ${item.precoUnitario.toStringAsFixed(2)}";
                        }).join("\n");

                        return Card(
                          margin: const EdgeInsets.all(8),
                          child: ListTile(
                            title: Text("Venda #${venda.id}"),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Data: $dataFormatada"),
                                Text("Produtos:"),
                                Text(produtosDetalhados,
                                    style: const TextStyle(fontSize: 14)),
                                const SizedBox(height: 5),
                                Text(
                                  "Total: R\$ ${venda.total.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            onTap: () => _mostrarDetalhesVenda(context, venda),
                          ),
                        );
                      },
                    );
                  },
                ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Carrinho',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Meus Pedidos',
          ),
        ],
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
      ),
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
            leading: const Icon(Icons.contact_support_sharp),
            title: const Text('Sobre'),
            onTap: () {
              Navigator.popAndPushNamed(context, '/sobre');
            },
          ),
          Consumer<UserViewModel>(
            builder: (context, userViewModel, child) {
              return userViewModel.isLoggedIn
                  ? ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Sair'),
                      onTap: _logout,
                    )
                  : ListTile(
                      leading: const Icon(Icons.login),
                      title: const Text('Login'),
                      onTap: () {
                        Navigator.popAndPushNamed(context, '/login');
                      },
                    );
            },
          ),
        ],
      ),
    );
  }

  void _mostrarDetalhesVenda(BuildContext context, Venda venda) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Detalhes da Venda #${venda.id}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: venda.itens
              .map((item) => ListTile(
                    title: Text(item.produtoNome),
                    subtitle: Text("Quantidade: ${item.quantidade}"),
                    trailing: Text(
                        "R\$ ${item.precoUnitario.toStringAsFixed(2)}"),
                  ))
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Fechar"),
          ),
        ],
      ),
    );
  }
}