import 'package:flutter/foundation.dart';

import '../models/services/banco_local_service.dart';
import '../models/usuario.dart';
import '../utils/validadores.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel({required BancoLocalService banco}) : _banco = banco;

  final BancoLocalService _banco;
  Usuario? _usuarioAtual;
  bool _carregando = false;
  bool _temaEscuro = false;
  String? _erro;

  Usuario? get usuarioAtual => _usuarioAtual;
  bool get carregando => _carregando;
  bool get temaEscuro => _temaEscuro;
  String? get erro => _erro;

  void alternarTema(bool escuro) {
    _temaEscuro = escuro;
    notifyListeners();
  }

  Future<bool> entrar({required String email, required String senha}) async {
    _carregando = true;
    _erro = null;
    notifyListeners();
    try {
      if (Validadores.email(email) != null || Validadores.senha(senha) != null) {
        _erro = 'Verifique os campos informados.';
        return false;
      }
      final usuario = await _banco.autenticar(email, senha);
      if (usuario == null) {
        _erro = 'E-mail ou senha incorretos.';
        return false;
      }
      _usuarioAtual = usuario;
      return true;
    } catch (_) {
      _erro = 'Erro ao efetuar login.';
      return false;
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  Future<bool> cadastrar({required String nome, required String email, required String senha}) async {
    _carregando = true;
    _erro = null;
    notifyListeners();
    try {
      if (Validadores.nome(nome) != null || Validadores.email(email) != null || Validadores.senha(senha) != null) {
        _erro = 'Corrija os dados do cadastro.';
        return false;
      }
      if (await _banco.emailEmUso(email)) {
        _erro = 'Este e-mail já está cadastrado.';
        return false;
      }
      await _banco.cadastrar(nome: nome, email: email, senha: senha);
      return true;
    } catch (_) {
      _erro = 'Erro ao efetuar cadastro.';
      return false;
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  void sair() {
    _usuarioAtual = null;
    notifyListeners();
  }
}
