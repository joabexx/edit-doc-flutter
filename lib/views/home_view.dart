import 'package:flutter/material.dart';

import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/documentos_viewmodel.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key, required this.authViewModel, required this.documentosViewModel});

  final AuthViewModel authViewModel;
  final DocumentosViewModel documentosViewModel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: authViewModel,
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          title: const Text('Meus documentos'),
          actions: [
            IconButton(
              tooltip: authViewModel.temaEscuro ? 'Ativar tema claro' : 'Ativar tema escuro',
              onPressed: () => authViewModel.alternarTema(!authViewModel.temaEscuro),
              icon: Icon(authViewModel.temaEscuro ? Icons.light_mode : Icons.dark_mode),
            ),
            IconButton(
              tooltip: 'Sair',
              icon: const Icon(Icons.logout),
              onPressed: () {
                authViewModel.sair();
                Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
              },
            ),
          ],
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 850),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Olá, ${authViewModel.usuarioAtual?.nome ?? 'estudante'}!',
                    style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  const Text('Fase 1: navegação, validação e arquitetura MVVM. Os documentos abaixo são exemplos somente para leitura.'),
                  const SizedBox(height: 18),
                  Expanded(
                    child: ListenableBuilder(
                      listenable: documentosViewModel,
                      builder: (context, _) => ListView.builder(
                        itemCount: documentosViewModel.documentos.length,
                        itemBuilder: (context, index) {
                          final doc = documentosViewModel.documentos[index];
                          return Card(
                            child: ListTile(
                              leading: const Icon(Icons.description_outlined),
                              title: Text(doc.titulo),
                              subtitle: Text(doc.conteudo, maxLines: 2, overflow: TextOverflow.ellipsis),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
