class Validadores {
  Validadores._();

  static String? nome(String? valor) {
    final texto = (valor ?? '').trim();
    if (texto.isEmpty) return 'Informe seu nome.';
    if (texto.length < 3) return 'Use pelo menos 3 caracteres.';
    return null;
  }

  static String? email(String? valor) {
    final texto = (valor ?? '').trim();
    if (texto.isEmpty) return 'Informe seu e-mail.';
    final padrao = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!padrao.hasMatch(texto)) return 'Informe um e-mail válido.';
    return null;
  }

  static String? senha(String? valor) {
    final texto = valor ?? '';
    if (texto.isEmpty) return 'Informe sua senha.';
    if (texto.length < 6) return 'Use pelo menos 6 caracteres.';
    return null;
  }

  static String? confirmarSenha(String? valor, String senha) {
    final validacao = Validadores.senha(valor);
    if (validacao != null) return validacao;
    if (valor != senha) return 'As senhas não conferem.';
    return null;
  }

  static String? tituloDocumento(String? valor) {
    if ((valor ?? '').trim().isEmpty) return 'Informe o título.';
    return null;
  }
}
