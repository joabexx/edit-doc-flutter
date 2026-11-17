class Usuario {
  const Usuario({required this.id, required this.nome, required this.email, required this.senha});

  final String id;
  final String nome;
  final String email;
  // Senha somente em memória nesta fase didática. Nunca use texto puro em produção.
  final String senha;
}
