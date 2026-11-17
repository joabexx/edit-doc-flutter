import 'dart:math';

import 'package:flutter/foundation.dart';

import '../models/documento.dart';
import '../models/services/documento_storage_service.dart';

class DocumentosViewModel extends ChangeNotifier {
  DocumentosViewModel({required DocumentoStorageService storage}) : _storage = storage;

  final DocumentoStorageService _storage;
  final Random _random = Random.secure();
  List<Documento> _documentos = [];
  bool _carregando = false;
  String? _erro;
  String? _usuarioId;

  List<Documento> get documentos => List.unmodifiable(_documentos);
  bool get carregando => _carregando;
  String? get erro => _erro;

  Documento? porId(String? id) {
    if (id == null) return null;
    for (final documento in _documentos) {
      if (documento.id == id) return documento;
    }
    return null;
  }

  Future<void> carregarDocumentos(String usuarioId) async {
    _usuarioId = usuarioId;
    _carregando = true;
    _erro = null;
    _documentos = [];
    notifyListeners();
    try {
      _documentos = await _storage.listarPorUsuario(usuarioId);
    } catch (_) {
      _erro = 'Não foi possível carregar seus documentos.';
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  Future<bool> salvarDocumento({String? documentoId, required String titulo, required String conteudo}) async {
    final usuarioId = _usuarioId;
    if (usuarioId == null) {
      _erro = 'É necessário entrar na sua conta.';
      notifyListeners();
      return false;
    }
    if (titulo.trim().isEmpty) {
      _erro = 'Informe um título para o documento.';
      notifyListeners();
      return false;
    }
    _carregando = true;
    _erro = null;
    notifyListeners();
    try {
      final agora = DateTime.now();
      final Documento documento;
      if (documentoId == null) {
        documento = Documento(
          id: '${agora.microsecondsSinceEpoch}_${_random.nextInt(1 << 32)}',
          usuarioId: usuarioId,
          titulo: titulo.trim(),
          conteudo: conteudo,
          criadoEm: agora,
          atualizadoEm: agora,
        );
      } else {
        final existente = porId(documentoId);
        if (existente == null || existente.usuarioId != usuarioId) {
          _erro = 'Documento não encontrado.';
          return false;
        }
        documento = existente.copyWith(titulo: titulo.trim(), conteudo: conteudo, atualizadoEm: agora);
      }
      await _storage.salvar(documento);
      _documentos = await _storage.listarPorUsuario(usuarioId);
      return true;
    } catch (_) {
      _erro = 'Não foi possível salvar o documento.';
      return false;
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  Future<bool> excluirDocumento(String documentoId) async {
    final usuarioId = _usuarioId;
    if (usuarioId == null || porId(documentoId) == null) return false;
    _carregando = true;
    _erro = null;
    notifyListeners();
    try {
      await _storage.excluir(documentoId, usuarioId);
      _documentos = await _storage.listarPorUsuario(usuarioId);
      return true;
    } catch (_) {
      _erro = 'Não foi possível excluir o documento.';
      return false;
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  void limpar() {
    _usuarioId = null;
    _documentos = [];
    _erro = null;
    notifyListeners();
  }
}
