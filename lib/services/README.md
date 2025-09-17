# ⚙️ Services - Camada de Lógica de Negócio

## 📋 Propósito
Esta pasta contém toda a lógica de negócio do aplicativo, implementando casos de uso específicos:
- Operações complexas que envolvem múltiplos repositórios
- Transformação e validação de dados
- Orquestração de fluxos de trabalho
- Integração com APIs externas e serviços do sistema
- Cache inteligente e sincronização de dados

## 🏗️ Estrutura Recomendada

```
services/
├── README.md                    # Este arquivo
├── auth_service.dart           # Serviço de autenticação
├── escalas_service.dart        # Serviço de escalas
├── despesas_service.dart       # Serviço de despesas
├── chamados_service.dart       # Serviço de chamados
├── perfil_service.dart         # Serviço de perfil
├── notification_service.dart   # Serviço de notificações
├── location_service.dart       # Serviço de localização
├── file_service.dart          # Serviço de arquivos
├── sync_service.dart          # Serviço de sincronização
├── analytics_service.dart     # Serviço de analytics
├── base/
│   ├── base_service.dart      # Classe base para serviços
│   └── service_locator.dart   # Localizador de serviços
├── external/
│   ├── firebase_service.dart  # Integração com Firebase
│   ├── maps_service.dart      # Integração com Google Maps
│   └── payment_service.dart   # Integração com pagamentos
└── utils/
    ├── validator_service.dart  # Validações complexas
    ├── crypto_service.dart    # Criptografia e segurança
    └── date_service.dart      # Manipulação de datas
```

## 🚀 Como Usar

### 1. Instância Singleton
```dart
final authService = AuthService.instance;
final escalasService = EscalasService.instance;
```

### 2. Operações de Negócio
```dart
// Login com validação completa
final result = await AuthService.instance.login(
  email: 'user@email.com',
  password: 'password123',
);

// Buscar escalas com cache e offline support
final escalas = await EscalasService.instance.getEscalasMotorista('123');

// Criar despesa com validação e upload
final success = await DespesasService.instance.criarDespesaComComprovante(
  despesa: despesaData,
  comprovante: imageFile,
);
```

### 3. Tratamento de Erros
```dart
try {
  await service.executeOperation();
} on AuthenticationException {
  // Redirecionar para login
} on ValidationException catch (e) {
  // Mostrar erros de validação
  showErrors(e.errors);
} on NetworkException {
  // Modo offline
} catch (e) {
  // Erro genérico
  showError('Erro inesperado');
}
```

### 4. Observação de Mudanças
```dart
// Escutar mudanças de autenticação
AuthService.instance.authStateChanges.listen((user) {
  if (user == null) {
    Navigator.pushReplacementNamed(context, '/login');
  }
});

// Escutar mudanças nas escalas
EscalasService.instance.escalasStream.listen((escalas) {
  setState(() => this.escalas = escalas);
});
```

## 💡 Melhores Práticas

### ✅ **Singleton com Lazy Initialization**
```dart
class AuthService {
  static AuthService? _instance;
  static AuthService get instance => _instance ??= AuthService._();
  AuthService._();
  
  // Dependências injetadas
  late final AuthRepository _authRepository;
  late final UserRepository _userRepository;
  late final NotificationService _notificationService;
  
  // Stream controllers para observação
  final _authStateController = BehaviorSubject<UserModel?>();
  Stream<UserModel?> get authStateChanges => _authStateController.stream;
  
  void initialize() {
    _authRepository = AuthRepository.instance;
    _userRepository = UserRepository.instance;
    _notificationService = NotificationService.instance;
    
    // Inicializar estado de autenticação
    _checkInitialAuthState();
  }
}
```

### ✅ **Validação de Negócio Complexa**
```dart
class DespesasService {
  Future<ValidationResult> validateDespesa(DespesaModel despesa) async {
    final errors = <String>[];
    
    // Validação de valor
    if (despesa.valor == null || despesa.valor! <= 0) {
      errors.add('Valor deve ser maior que zero');
    }
    
    // Validação de data
    if (despesa.dataGasto?.isAfter(DateTime.now()) ?? false) {
      errors.add('Data do gasto não pode ser futura');
    }
    
    // Validação de categoria
    if (despesa.categoria == null) {
      errors.add('Categoria é obrigatória');
    }
    
    // Validação de limite mensal
    final limiteAtual = await _calculateLimiteMensal(despesa.motoristaId!);
    if (limiteAtual + despesa.valor! > LIMITE_MENSAL) {
      errors.add('Limite mensal de despesas excedido');
    }
    
    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }
}
```

