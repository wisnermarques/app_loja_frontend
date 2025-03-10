import 'package:app_loja_frontend/views/carrinho_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/produto_viewmodel.dart';
import 'views/home_page.dart';
import 'views/login_page.dart'; // Import other pages if needed

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProdutoViewModel()),
        // Add other providers here if needed
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Loja API',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Default route
      routes: {
        '/': (context) => const HomePage(), // Home route
        '/login': (context) => const LoginPage(), 
        '/carrinho': (context) => const CarrinhoPage(),
        // Add other routes here
      },
    );
  }
}