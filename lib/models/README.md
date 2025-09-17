# 🎯 Models - Camada de Modelos de Dados

## 📋 Propósito
Esta pasta contém todas as classes de modelo que representam entidades de dados do aplicativo:
- Estruturas de dados tipadas e imutáveis
- Serialização/deserialização JSON automática
- Validações de dados integradas
- Métodos utilitários e comparação
- Documentação clara de cada propriedade

## 🏗️ Estrutura Recomendada

```
models/
├── README.md                   # Este arquivo
├── user_model.dart            # Modelo do usuário/motorista
├── escala_model.dart          # Modelo de escala de trabalho
├── despesa_model.dart         # Modelo de despesa
├── chamado_model.dart         # Modelo de chamado/ticket
├── notification_model.dart    # Modelo de notificação
├── base/
│   ├── base_model.dart        # Classe base para todos os models
│   └── serializable.dart     # Interface de serialização
├── enums/
│   ├── status_escala.dart     # Enum de status de escala
│   ├── categoria_despesa.dart # Enum de categoria de despesa
│   ├── tipo_chamado.dart      # Enum de tipo de chamado
│   └── user_role.dart         # Enum de papel do usuário
└── validators/
    ├── cpf_validator.dart     # Validador de CPF
    ├── email_validator.dart   # Validador de email
    └── phone_validator.dart   # Validador de telefone
```

## 🚀 Como Usar

### 1. Criação de Instância
```dart
final user = UserModel(
  id: '123',
  nome: 'João Silva',
  email: 'joao@email.com',
  cpf: '123.456.789-00',
);
```

### 2. Serialização JSON
```dart
// Para JSON
final json = user.toJson();

// De JSON
final userFromJson = UserModel.fromJson(jsonData);
```

### 3. Cópia com Modificações
```dart
final updatedUser = user.copyWith(
  nome: 'João Santos',
  telefone: '(11) 99999-9999',
);
```

### 4. Validações
```dart
if (user.isValidEmail) {
  // Email válido
}

if (user.isValidCPF) {
  // CPF válido
}
```

## 💡 Melhores Práticas

### ✅ **Modelo Imutável com Getters**
```dart
class UserModel {
  final String? id;
  final String? nome;
  final String? email;
  
  const UserModel({
    this.id,
    this.nome,
    this.email,
  });
  
  // Getters computados
  bool get isValid => id != null && nome != null && email != null;
  String get displayName => nome ?? 'Usuário sem nome';
}
```

### ✅ **Serialização Robusta**
```dart
factory UserModel.fromJson(Map<String, dynamic> json) {
  return UserModel(
    id: json['id']?.toString(),
    nome: json['nome']?.toString(),
    email: json['email']?.toString(),
    dataNascimento: json['data_nascimento'] != null 
      ? DateTime.tryParse(json['data_nascimento']) 
      : null,
  );
}

Map<String, dynamic> toJson() {
  return {
    'id': id,
    'nome': nome,
    'email': email,
    'data_nascimento': dataNascimento?.toIso8601String(),
  }..removeWhere((key, value) => value == null);
}
```

### ✅ **Validações Integradas**
```dart
bool get isValidEmail {
  if (email == null) return false;
  return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
    .hasMatch(email!);
}

bool get isValidCPF {
  if (cpf == null) return false;
  return CPFValidator.isValid(cpf!);
}
```

### ✅ **Implementação de Equality**
```dart
@override
bool operator ==(Object other) {
  if (identical(this, other)) return true;
  return other is UserModel &&
    other.id == id &&
    other.nome == nome &&
    other.email == email;
}

@override
int get hashCode => Object.hash(id, nome, email);
```

### ✅ **toString Informativo**
```dart
@override
String toString() {
  return 'UserModel(id: $id, nome: $nome, email: $email)';
}
```

## 🔧 Implementação Ideal

### 1. **Classe Base Reutilizável**
```dart
abstract class BaseModel {
  const BaseModel();
  
  Map<String, dynamic> toJson();
  
  // Método helper para removeWhere
  Map<String, dynamic> removeNulls(Map<String, dynamic> json) {
    return json..removeWhere((key, value) => value == null);
  }
}
```

