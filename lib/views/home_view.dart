import 'package:flutter/material.dart';

import '../models/documento.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/documentos_viewmodel.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.authViewModel, required this.documentosViewModel});

  final AuthViewModel authViewModel;
  final DocumentosViewModel documentosViewModel;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    final usuarioId = widget.authViewModel.usuarioAtual?.id;
    if (usuarioId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.documentosViewModel.carregarDocumentos(usuarioId);
      });
    }
  }

  Future<void> _sair() async {
    try {
      await widget.authViewModel.sair();
      widget.documentosViewModel.limpar();
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível encerrar a sessão.')),
      );
    }
  }

  Future<void> _excluir(Documento documento) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir documento?'),
        content: Text('Deseja excluir "${documento.titulo}"? Essa ação não poderá ser desfeita.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Excluir')),
        ],
      ),
    );
    if (confirmou != true) return;
    final sucesso = await widget.documentosViewModel.excluirDocumento(documento.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(sucesso ? 'Documento excluído.' : widget.documentosViewModel.erro ?? 'Erro ao excluir.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.authViewModel,
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          title: const Text('Meus documentos'),
          actions: [
            IconButton(
              tooltip: widget.authViewModel.temaEscuro ? 'Ativar tema claro' : 'Ativar tema escuro',
              onPressed: () => widget.authViewModel.alternarTema(!widget.authViewModel.temaEscuro),
              icon: Icon(widget.authViewModel.temaEscuro ? Icons.light_mode : Icons.dark_mode),
            ),
            IconButton(tooltip: 'Sair', icon: const Icon(Icons.logout), onPressed: _sair),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.pushNamed(context, '/editor'),
          icon: const Icon(Icons.add),
          label: const Text('Novo documento'),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Olá, ${widget.authViewModel.usuarioAtual?.nome ?? 'estudante'}!',
                    style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 6),
                  const Text('Seus documentos são armazenados localmente neste navegador.'),
                  const SizedBox(height: 22),
                  Expanded(
                    child: ListenableBuilder(
                      listenable: widget.documentosViewModel,
                      builder: (context, _) {
                        final vm = widget.documentosViewModel;
                        if (vm.carregando) return const Center(child: CircularProgressIndicator());
                        if (vm.erro != null) return Center(child: Text(vm.erro!));
                        if (vm.documentos.isEmpty) {
                          return const Center(
                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Icon(Icons.note_add_outlined, size: 76),
                              SizedBox(height: 16),
                              Text('Nenhum documento ainda.'),
                              Text('Clique em Novo documento para começar.'),
                            ]),
                          );
                        }
                        return ListView.builder(
                          itemCount: vm.documentos.length,
                          itemBuilder: (context, index) {
                            final doc = vm.documentos[index];
                            return Card(
                              child: ListTile(
                                leading: const Icon(Icons.description_outlined),
                                title: Text(doc.titulo),
                                subtitle: Text(doc.conteudo.isEmpty ? 'Sem conteúdo' : doc.conteudo,
                                  maxLines: 2, overflow: TextOverflow.ellipsis),
                                onTap: () => Navigator.pushNamed(context, '/editor', arguments: doc.id),
                                trailing: IconButton(
                                  tooltip: 'Excluir ${doc.titulo}',
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () => _excluir(doc),
                                ),
                              ),
                            );
                          },
                        );
                      },
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
