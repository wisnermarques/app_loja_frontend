import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SobrePage extends StatelessWidget {
  const SobrePage({super.key});

  final String empresaNome = "Loja API";
  final String endereco = "Rua Exemplo, 123 - Cidade, Estado";
  final String telefone = "+55 11 99999-9999";
  final String email = "contato@lojaapi.com";

  Future<void> _launchPhone(String phone) async {
    final Uri url = Uri.parse("tel:$phone");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Não foi possível iniciar a chamada.';
    }
  }

  Future<void> _launchEmail(String email) async {
    final Uri url = Uri.parse("mailto:$email");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Não foi possível abrir o e-mail.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sobre Nós"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  const Icon(Icons.storefront, size: 80, color: Colors.blueAccent),
                  const SizedBox(height: 10),
                  Text(
                    empresaNome,
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const Divider(thickness: 1, height: 30),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.location_on, color: Colors.blueAccent),
              title: Text(
                endereco,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.blueAccent),
              title: GestureDetector(
                onTap: () => _launchPhone(telefone),
                child: Text(
                  telefone,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.blueAccent),
              title: GestureDetector(
                onTap: () => _launchEmail(email),
                child: Text(
                  email,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
