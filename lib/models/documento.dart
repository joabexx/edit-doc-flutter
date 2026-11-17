class Documento {
  const Documento({
    required this.id,
    required this.usuarioId,
    required this.titulo,
    required this.conteudo,
    required this.criadoEm,
    required this.atualizadoEm,
  });

  final String id;
  final String usuarioId;
  final String titulo;
  final String conteudo;
  final DateTime criadoEm;
  final DateTime atualizadoEm;

  Documento copyWith({String? titulo, String? conteudo, DateTime? atualizadoEm}) => Documento(
    id: id,
    usuarioId: usuarioId,
    titulo: titulo ?? this.titulo,
    conteudo: conteudo ?? this.conteudo,
    criadoEm: criadoEm,
    atualizadoEm: atualizadoEm ?? this.atualizadoEm,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'usuarioId': usuarioId,
    'titulo': titulo,
    'conteudo': conteudo,
    'criadoEm': criadoEm.toIso8601String(),
    'atualizadoEm': atualizadoEm.toIso8601String(),
  };

  factory Documento.fromJson(Map<String, dynamic> json) => Documento(
    id: json['id'] as String,
    usuarioId: json['usuarioId'] as String,
    titulo: json['titulo'] as String,
    conteudo: json['conteudo'] as String,
    criadoEm: DateTime.parse(json['criadoEm'] as String),
    atualizadoEm: DateTime.parse(json['atualizadoEm'] as String),
  );
}
