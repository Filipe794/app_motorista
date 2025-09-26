// TODO: Definir constantes do aplicativo
// TODO: Adicionar strings de localização
// TODO: Implementar constantes de validação
// TODO: Adicionar constantes de design
// TODO: Implementar constantes de API
// TODO: Adicionar constantes de cache

// Application Constants
class AppConstants {
  // TODO: Informações do app
  static const String appName = 'App Motorista';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Aplicativo para motoristas da prefeitura';
  
  // TODO: Configurações de validação
  static const int maxRetryAttempts = 3;
  static const int requestTimeout = 30; // seconds
  
  // TODO: Configurações de localização
  static const double locationUpdateInterval = 5.0; // seconds
  static const double minLocationAccuracy = 50.0; // meters
  
  // TODO: Configurações de cache
  static const Duration cacheExpiry = Duration(hours: 24);
  static const int maxCacheSize = 100; // MB
  
  // TODO: URLs da API
  static const String baseUrl = 'https://api.prefeitura.com';
  static const String authEndpoint = '/auth';
  static const String routesEndpoint = '/routes';
  static const String driversEndpoint = '/drivers';
  
  // TODO: Configurações de mapa
  static const double defaultZoom = 15.0;
  static const double maxZoom = 20.0;
  static const double minZoom = 5.0;
  
  // TODO: Configurações de notificação
  static const String channelId = 'bus_tracking';
  static const String channelName = 'Bus Tracking';
  static const String channelDescription = 'Notifications for bus tracking';
  
  // TODO: Configurações de segurança
  static const int tokenExpiryMinutes = 60;
  static const int refreshTokenDays = 30;
  
  // TODO: Configurações de logs
  static const int maxLogEntries = 1000;
  static const Duration logRetentionPeriod = Duration(days: 30);
  
  // TODO: Configurações de sincronização
  static const Duration syncInterval = Duration(minutes: 15);
  static const int maxSyncRetries = 5;
  
  // TODO: Mensagens de erro
  static const String networkErrorMessage = 'Erro de conexão. Tente novamente.';
  static const String authErrorMessage = 'Erro de autenticação. Faça login novamente.';
  static const String locationErrorMessage = 'Erro ao obter localização.';
  static const String generalErrorMessage = 'Erro inesperado. Tente novamente.';
  
  // TODO: Regex patterns
  static const String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phonePattern = r'^\(\d{2}\) \d{4,5}-\d{4}$';
  static const String cpfPattern = r'^\d{3}\.\d{3}\.\d{3}-\d{2}$';
  
  // TODO: Configurações de tema
  static const double borderRadius = 8.0;
  static const double elevation = 2.0;
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  
  // TODO: Configurações de animação
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration splashDuration = Duration(seconds: 3);
}

// Enums para status
enum BusStatus {
  idle,
  moving,
  stopped,
  maintenance,
}

enum RouteStatus {
  active,
  inactive,
  suspended,
}

enum DriverStatus {
  available,
  busy,
  offline,
}