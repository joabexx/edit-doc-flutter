import 'package:flutter/foundation.dart';
import '../models/documento.dart';

/// Lista de leitura demonstrativa. O CRUD será desenvolvido só na Etapa 5.
class DocumentosViewModel extends ChangeNotifier {
  final List<Documento> _documentos = const [
    Documento(id: 'demo1', titulo: 'Boas-vindas', conteudo: 'Este é um exemplo de documento.'),
    Documento(id: 'demo2', titulo: 'Estrutura MVVM', conteudo: 'Model, View e ViewModel separados.'),
  ];

  List<Documento> get documentos => List.unmodifiable(_documentos);
}
