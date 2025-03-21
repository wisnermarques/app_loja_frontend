import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    senhaController.dispose();
    confirmarSenhaController.dispose();
    super.dispose();
  }

  void registrar() {
    final nome = nomeController.text;
    final email = emailController.text;
    final senha = senhaController.text;
    final confirmarSenha = confirmarSenhaController.text;

    if (nome.isEmpty || email.isEmpty || senha.isEmpty || confirmarSenha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos!')),
      );
      return;
    }

    if (senha != confirmarSenha) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As senhas não coincidem!')),
      );
      return;
    }

    // Aqui você pode chamar o método de registro no backend

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registro realizado com sucesso!')),
    );
    Navigator.pop(context);
  }

  void cancelar() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Crie sua conta',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: nomeController,
                      decoration: InputDecoration(
                        labelText: 'Nome Completo',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'E-mail',
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    TextField(
                      controller: senhaController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    TextField(
                      controller: confirmarSenhaController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Confirmar Senha',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: registrar,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          ),
                          child: const Text('Registrar', style: TextStyle(fontSize: 16)),
                        ),
                        OutlinedButton(
                          onPressed: cancelar,
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          ),
                          child: const Text('Cancelar', style: TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Já tem uma conta? Faça login',
                        style: TextStyle(fontSize: 14, color: Colors.blueAccent),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
