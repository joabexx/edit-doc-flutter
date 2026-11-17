import 'package:flutter_test/flutter_test.dart';
import 'package:edit_doc_flutter/main.dart';
import 'package:edit_doc_flutter/models/services/banco_local_service.dart';
import 'package:edit_doc_flutter/viewmodels/auth_viewmodel.dart';
import 'package:edit_doc_flutter/viewmodels/documentos_viewmodel.dart';

void main() {
  testWidgets('Login e cadastro ficam acessíveis', (tester) async {
    final auth = AuthViewModel(banco: BancoLocalService());
    await tester.pumpWidget(EditDocApp(authViewModel: auth, documentosViewModel: DocumentosViewModel()));
    expect(find.text('Edit Doc'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
    expect(find.text('Não possui conta? Cadastre-se'), findsOneWidget);
  });
}
