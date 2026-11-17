import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:edit_doc_flutter/models/services/banco_local_service.dart';
import 'package:edit_doc_flutter/models/services/preferences_service.dart';
import 'package:edit_doc_flutter/viewmodels/auth_viewmodel.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('cadastro e login permanecem disponíveis após reinstanciar ViewModel', () async {
    final banco = BancoLocalService();
    final preferencias = PreferencesService();
    final auth = AuthViewModel(banco: banco, preferences: preferencias);
    await auth.inicializar();
    expect(await auth.cadastrar(nome: 'Aluno Teste', email: 'aluno@exemplo.com', senha: '123456'), isTrue);
    expect(await auth.cadastrar(nome: 'Outra Pessoa', email: 'ALUNO@exemplo.com', senha: '123456'), isFalse);
    expect(await auth.entrar(email: 'aluno@exemplo.com', senha: '123456'), isTrue);
    await auth.alternarTema(true);

    final authReiniciado = AuthViewModel(banco: BancoLocalService(), preferences: PreferencesService());
    await authReiniciado.inicializar();
    expect(authReiniciado.autenticado, isTrue);
    expect(authReiniciado.temaEscuro, isTrue);
    expect(authReiniciado.usuarioAtual?.email, 'aluno@exemplo.com');
    await authReiniciado.sair();
    expect(authReiniciado.autenticado, isFalse);
  });
}
