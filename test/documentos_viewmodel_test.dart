import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:edit_doc_flutter/models/services/documento_storage_service.dart';
import 'package:edit_doc_flutter/viewmodels/documentos_viewmodel.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('CRUD persiste e filtra documentos por usuário', () async {
    final storage = DocumentoStorageService();
    final vm = DocumentosViewModel(storage: storage);
    await vm.carregarDocumentos('usuario_1');
    expect(vm.documentos, isEmpty);

    expect(await vm.salvarDocumento(titulo: 'Texto 1', conteudo: 'Olá mundo'), isTrue);
    expect(vm.documentos.length, 1);
    final doc = vm.documentos.single;

    expect(await vm.salvarDocumento(documentoId: doc.id, titulo: 'Texto editado', conteudo: 'Conteúdo novo'), isTrue);
    expect(vm.documentos.single.titulo, 'Texto editado');

    final vmReiniciado = DocumentosViewModel(storage: DocumentoStorageService());
    await vmReiniciado.carregarDocumentos('usuario_1');
    expect(vmReiniciado.documentos.length, 1);
    expect(vmReiniciado.documentos.single.conteudo, 'Conteúdo novo');

    final vmOutroUsuario = DocumentosViewModel(storage: DocumentoStorageService());
    await vmOutroUsuario.carregarDocumentos('usuario_2');
    expect(vmOutroUsuario.documentos, isEmpty);

    expect(await vmReiniciado.excluirDocumento(doc.id), isTrue);
    expect(vmReiniciado.documentos, isEmpty);
  });
}
