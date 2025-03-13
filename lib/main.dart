import 'package:app_loja_frontend/data/repository/user_repository.dart';
import 'package:app_loja_frontend/presentation/viewmodels/user_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/repository/produto_repository.dart';
import 'presentation/pages/carrinho_page.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/viewmodels/produto_viewmodel.dart';
import 'services/api_service.dart';

void main() {

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProdutoViewModel(ProdutoRepository(ApiService())),
        ),
        ChangeNotifierProvider(
          create: (_) => UserViewModel(UserRepository(ApiService())),
        ),
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
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/carrinho': (context) => const CarrinhoPage(),
      },
    );
  }
}
