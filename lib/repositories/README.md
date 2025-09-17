# 🗄️ Repositories - Camada de Acesso a Dados

## 📋 Propósito
Esta pasta implementa o padrão Repository, centralizando toda a lógica de acesso a dados:
- Abstração entre UI e fontes de dados (API, cache, local storage)
- Cache inteligente e sincronização offline/online
- Tratamento de erros específicos por domínio
- Transformação de dados raw em modelos tipados
- Invalidação automática de cache

## 🏗️ Estrutura Recomendada

```
repositories/
├── README.md                      # Este arquivo
├── auth_repository.dart           # Repositório de autenticação
├── escalas_repository.dart        # Repositório de escalas
├── despesas_repository.dart       # Repositório de despesas
├── chamados_repository.dart       # Repositório de chamados
├── perfil_repository.dart         # Repositório de perfil
├── base/
│   ├── base_repository.dart       # Classe base para repositórios
│   ├── repository_interface.dart  # Interface padrão
│   └── cache_manager.dart         # Gerenciador de cache
├── local/
│   ├── database_helper.dart       # Helper para SQLite
│   ├── shared_prefs_helper.dart   # Helper para SharedPreferences
│   └── secure_storage_helper.dart # Helper para dados sensíveis
└── exceptions/
    ├── repository_exception.dart  # Exceções específicas do repo
    ├── cache_exception.dart       # Erros de cache
    └── sync_exception.dart        # Erros de sincronização
```

## 🚀 Como Usar

### 1. Instância Singleton
```dart
final authRepo = AuthRepository.instance;
final escalasRepo = EscalasRepository.instance;
```

### 2. Operações CRUD
```dart
// Buscar dados (com cache automático)
final escalas = await EscalasRepository.instance.getEscalasMotorista('123');

// Criar novo item
final success = await DespesasRepository.instance.criarDespesa(despesaData);

// Atualizar item existente
final updated = await PerfilRepository.instance.atualizarPerfil('123', newData);

// Deletar item
final deleted = await ChamadosRepository.instance.deletarChamado('456');
```

### 3. Cache e Sincronização
```dart
// Forçar busca na API (ignorar cache)
final freshData = await repo.getEscalas(forceRefresh: true);

// Sincronizar dados offline com servidor
await repo.syncPendingChanges();

// Verificar se há mudanças não sincronizadas
final hasChanges = await repo.hasUnsyncedChanges();
```

### 4. Tratamento de Erros
```dart
try {
  final result = await repo.getData();
} on NetworkException {
  // Sem conexão - usar cache
  final cached = await repo.getCachedData();
} on RepositoryException catch (e) {
  // Erro específico do repositório
  showError(e.message);
} catch (e) {
  // Erro genérico
  showError('Erro inesperado');
}
```

## 💡 Melhores Práticas

### ✅ **Interface Abstrata**
```dart
abstract class EscalasRepository {
  Future<List<EscalaModel>> getEscalasMotorista(String motoristaId);
  Future<EscalaModel?> getEscalaById(String id);
  Future<bool> confirmarPresenca(String escalaId);
  Future<void> cacheEscalas(List<EscalaModel> escalas);
  Future<bool> syncPendingChanges();
}
```

### ✅ **Implementação com Cache**
```dart
class EscalasRepositoryImpl implements EscalasRepository {
  final ApiClient _apiClient;
  final CacheManager _cache;
  final LocalStorage _localStorage;
  
  @override
  Future<List<EscalaModel>> getEscalasMotorista(
    String motoristaId, {
    bool forceRefresh = false,
  }) async {
    final cacheKey = 'escalas_$motoristaId';
    
    // Verificar cache primeiro (se não forçar refresh)
    if (!forceRefresh) {
      final cached = await _cache.get<List<EscalaModel>>(cacheKey);
      if (cached != null && !_cache.isExpired(cacheKey)) {
        return cached;
      }
    }
    
    try {
      // Buscar na API
      final response = await _apiClient.get('/escalas/$motoristaId');
      final escalas = (response['data'] as List)
        .map((json) => EscalaModel.fromJson(json))
        .toList();
      
      // Salvar no cache
      await _cache.set(cacheKey, escalas);
      
      return escalas;
    } on NetworkException {
      // Sem rede - retornar cache se disponível
      final cached = await _cache.get<List<EscalaModel>>(cacheKey);
      if (cached != null) return cached;
      rethrow;
    }
  }
}
```

### ✅ **Gerenciamento de Estado Offline**
```dart
class OfflineManager {
  static const String _pendingActionsKey = 'pending_actions';
  
  Future<void> addPendingAction(Map<String, dynamic> action) async {
    final pending = await _getPendingActions();
    pending.add({
      ...action,
      'timestamp': DateTime.now().toIso8601String(),
      'id': uuid.v4(),
    });
    await _savePendingActions(pending);
  }
  
  Future<void> syncPendingActions() async {
    final pending = await _getPendingActions();
    final failed = <Map<String, dynamic>>[];
    
    for (final action in pending) {
      try {
        await _executeAction(action);
      } catch (e) {
        failed.add(action);
      }
    }
    
    await _savePendingActions(failed);
  }
}
```

### ✅ **Invalidação Inteligente de Cache**
```dart
class CacheInvalidator {
  static void invalidateRelated(String entity, String action) {
    switch (entity) {
      case 'escala':
        if (action == 'update' || action == 'delete') {
          CacheManager.instance.invalidatePattern('escalas_*');
          CacheManager.instance.invalidatePattern('proxima_escala_*');
        }
        break;
      case 'despesa':
        if (action == 'create' || action == 'update') {
          CacheManager.instance.invalidatePattern('despesas_*');
          CacheManager.instance.invalidatePattern('relatorio_despesas_*');
        }
        break;
    }
  }
}
```

