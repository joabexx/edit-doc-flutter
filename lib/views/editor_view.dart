import 'package:flutter/material.dart';

import '../utils/validadores.dart';
import '../viewmodels/documentos_viewmodel.dart';

class EditorView extends StatefulWidget {
  const EditorView({super.key, required this.documentosViewModel, this.documentoId});

  final DocumentosViewModel documentosViewModel;
  final String? documentoId;

  @override
  State<EditorView> createState() => _EditorViewState();
}

class _EditorViewState extends State<EditorView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _tituloController;
  late final TextEditingController _conteudoController;
  bool _documentoInvalido = false;

  @override
  void initState() {
    super.initState();
    final documento = widget.documentosViewModel.porId(widget.documentoId);
    _documentoInvalido = widget.documentoId != null && documento == null;
    _tituloController = TextEditingController(text: documento?.titulo ?? '');
    _conteudoController = TextEditingController(text: documento?.conteudo ?? '');
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _conteudoController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    final sucesso = await widget.documentosViewModel.salvarDocumento(
      documentoId: widget.documentoId,
      titulo: _tituloController.text,
      conteudo: _conteudoController.text,
    );
    if (!mounted) return;
    if (sucesso) {
      final messenger = ScaffoldMessenger.of(context);
      Navigator.pop(context);
      messenger.showSnackBar(
        const SnackBar(content: Text('Documento salvo com sucesso.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.documentosViewModel.erro ?? 'Erro ao salvar.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_documentoInvalido) {
      return Scaffold(
        appBar: AppBar(title: const Text('Documento não encontrado')),
        body: const Center(child: Text('O documento solicitado não está disponível.')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(widget.documentoId == null ? 'Novo documento' : 'Editar documento')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _tituloController,
                    decoration: const InputDecoration(labelText: 'Título', border: OutlineInputBorder()),
                    validator: Validadores.tituloDocumento,
                    maxLength: 120,
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _conteudoController,
                      expands: true,
                      minLines: null,
                      maxLines: null,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: const InputDecoration(labelText: 'Conteúdo do documento',
                        hintText: 'Digite o texto aqui...', border: OutlineInputBorder(), alignLabelWithHint: true),
                    ),
                  ),
                  const SizedBox(height: 14),
                  ListenableBuilder(
                    listenable: widget.documentosViewModel,
                    builder: (context, _) => FilledButton.icon(
                      onPressed: widget.documentosViewModel.carregando ? null : _salvar,
                      icon: widget.documentosViewModel.carregando
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.save_outlined),
                      label: const Text('Salvar documento'),
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
