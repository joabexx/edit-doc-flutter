import 'package:flutter_test/flutter_test.dart';
import 'package:edit_doc_flutter/models/services/banco_local_service.dart';
import 'package:edit_doc_flutter/viewmodels/auth_viewmodel.dart';

void main() {
  test('cadastra, rejeita e-mail repetido e efetua login', () async {
    final auth = AuthViewModel(banco: BancoLocalService());
    expect(await auth.cadastrar(nome: 'Aluno Teste', email: 'aluno@exemplo.com', senha: '123456'), isTrue);
    expect(await auth.cadastrar(nome: 'Outro Aluno', email: 'ALUNO@exemplo.com', senha: '123456'), isFalse);
    expect(await auth.entrar(email: 'aluno@exemplo.com', senha: 'errada'), isFalse);
    expect(await auth.entrar(email: 'aluno@exemplo.com', senha: '123456'), isTrue);
    expect(auth.usuarioAtual?.nome, 'Aluno Teste');
    auth.sair();
    expect(auth.usuarioAtual, isNull);
  });
}
