import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:edit_doc_flutter/main.dart';
import 'package:edit_doc_flutter/models/services/banco_local_service.dart';
import 'package:edit_doc_flutter/models/services/documento_storage_service.dart';
import 'package:edit_doc_flutter/models/services/preferences_service.dart';
import 'package:edit_doc_flutter/viewmodels/auth_viewmodel.dart';
import 'package:edit_doc_flutter/viewmodels/documentos_viewmodel.dart';

void main() {
  testWidgets('Login com link de cadastro inicia corretamente', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final auth = AuthViewModel(banco: BancoLocalService(), preferences: PreferencesService());
    await auth.inicializar();
    await tester.pumpWidget(EditDocApp(
      authViewModel: auth,
      documentosViewModel: DocumentosViewModel(storage: DocumentoStorageService()),
    ));
    expect(find.text('Edit Doc'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
    expect(find.text('Não possui conta? Cadastre-se'), findsOneWidget);
  });
}