### ✅ **Orquestração de Múltiplos Repositórios**
```dart
class EscalasService {
  Future<bool> confirmarPresencaCompleta(String escalaId) async {
    try {
      // 1. Buscar dados da escala
      final escala = await _escalasRepository.getEscalaById(escalaId);
      if (escala == null) throw NotFoundException('Escala não encontrada');
      
      // 2. Validar se pode confirmar
      if (!_canConfirmPresence(escala)) {
        throw ValidationException('Não é possível confirmar presença');
      }
      
      // 3. Confirmar presença
      final confirmed = await _escalasRepository.confirmarPresenca(escalaId);
      if (!confirmed) return false;
      
      // 4. Atualizar cache local
      await _cacheService.invalidateEscalasCache(escala.motoristaId!);
      
      // 5. Enviar notificação
      await _notificationService.sendPresenceConfirmation(escala);
      
      // 6. Registrar analytics
      await _analyticsService.trackEvent('presenca_confirmada', {
        'escala_id': escalaId,
        'motorista_id': escala.motoristaId,
      });
      
      // 7. Atualizar stream
      _escalasController.add(await _getEscalasMotorista(escala.motoristaId!));
      
      return true;
    } catch (e) {
      // Log do erro
      _logService.error('Erro ao confirmar presença', e);
      rethrow;
    }
  }
}
```

### ✅ **Cache e Sincronização Inteligente**
```dart
class SyncService {
  Future<void> syncAllData() async {
    final tasks = [
      _syncEscalas(),
      _syncDespesas(),
      _syncChamados(),
      _syncPerfil(),
    ];
    
    // Executar sincronizações em paralelo
    final results = await Future.wait(
      tasks,
      eagerError: false,
    );
    
    // Verificar se todas foram bem-sucedidas
    final failed = results.where((r) => !r).length;
    if (failed > 0) {
      _notificationService.showSyncWarning(failed);
    }
  }
  
  Future<bool> _syncEscalas() async {
    try {
      final lastSync = await _storageService.getLastSyncTime('escalas');
      final escalas = await _apiClient.get('/escalas/sync', {
        'since': lastSync?.toIso8601String(),
      });
      
      await _escalasRepository.bulkUpdate(escalas);
      await _storageService.setLastSyncTime('escalas', DateTime.now());
      
      return true;
    } catch (e) {
      return false;
    }
  }
}
```

### ✅ **Tratamento de Estados Offline/Online**
```dart
class ConnectivityAwareService {
  final Connectivity _connectivity;
  bool _isOnline = true;
  
  void initialize() {
    _connectivity.onConnectivityChanged.listen((result) {
      final wasOffline = !_isOnline;
      _isOnline = result != ConnectivityResult.none;
      
      if (wasOffline && _isOnline) {
        _handleBackOnline();
      }
    });
  }
  
  Future<T> executeWithConnectivity<T>({
    required Future<T> Function() onlineAction,
    required Future<T> Function() offlineAction,
  }) async {
    if (_isOnline) {
      try {
        return await onlineAction();
      } on NetworkException {
        return await offlineAction();
      }
    } else {
      return await offlineAction();
    }
  }
  
  Future<void> _handleBackOnline() async {
    // Sincronizar dados pendentes
    await SyncService.instance.syncPendingChanges();
    
    // Notificar usuário
    _notificationService.showBackOnlineMessage();
  }
}
```

## 🔧 Implementação Ideal

### 1. **Service Locator Pattern**
```dart
class ServiceLocator {
  static final Map<Type, dynamic> _services = {};
  
  static T get<T>() {
    final service = _services[T];
    if (service == null) {
      throw Exception('Service $T not registered');
    }
    return service as T;
  }
  
  static void register<T>(T service) {
    _services[T] = service;
  }
  
  static void initialize() {
    register<AuthService>(AuthService.instance);
    register<EscalasService>(EscalasService.instance);
    register<DespesasService>(DespesasService.instance);
    // ... outros serviços
  }
}
```

