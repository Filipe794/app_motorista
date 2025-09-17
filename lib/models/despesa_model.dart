// TODO: Implementar modelo de despesa
// TODO: Adicionar validações de valor
// TODO: Implementar serialização JSON
// TODO: Adicionar categorização
// TODO: Implementar status de aprovação
// TODO: Adicionar validação de comprovantes

enum CategoriaDespesa {
  // TODO: Definir categorias possíveis
  combustivel,
  manutencao,
  alimentacao,
  pedagio,
  estacionamento,
  lavagem,
  outros
}

enum StatusDespesa {
  // TODO: Definir status possíveis
  rascunho,
  enviada,
  emAnalise,
  aprovada,
  rejeitada,
  paga
}

class DespesaModel {
  // TODO: Definir propriedades da despesa
  final String? id;
  final String? motoristaId;
  final String? descricao;
  final double? valor;
  final CategoriaDespesa? categoria;
  final StatusDespesa? status;
  final DateTime? dataGasto;
  final String? numeroNota;
  final String? estabelecimento;
  final String? observacoes;
  final List<String>? comprovantes;
  final String? motivoRejeicao;
  final DateTime? dataAprovacao;
  final String? aprovadoPor;
  final DateTime? dataCriacao;
  final DateTime? dataAtualizacao;

  // TODO: Implementar construtor
  const DespesaModel({
    this.id,
    this.motoristaId,
    this.descricao,
    this.valor,
    this.categoria,
    this.status,
    this.dataGasto,
    this.numeroNota,
    this.estabelecimento,
    this.observacoes,
    this.comprovantes,
    this.motivoRejeicao,
    this.dataAprovacao,
    this.aprovadoPor,
    this.dataCriacao,
    this.dataAtualizacao,
  });

  // TODO: Implementar fromJson
  factory DespesaModel.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError('TODO: Implementar fromJson');
  }

  // TODO: Implementar toJson
  Map<String, dynamic> toJson() {
    throw UnimplementedError('TODO: Implementar toJson');
  }

  // TODO: Implementar copyWith
  DespesaModel copyWith({
    String? id,
    String? motoristaId,
    String? descricao,
    double? valor,
    CategoriaDespesa? categoria,
    StatusDespesa? status,
    DateTime? dataGasto,
    String? numeroNota,
    String? estabelecimento,
    String? observacoes,
    List<String>? comprovantes,
    String? motivoRejeicao,
    DateTime? dataAprovacao,
    String? aprovadoPor,
    DateTime? dataCriacao,
    DateTime? dataAtualizacao,
  }) {
    throw UnimplementedError('TODO: Implementar copyWith');
  }

  // TODO: Implementar getters calculados
  bool get temComprovante => throw UnimplementedError('TODO: Verificar se tem comprovante');
  bool get podeEditar => throw UnimplementedError('TODO: Verificar se pode editar');
  bool get foiAprovada => throw UnimplementedError('TODO: Verificar se foi aprovada');
  String get categoriaTexto => throw UnimplementedError('TODO: Converter categoria para texto');
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