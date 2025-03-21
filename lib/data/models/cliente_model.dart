class Cliente {
  final int? id;
  final String username;
  final String email;
  final String telefone;
  final String endereco;

  Cliente({
    this.id,
    required this.username,
    required this.email,
    required this.telefone,
    required this.endereco,
  });

  // Converte um JSON para um objeto Cliente
  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      telefone: json['telefone'],
      endereco: json['endereco'],
    );
  }

  // Converte um objeto Cliente para JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'telefone': telefone,
      'endereco': endereco,
    };
  }
}
