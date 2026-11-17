import 'package:shared_preferences/shared_preferences.dart';

/// Preferências simples do aplicativo; não deve guardar credenciais reais.
class PreferencesService {
  static const _chaveTema = 'editdoc_tema_escuro_v1';
  static const _chaveSessao = 'editdoc_usuario_sessao_v1';

  Future<bool> carregarTema() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_chaveTema) ?? false;
  }

  Future<void> salvarTema(bool escuro) async {
    final prefs = await SharedPreferences.getInstance();
    final sucesso = await prefs.setBool(_chaveTema, escuro);
    if (!sucesso) throw StateError('Falha ao salvar tema.');
  }

  Future<String?> carregarSessao() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_chaveSessao);
  }

  Future<void> salvarSessao(String usuarioId) async {
    final prefs = await SharedPreferences.getInstance();
    final sucesso = await prefs.setString(_chaveSessao, usuarioId);
    if (!sucesso) throw StateError('Falha ao salvar sessão.');
  }

  Future<void> limparSessao() async {
    final prefs = await SharedPreferences.getInstance();
    final sucesso = await prefs.remove(_chaveSessao);
    if (!sucesso) throw StateError('Falha ao limpar sessão.');
  }
}