### 2. **Result Pattern para Operações**
```dart
class Result<T> {
  final T? data;
  final String? error;
  final bool isSuccess;
  
  Result.success(this.data) : error = null, isSuccess = true;
  Result.failure(this.error) : data = null, isSuccess = false;
  
  bool get isFailure => !isSuccess;
}

// Uso no serviço
Future<Result<UserModel>> login(String email, String password) async {
  try {
    final user = await _authRepository.login(email, password);
    return Result.success(user);
  } catch (e) {
    return Result.failure(e.toString());
  }
}
```

### 3. **Event System para Comunicação**
```dart
class EventBus {
  static final _instance = EventBus._();
  static EventBus get instance => _instance;
  EventBus._();
  
  final Map<Type, List<Function>> _listeners = {};
  
  void listen<T>(void Function(T) callback) {
    _listeners[T] ??= [];
    _listeners[T]!.add(callback);
  }
  
  void emit<T>(T event) {
    _listeners[T]?.forEach((callback) => callback(event));
  }
}

// Eventos
class EscalaConfirmada {
  final String escalaId;
  const EscalaConfirmada(this.escalaId);
}

// Emitir evento
EventBus.instance.emit(EscalaConfirmada(escalaId));

// Escutar evento
EventBus.instance.listen<EscalaConfirmada>((event) {
  // Atualizar UI
});
```

### 4. **Retry Pattern com Backoff**
```dart
mixin RetryMixin {
  Future<T> executeWithRetry<T>(
    Future<T> Function() action, {
    int maxRetries = 3,
    Duration baseDelay = const Duration(seconds: 1),
  }) async {
    int attempts = 0;
    
    while (attempts < maxRetries) {
      try {
        return await action();
      } catch (e) {
        attempts++;
        
        if (attempts >= maxRetries) rethrow;
        
        // Exponential backoff
        final delay = baseDelay * math.pow(2, attempts - 1);
        await Future.delayed(delay);
      }
    }
    
    throw Exception('Max retries exceeded');
  }
}
```

## 🧪 Testes Recomendados

```dart
group('EscalasService', () {
  late MockEscalasRepository mockRepository;
  late MockNotificationService mockNotificationService;
  late EscalasService service;
  
  setUp(() {
    mockRepository = MockEscalasRepository();
    mockNotificationService = MockNotificationService();
    service = EscalasService.testing(
      repository: mockRepository,
      notificationService: mockNotificationService,
    );
  });
  
  test('should confirm presence successfully', () async {
    // Arrange
    final escala = EscalaModel(id: '1', motoristaId: '123');
    when(mockRepository.getEscalaById('1'))
      .thenAnswer((_) async => escala);
    when(mockRepository.confirmarPresenca('1'))
      .thenAnswer((_) async => true);
    
    // Act
    final result = await service.confirmarPresencaCompleta('1');
    
    // Assert
    expect(result, true);
    verify(mockRepository.confirmarPresenca('1')).called(1);
    verify(mockNotificationService.sendPresenceConfirmation(escala)).called(1);
  });
  
  test('should handle validation errors', () async {
    // Arrange
    final escala = EscalaModel(
      id: '1',
      status: StatusEscala.concluida, // Não pode confirmar
    );
    when(mockRepository.getEscalaById('1'))
      .thenAnswer((_) async => escala);
    
    // Act & Assert
    expect(
      () => service.confirmarPresencaCompleta('1'),
      throwsA(isA<ValidationException>()),
    );
  });
});
```

## 📚 Dependências Recomendadas

```yaml
dependencies:
  rxdart: ^0.27.7              # Streams reativas
  connectivity_plus: ^4.0.2    # Verificar conectividade
  get_it: ^7.6.4               # Service locator
  injectable: ^2.3.0           # Injeção de dependência
  crypto: ^3.0.3               # Criptografia
  uuid: ^3.0.7                 # IDs únicos

dev_dependencies:
  mockito: ^5.4.2              # Mocking para testes
```

## 🎯 Objetivos da Implementação

1. **Separação de Responsabilidades**: Lógica de negócio isolada da UI
2. **Reutilização**: Serviços compartilhados entre múltiplas telas
3. **Testabilidade**: Lógica facilmente testável e mockável
4. **Manutenibilidade**: Código organizado e bem documentado
5. **Performance**: Operações otimizadas e cache inteligente
6. **Confiabilidade**: Tratamento robusto de erros e retry automático

## 🔄 Fluxo de Dados Típico

```
UI Component
    ↓ (chama método)
Service
    ↓ (valida dados)
Repository(s)
    ↓ (busca/salva dados)
Service
    ↓ (processa resultado)
UI Component (recebe resultado)
```