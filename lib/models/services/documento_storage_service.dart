import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../documento.dart';

/// Repositório local: CRUD serializado em JSON no armazenamento do navegador.
class DocumentoStorageService {
  static const _chaveDocumentos = 'editdoc_documentos_v1';

  Future<List<Documento>> _listarTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final conteudo = prefs.getString(_chaveDocumentos);
    if (conteudo == null) return [];
    final itens = jsonDecode(conteudo) as List<dynamic>;
    return itens.map((item) => Documento.fromJson(Map<String, dynamic>.from(item as Map))).toList();
  }

  Future<void> _gravarTodos(List<Documento> documentos) async {
    final prefs = await SharedPreferences.getInstance();
    final sucesso = await prefs.setString(
      _chaveDocumentos,
      jsonEncode(documentos.map((documento) => documento.toJson()).toList()),
    );
    if (!sucesso) throw StateError('Não foi possível salvar os documentos.');
  }

  Future<List<Documento>> listarPorUsuario(String usuarioId) async {
    final todos = await _listarTodos();
    final resultado = todos.where((doc) => doc.usuarioId == usuarioId).toList()
      ..sort((a, b) => b.atualizadoEm.compareTo(a.atualizadoEm));
    return resultado;
  }

  Future<void> salvar(Documento documento) async {
    final todos = await _listarTodos();
    final posicao = todos.indexWhere((item) => item.id == documento.id);
    if (posicao >= 0) {
      if (todos[posicao].usuarioId != documento.usuarioId) {
        throw StateError('Documento não pertence ao usuário.');
      }
      todos[posicao] = documento;
    } else {
      todos.add(documento);
    }
    await _gravarTodos(todos);
  }

  Future<void> excluir(String documentoId, String usuarioId) async {
    final todos = await _listarTodos();
    todos.removeWhere((doc) => doc.id == documentoId && doc.usuarioId == usuarioId);
    await _gravarTodos(todos);
  }
}
