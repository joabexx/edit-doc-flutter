import 'package:flutter/material.dart';

import 'models/services/banco_local_service.dart';
import 'models/services/documento_storage_service.dart';
import 'models/services/preferences_service.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/documentos_viewmodel.dart';
import 'views/cadastro_view.dart';
import 'views/editor_view.dart';
import 'views/home_view.dart';
import 'views/login_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final auth = AuthViewModel(banco: BancoLocalService(), preferences: PreferencesService());
  await auth.inicializar();
  final documentos = DocumentosViewModel(storage: DocumentoStorageService());
  runApp(EditDocApp(authViewModel: auth, documentosViewModel: documentos));
}

class EditDocApp extends StatelessWidget {
  const EditDocApp({super.key, required this.authViewModel, required this.documentosViewModel});

  final AuthViewModel authViewModel;
  final DocumentosViewModel documentosViewModel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: authViewModel,
      builder: (context, _) => MaterialApp(
        title: 'Edit Doc Flutter',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
        darkTheme: ThemeData(colorSchemeSeed: Colors.indigo, brightness: Brightness.dark, useMaterial3: true),
        themeMode: authViewModel.temaEscuro ? ThemeMode.dark : ThemeMode.light,
        initialRoute: authViewModel.autenticado ? '/home' : '/',
        routes: {
          '/': (_) => LoginView(authViewModel: authViewModel),
          '/cadastro': (_) => CadastroView(authViewModel: authViewModel),
          '/home': (_) => HomeView(authViewModel: authViewModel, documentosViewModel: documentosViewModel),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/editor') {
            final id = settings.arguments is String ? settings.arguments as String : null;
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (_) => EditorView(documentosViewModel: documentosViewModel, documentoId: id),
            );
          }
          return null;
        },
      ),
    );
  }
}
