import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../usuario.dart';

/// Demonstração de persistência local. NÃO é um backend de autenticação seguro.
/// Para produção, use backend e hash de senha forte (Argon2id/bcrypt/scrypt).
class BancoLocalService {
  static const _chaveUsuarios = 'editdoc_usuarios_v1';
  final Random _random = Random.secure();

  Future<List<Usuario>> _listarTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final conteudo = prefs.getString(_chaveUsuarios);
    if (conteudo == null) return [];
    final valores = jsonDecode(conteudo) as List<dynamic>;
    return valores
        .map((item) => Usuario.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  Future<void> _gravarTodos(List<Usuario> usuarios) async {
    final prefs = await SharedPreferences.getInstance();
    final sucesso = await prefs.setString(
      _chaveUsuarios,
      jsonEncode(usuarios.map((usuario) => usuario.toJson()).toList()),
    );
    if (!sucesso) throw StateError('Não foi possível salvar os usuários.');
  }

  String _novaChave() => '${DateTime.now().microsecondsSinceEpoch}_${_random.nextInt(1 << 32)}';

  String _hashSenha(String senha, String salt) => sha256.convert(utf8.encode('$salt:$senha')).toString();

  Future<bool> emailEmUso(String email) async {
    final normalizado = email.trim().toLowerCase();
    return (await _listarTodos()).any((usuario) => usuario.email == normalizado);
  }

  Future<Usuario> cadastrar({required String nome, required String email, required String senha}) async {
    final usuarios = await _listarTodos();
    final normalizado = email.trim().toLowerCase();
    if (usuarios.any((usuario) => usuario.email == normalizado)) {
      throw StateError('Este e-mail já está cadastrado.');
    }
    final salt = _novaChave();
    final usuario = Usuario(
      id: _novaChave(),
      nome: nome.trim(),
      email: normalizado,
      senhaHash: _hashSenha(senha, salt),
      salt: salt,
    );
    usuarios.add(usuario);
    await _gravarTodos(usuarios);
    return usuario;
  }

  Future<Usuario?> autenticar(String email, String senha) async {
    final normalizado = email.trim().toLowerCase();
    for (final usuario in await _listarTodos()) {
      if (usuario.email == normalizado && usuario.senhaHash == _hashSenha(senha, usuario.salt)) {
        return usuario;
      }
    }
    return null;
  }

  Future<Usuario?> buscarPorId(String id) async {
    for (final usuario in await _listarTodos()) {
      if (usuario.id == id) return usuario;
    }
    return null;
  }
}
