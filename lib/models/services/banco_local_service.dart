import '../usuario.dart';

/// Banco em memória para testar fluxo e validações ANTES do CRUD persistente.
/// Reiniciar a aplicação apaga os cadastros desta Fase 1.
class BancoLocalService {
  final List<Usuario> _usuarios = [];
  int _contador = 0;

  Future<Usuario?> autenticar(String email, String senha) async {
    final emailNormalizado = email.trim().toLowerCase();
    for (final usuario in _usuarios) {
      if (usuario.email == emailNormalizado && usuario.senha == senha) {
        return usuario;
      }
    }
    return null;
  }

  Future<bool> emailEmUso(String email) async {
    final normalizado = email.trim().toLowerCase();
    return _usuarios.any((usuario) => usuario.email == normalizado);
  }

  Future<Usuario> cadastrar({required String nome, required String email, required String senha}) async {
    _contador++;
    final usuario = Usuario(
      id: 'temporario_$_contador',
      nome: nome.trim(),
      email: email.trim().toLowerCase(),
      senha: senha,
    );
    _usuarios.add(usuario);
    return usuario;
  }
}
