import 'package:flutter_test/flutter_test.dart';
import 'package:edit_doc_flutter/utils/validadores.dart';

void main() {
  test('aceita nome com pelo menos 3 caracteres', () {
    expect(Validadores.nome('Joabe'), isNull);
    expect(Validadores.nome('AB'), isNotNull);
  });

  test('valida formato de e-mail', () {
    expect(Validadores.email('teste@exemplo.com'), isNull);
    expect(Validadores.email('email-invalido'), isNotNull);
  });

  test('exige senha mínima e confirmação idêntica', () {
    expect(Validadores.senha('123456'), isNull);
    expect(Validadores.senha('123'), isNotNull);
    expect(Validadores.confirmarSenha('123456', '123456'), isNull);
    expect(Validadores.confirmarSenha('abcdef', '123456'), isNotNull);
  });
}
