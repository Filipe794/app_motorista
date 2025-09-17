// TODO: Implementar modelo de usuário/motorista
// TODO: Adicionar validações de dados
// TODO: Implementar serialização JSON
// TODO: Adicionar métodos de conversão
// TODO: Implementar comparação e hashCode
// TODO: Adicionar validação de CPF/documentos

class UserModel {
  // TODO: Definir propriedades do usuário
  final String? id;
  final String? nome;
  final String? email;
  final String? cpf;
  final String? telefone;
  final String? matricula;
  final String? fotoPerfil;
  final DateTime? dataNascimento;
  final String? endereco;
  final bool? ativo;
  final DateTime? dataCriacao;
  final DateTime? ultimoLogin;

  // TODO: Implementar construtor
  const UserModel({
    this.id,
    this.nome,
    this.email,
    this.cpf,
    this.telefone,
    this.matricula,
    this.fotoPerfil,
    this.dataNascimento,
    this.endereco,
    this.ativo,
    this.dataCriacao,
    this.ultimoLogin,
  });

  // TODO: Implementar fromJson
  factory UserModel.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError('TODO: Implementar fromJson');
  }

  // TODO: Implementar toJson
  Map<String, dynamic> toJson() {
    throw UnimplementedError('TODO: Implementar toJson');
  }

  // TODO: Implementar copyWith
  UserModel copyWith({
    String? id,
    String? nome,
    String? email,
    String? cpf,
    String? telefone,
    String? matricula,
    String? fotoPerfil,
    DateTime? dataNascimento,
    String? endereco,
    bool? ativo,
    DateTime? dataCriacao,
    DateTime? ultimoLogin,
  }) {
    throw UnimplementedError('TODO: Implementar copyWith');
  }

  // TODO: Implementar validações
  bool get isValidEmail => throw UnimplementedError('TODO: Validar email');
  bool get isValidCPF => throw UnimplementedError('TODO: Validar CPF');
  bool get isValidTelefone => throw UnimplementedError('TODO: Validar telefone');

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