# 📡 API - Camada de Comunicação HTTP

## 📋 Propósito
Esta pasta contém toda a lógica de comunicação com APIs externas, incluindo:
- Cliente HTTP configurado e otimizado
- Interceptadores para autenticação automática
- Tratamento centralizado de erros de rede
- Retry automático e timeout configurável
- Logging de requests e responses (modo debug)

## 🏗️ Estrutura Recomendada

```
api/
├── README.md                    # Este arquivo
├── api_client.dart             # Cliente HTTP principal
├── interceptors/
│   ├── auth_interceptor.dart   # Injeta tokens automaticamente
│   ├── error_interceptor.dart  # Trata erros HTTP
│   ├── logging_interceptor.dart # Log de requests/responses
│   └── retry_interceptor.dart  # Retry automático
├── endpoints/
│   ├── auth_endpoints.dart     # URLs de autenticação
│   ├── escalas_endpoints.dart  # URLs de escalas
│   ├── despesas_endpoints.dart # URLs de despesas
│   └── chamados_endpoints.dart # URLs de chamados
└── exceptions/
    ├── api_exception.dart      # Exceções customizadas
    ├── network_exception.dart  # Erros de rede
    └── timeout_exception.dart  # Erros de timeout
```

## 🚀 Como Usar

### 1. Configuração Inicial
```dart
// No main.dart ou app initialization
await ApiClient.instance.initialize();
```

### 2. Uso Básico
```dart
// GET request
final response = await ApiClient.instance.get('/escalas');

// POST request
final response = await ApiClient.instance.post(
  '/auth/login',
  body: {'email': 'user@email.com', 'password': '123456'},
);

// Upload de arquivo
final response = await ApiClient.instance.uploadFile(
  '/despesas/comprovante',
  file,
  fields: {'despesa_id': '123'},
);
```

### 3. Configuração de Token
```dart
// Definir token globalmente
ApiClient.instance.setAuthToken('Bearer jwt_token_here');

// Remover token
ApiClient.instance.clearAuthToken();
```

## 💡 Melhores Práticas

### ✅ **Implementar Interceptadores**
```dart
class AuthInterceptor {
  void onRequest(RequestOptions options) {
    final token = AuthService.instance.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
  }
}
```

### ✅ **Tratamento de Erros Centralizado**
```dart
class ErrorInterceptor {
  void onError(DioError error) {
    switch (error.response?.statusCode) {
      case 401:
        // Token expirado - redirecionar para login
        AuthService.instance.logout();
        break;
      case 500:
        // Erro do servidor - mostrar mensagem amigável
        showErrorSnackbar('Erro interno do servidor');
        break;
    }
  }
}
```

### ✅ **Configuração de Timeout e Retry**
```dart
ApiClient.instance.configure(
  timeout: Duration(seconds: 30),
  retries: 3,
  retryDelay: Duration(seconds: 2),
);
```

### ✅ **Logging Condicional**
```dart
if (AppConfig.isDebug) {
  ApiClient.instance.enableLogging();
}
```

## 🔧 Implementação Ideal

### 1. **Cliente HTTP Singleton**
- Uma única instância reutilizada em todo o app
- Configuração centralizada de timeouts e headers
- Interceptadores registrados globalmente

### 2. **Interceptadores Modulares**
- Cada interceptador tem uma responsabilidade específica
- Facilita manutenção e testes unitários
- Permite ativar/desativar funcionalidades

### 3. **Endpoints Organizados**
- URLs agrupadas por módulo/funcionalidade
- Constantes para evitar URLs hardcoded
- Facilita mudanças de ambiente (dev/prod)

### 4. **Exceções Customizadas**
- Tipos específicos de erro para cada situação
- Mensagens de erro amigáveis ao usuário
- Stack trace preservado para debugging

### 5. **Cache de Responses**
- Cache automático para requests GET
- Invalidação inteligente de cache
- Modo offline com fallback para cache

## 🧪 Testes Recomendados

```dart
// Mock do cliente HTTP
class MockApiClient extends Mock implements ApiClient {}

// Teste de interceptador
test('should add auth token to request', () {
  final interceptor = AuthInterceptor();
  final options = RequestOptions(path: '/test');
  
  interceptor.onRequest(options);
  
  expect(options.headers['Authorization'], 'Bearer token');
});

// Teste de erro handling
test('should handle 401 error correctly', () {
  // Simular erro 401 e verificar comportamento
});
```

## 📚 Dependências Recomendadas

```yaml
dependencies:
  dio: ^5.3.2              # Cliente HTTP robusto
  connectivity_plus: ^4.0.2 # Verificar conectividade
  flutter_secure_storage: ^9.0.0 # Storage seguro para tokens

dev_dependencies:
  mockito: ^5.4.2          # Mocking para testes
```

## 🎯 Objetivos da Implementação

1. **Confiabilidade**: Retry automático e tratamento de erros
2. **Segurança**: Tokens seguros e headers apropriados
3. **Performance**: Cache inteligente e timeouts otimizados
4. **Manutenibilidade**: Código modular e bem testado
5. **Debugging**: Logs detalhados em desenvolvimento