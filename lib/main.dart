import 'package:flutter/material.dart';

import 'models/services/banco_local_service.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/documentos_viewmodel.dart';
import 'views/cadastro_view.dart';
import 'views/home_view.dart';
import 'views/login_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final auth = AuthViewModel(banco: BancoLocalService());
  final documentos = DocumentosViewModel();
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
        title: 'Edit Doc - MVVM',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
        darkTheme: ThemeData(colorSchemeSeed: Colors.indigo, brightness: Brightness.dark, useMaterial3: true),
        themeMode: authViewModel.temaEscuro ? ThemeMode.dark : ThemeMode.light,
        initialRoute: '/',
        routes: {
          '/': (_) => LoginView(authViewModel: authViewModel),
          '/cadastro': (_) => CadastroView(authViewModel: authViewModel),
          '/home': (_) => HomeView(authViewModel: authViewModel, documentosViewModel: documentosViewModel),
        },
      ),
    );
  }
}