## 🔧 Implementação Ideal

### 1. **Classe Base Reutilizável**
```dart
abstract class BaseRepository<T> {
  final ApiClient apiClient;
  final CacheManager cache;
  final LocalStorage localStorage;
  
  BaseRepository({
    required this.apiClient,
    required this.cache,
    required this.localStorage,
  });
  
  // Métodos comuns a todos os repositórios
  Future<List<T>> getAll({bool forceRefresh = false});
  Future<T?> getById(String id, {bool forceRefresh = false});
  Future<bool> create(T item);
  Future<bool> update(String id, T item);
  Future<bool> delete(String id);
  
  // Cache helpers
  String getCacheKey(String suffix) => '${T.toString().toLowerCase()}_$suffix';
  Future<void> invalidateCache(String pattern);
}
```

### 2. **Tratamento de Conectividade**
```dart
class ConnectivityAwareRepository {
  final Connectivity _connectivity;
  
  Future<T> executeWithConnectivity<T>(
    Future<T> Function() onlineAction,
    Future<T> Function() offlineAction,
  ) async {
    final hasConnection = await _connectivity.checkConnectivity() != 
      ConnectivityResult.none;
    
    if (hasConnection) {
      try {
        return await onlineAction();
      } on NetworkException {
        return await offlineAction();
      }
    } else {
      return await offlineAction();
    }
  }
}
```

### 3. **Padrão Observer para Mudanças**
```dart
class RepositoryObserver {
  static final Map<String, List<VoidCallback>> _listeners = {};
  
  static void listen(String entity, VoidCallback callback) {
    _listeners[entity] ??= [];
    _listeners[entity]!.add(callback);
  }
  
  static void notify(String entity) {
    _listeners[entity]?.forEach((callback) => callback());
  }
  
  static void dispose(String entity, VoidCallback callback) {
    _listeners[entity]?.remove(callback);
  }
}
```

### 4. **Métricas e Analytics**
```dart
class RepositoryMetrics {
  static void trackCacheHit(String repository, String method) {
    AnalyticsService.track('cache_hit', {
      'repository': repository,
      'method': method,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  static void trackApiCall(String repository, String endpoint, Duration duration) {
    AnalyticsService.track('api_call', {
      'repository': repository,
      'endpoint': endpoint,
      'duration_ms': duration.inMilliseconds,
    });
  }
}
```

## 🧪 Testes Recomendados

```dart
group('EscalasRepository', () {
  late MockApiClient mockApiClient;
  late MockCacheManager mockCache;
  late EscalasRepository repository;
  
  setUp(() {
    mockApiClient = MockApiClient();
    mockCache = MockCacheManager();
    repository = EscalasRepositoryImpl(
      apiClient: mockApiClient,
      cache: mockCache,
    );
  });
  
  test('should return cached data when available and not expired', () async {
    // Arrange
    final cachedEscalas = [EscalaModel(id: '1')];
    when(mockCache.get<List<EscalaModel>>('escalas_123'))
      .thenAnswer((_) async => cachedEscalas);
    when(mockCache.isExpired('escalas_123'))
      .thenReturn(false);
    
    // Act
    final result = await repository.getEscalasMotorista('123');
    
    // Assert
    expect(result, cachedEscalas);
    verifyNever(mockApiClient.get(any));
  });
  
  test('should fetch from API when cache is expired', () async {
    // Arrange
    when(mockCache.isExpired('escalas_123')).thenReturn(true);
    when(mockApiClient.get('/escalas/123'))
      .thenAnswer((_) async => {'data': [{'id': '1'}]});
    
    // Act
    final result = await repository.getEscalasMotorista('123');
    
    // Assert
    verify(mockApiClient.get('/escalas/123')).called(1);
    verify(mockCache.set('escalas_123', any)).called(1);
  });
  
  test('should return cached data when network fails', () async {
    // Arrange
    final cachedEscalas = [EscalaModel(id: '1')];
    when(mockCache.get<List<EscalaModel>>('escalas_123'))
      .thenAnswer((_) async => cachedEscalas);
    when(mockApiClient.get('/escalas/123'))
      .thenThrow(NetworkException('No connection'));
    
    // Act
    final result = await repository.getEscalasMotorista('123', forceRefresh: true);
    
    // Assert
    expect(result, cachedEscalas);
  });
});
```

## 📚 Dependências Recomendadas

```yaml
dependencies:
  connectivity_plus: ^4.0.2    # Verificar conectividade
  sqflite: ^2.3.0             # Banco de dados local
  shared_preferences: ^2.2.2  # Preferências simples
  flutter_secure_storage: ^9.0.0 # Storage seguro
  uuid: ^3.0.7                 # IDs únicos

dev_dependencies:
  mockito: ^5.4.2              # Mocking para testes
```

## 🎯 Objetivos da Implementação

1. **Separação de Responsabilidades**: UI não conhece fonte de dados
2. **Cache Inteligente**: Performance e experiência offline
3. **Sincronização**: Dados consistentes entre local e remoto
4. **Tratamento de Erros**: Falhas específicas por contexto
5. **Testabilidade**: Fácil de mockar e testar
6. **Escalabilidade**: Padrões reutilizáveis para novos dados

## 🔄 Fluxo de Dados Típico

```
UI Component
    ↓ (solicita dados)
Repository
    ↓ (verifica cache)
Cache Manager
    ↓ (se cache inválido)
API Client
    ↓ (faz request)
API Server
    ↓ (retorna dados)
Repository
    ↓ (processa e cacheia)
UI Component (recebe dados)
```