### 2. **Interface de Serialização**
```dart
abstract class Serializable {
  Map<String, dynamic> toJson();
}
```

### 3. **Enums Tipados**
```dart
enum StatusEscala {
  agendada('Agendada'),
  confirmada('Confirmada'),
  emAndamento('Em Andamento'),
  concluida('Concluída'),
  cancelada('Cancelada');
  
  const StatusEscala(this.displayName);
  final String displayName;
  
  static StatusEscala? fromString(String? value) {
    return StatusEscala.values
      .where((e) => e.name == value)
      .firstOrNull;
  }
}
```

### 4. **Validadores Externos**
```dart
class CPFValidator {
  static bool isValid(String cpf) {
    // Implementar validação de CPF
    final cleanCPF = cpf.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanCPF.length != 11) return false;
    
    // Lógica de validação do CPF
    return _validateCPFDigits(cleanCPF);
  }
  
  static bool _validateCPFDigits(String cpf) {
    // Implementação dos dígitos verificadores
    // ...
  }
}
```

### 5. **Extensões Úteis**
```dart
extension UserModelExtensions on UserModel {
  bool get isPremium => role == UserRole.premium;
  
  String get initials {
    if (nome == null) return 'U';
    final parts = nome!.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return nome![0].toUpperCase();
  }
}
```

## 🧪 Testes Recomendados

```dart
group('UserModel', () {
  test('should create user with valid data', () {
    final user = UserModel(
      id: '123',
      nome: 'João Silva',
      email: 'joao@test.com',
    );
    
    expect(user.id, '123');
    expect(user.nome, 'João Silva');
    expect(user.isValidEmail, true);
  });
  
  test('should serialize to/from JSON correctly', () {
    final user = UserModel(id: '123', nome: 'João');
    final json = user.toJson();
    final userFromJson = UserModel.fromJson(json);
    
    expect(userFromJson.id, user.id);
    expect(userFromJson.nome, user.nome);
  });
  
  test('should validate email correctly', () {
    final validUser = UserModel(email: 'valid@email.com');
    final invalidUser = UserModel(email: 'invalid-email');
    
    expect(validUser.isValidEmail, true);
    expect(invalidUser.isValidEmail, false);
  });
  
  test('should compare equality correctly', () {
    final user1 = UserModel(id: '123', nome: 'João');
    final user2 = UserModel(id: '123', nome: 'João');
    final user3 = UserModel(id: '456', nome: 'Maria');
    
    expect(user1, equals(user2));
    expect(user1, isNot(equals(user3)));
  });
});
```

## 📚 Dependências Recomendadas

```yaml
dependencies:
  equatable: ^2.0.5        # Facilita implementação de equality
  json_annotation: ^4.8.1  # Geração automática de serialização

dev_dependencies:
  json_serializable: ^6.7.1 # Gerador de código para JSON
  build_runner: ^2.4.7      # Runner para geração de código
```

## 🎯 Objetivos da Implementação

1. **Type Safety**: Dados tipados previnem erros em runtime
2. **Imutabilidade**: Estados previsíveis e sem side effects
3. **Serialização**: Comunicação confiável com APIs
4. **Validação**: Dados sempre consistentes e válidos
5. **Testabilidade**: Fácil de testar e mockar
6. **Legibilidade**: Código auto-documentado e claro

## 🔄 Padrão de Desenvolvimento

```dart
// 1. Definir o modelo
class ExampleModel {
  final String? id;
  final String? name;
  
  const ExampleModel({this.id, this.name});
}

// 2. Implementar serialização
factory ExampleModel.fromJson(Map<String, dynamic> json) => 
  ExampleModel(
    id: json['id']?.toString(),
    name: json['name']?.toString(),
  );

// 3. Implementar copyWith
ExampleModel copyWith({String? id, String? name}) =>
  ExampleModel(
    id: id ?? this.id,
    name: name ?? this.name,
  );

// 4. Implementar validações
bool get isValid => id != null && name != null;

// 5. Implementar equality
@override
bool operator ==(Object other) =>
  identical(this, other) ||
  other is ExampleModel && other.id == id && other.name == name;

// 6. Escrever testes
// 7. Documentar uso
```