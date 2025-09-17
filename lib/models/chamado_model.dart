// TODO: Implementar modelo de chamado
// TODO: Adicionar validações de dados
// TODO: Implementar serialização JSON
// TODO: Adicionar prioridades
// TODO: Implementar histórico de mensagens
// TODO: Adicionar validação de anexos

enum PrioridadeChamado {
  // TODO: Definir prioridades possíveis
  baixa,
  media,
  alta,
  urgente
}

enum StatusChamado {
  // TODO: Definir status possíveis
  aberto,
  emAndamento,
  aguardandoResposta,
  resolvido,
  fechado,
  cancelado
}

enum CategoriaChamado {
  // TODO: Definir categorias possíveis
  suporteTecnico,
  problemaVeiculo,
  questaoTrabalhista,
  solicitacaoDocumento,
  reclamacao,
  sugestao,
  outros
}

class ChamadoModel {
  // TODO: Definir propriedades do chamado
  final String? id;
  final String? motoristaId;
  final String? titulo;
  final String? descricao;
  final CategoriaChamado? categoria;
  final PrioridadeChamado? prioridade;
  final StatusChamado? status;
  final String? atendentePor;
  final DateTime? dataAbertura;
  final DateTime? dataFechamento;
  final String? resolucao;
  final List<String>? anexos;
  final List<Map<String, dynamic>>? mensagens;
  final int? avaliacaoAtendimento;
  final String? comentarioAvaliacao;
  final DateTime? prazoResposta;
  final DateTime? dataCriacao;
  final DateTime? dataAtualizacao;

  // TODO: Implementar construtor
  const ChamadoModel({
    this.id,
    this.motoristaId,
    this.titulo,
    this.descricao,
    this.categoria,
    this.prioridade,
    this.status,
    this.atendentePor,
    this.dataAbertura,
    this.dataFechamento,
    this.resolucao,
    this.anexos,
    this.mensagens,
    this.avaliacaoAtendimento,
    this.comentarioAvaliacao,
    this.prazoResposta,
    this.dataCriacao,
    this.dataAtualizacao,
  });

  // TODO: Implementar fromJson
  factory ChamadoModel.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError('TODO: Implementar fromJson');
  }

  // TODO: Implementar toJson
  Map<String, dynamic> toJson() {
    throw UnimplementedError('TODO: Implementar toJson');
  }

  // TODO: Implementar copyWith
  ChamadoModel copyWith({
    String? id,
    String? motoristaId,
    String? titulo,
    String? descricao,
    CategoriaChamado? categoria,
    PrioridadeChamado? prioridade,
    StatusChamado? status,
    String? atendentePor,
    DateTime? dataAbertura,
    DateTime? dataFechamento,
    String? resolucao,
    List<String>? anexos,
    List<Map<String, dynamic>>? mensagens,
    int? avaliacaoAtendimento,
    String? comentarioAvaliacao,
    DateTime? prazoResposta,
    DateTime? dataCriacao,
    DateTime? dataAtualizacao,
  }) {
    throw UnimplementedError('TODO: Implementar copyWith');
  }

  // TODO: Implementar getters calculados
  bool get isAberto => throw UnimplementedError('TODO: Verificar se está aberto');
  bool get isFechado => throw UnimplementedError('TODO: Verificar se está fechado');
  bool get temAnexos => throw UnimplementedError('TODO: Verificar se tem anexos');
  Duration? get tempoResposta => throw UnimplementedError('TODO: Calcular tempo de resposta');
  String get categoriaTexto => throw UnimplementedError('TODO: Converter categoria para texto');
  String get prioridadeTexto => throw UnimplementedError('TODO: Converter prioridade para texto');
  String get statusTexto => throw UnimplementedError('TODO: Converter status para texto');

  @override
  bool operator ==(Object other) {
    // TODO: Implementar comparação
    throw UnimplementedError('TODO: Implementar ==');
  }

  @override
  int get hashCode {
    // TODO: Implementar hashCode
    throw UnimplementedError('TODO: Implementar hashCode');
  }

  @override
  String toString() {
    // TODO: Implementar toString
    throw UnimplementedError('TODO: Implementar toString');
  }
}