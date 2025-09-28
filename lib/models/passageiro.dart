enum StatusPassageiro {
  embarcado,
  aguardando,
  faltou,
}

class Passageiro {
  final String id;
  final String nome;
  final String matricula;
  final String escola;
  final String parada;
  final StatusPassageiro status;
  final String telefoneResponsavel;
  final String? observacoes;

  const Passageiro({
    required this.id,
    required this.nome,
    required this.matricula,
    required this.escola,
    required this.parada,
    required this.status,
    required this.telefoneResponsavel,
    this.observacoes,
  });

  Passageiro copyWith({
    String? id,
    String? nome,
    String? matricula,
    String? escola,
    String? parada,
    StatusPassageiro? status,
    String? telefoneResponsavel,
    String? observacoes,
  }) {
    return Passageiro(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      matricula: matricula ?? this.matricula,
      escola: escola ?? this.escola,
      parada: parada ?? this.parada,
      status: status ?? this.status,
      telefoneResponsavel: telefoneResponsavel ?? this.telefoneResponsavel,
      observacoes: observacoes ?? this.observacoes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'matricula': matricula,
      'escola': escola,
      'parada': parada,
      'status': status.name,
      'telefoneResponsavel': telefoneResponsavel,
      'observacoes': observacoes,
    };
  }

  factory Passageiro.fromJson(Map<String, dynamic> json) {
    return Passageiro(
      id: json['id'] as String,
      nome: json['nome'] as String,
      matricula: json['matricula'] as String,
      escola: json['escola'] as String,
      parada: json['parada'] as String,
      status: StatusPassageiro.values.firstWhere(
        (e) => e.name == json['status'],
      ),
      telefoneResponsavel: json['telefoneResponsavel'] as String,
      observacoes: json['observacoes'] as String?,
    );
  }

  @override
  String toString() {
    return 'Passageiro(id: $id, nome: $nome, matricula: $matricula, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Passageiro && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}