// TODO: Implementar configurações do app
// TODO: Adicionar configurações de ambiente (dev/staging/prod)
// TODO: Implementar configurações de API
// TODO: Adicionar configurações de tema
// TODO: Implementar configurações de notificações
// TODO: Adicionar configurações de cache

class AppConfig {
  // TODO: Definir configurações de ambiente
  static const String environment = String.fromEnvironment('ENV', defaultValue: 'dev');
  
  // TODO: Configurações de API
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api-dev.prefeitura.com',
  );
  
  static const String apiVersion = '/v1';
  static const Duration timeout = Duration(seconds: 30);
  
  // TODO: Configurações de autenticação
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const Duration tokenRefreshThreshold = Duration(minutes: 5);
  
  // TODO: Configurações de cache
  static const Duration cacheTimeout = Duration(hours: 1);
  static const int maxCacheSize = 50; // MB
  
  // TODO: Configurações de tema
  static const String themeKey = 'app_theme';
  static const String fontSizeKey = 'font_size';
  static const String accessibilityKey = 'accessibility_enabled';
  
  // TODO: Configurações de notificações
  static const String fcmTokenKey = 'fcm_token';
  static const String notificationsEnabledKey = 'notifications_enabled';
  
  // TODO: Configurações de debug
  static bool get isDebug => environment == 'dev';
  static bool get isProduction => environment == 'prod';
  static bool get isStaging => environment == 'staging';
  
  // TODO: URLs específicas
  static String get loginUrl => '$baseUrl$apiVersion/auth/login';
  static String get logoutUrl => '$baseUrl$apiVersion/auth/logout';
  static String get refreshTokenUrl => '$baseUrl$apiVersion/auth/refresh';
  static String get escalasUrl => '$baseUrl$apiVersion/escalas';
  static String get despesasUrl => '$baseUrl$apiVersion/despesas';
  static String get chamadosUrl => '$baseUrl$apiVersion/chamados';
  static String get perfilUrl => '$baseUrl$apiVersion/perfil';
  
  // TODO: Configurações de validação
  static const int maxFileUploadSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageFormats = ['jpg', 'jpeg', 'png', 'gif'];
  static const List<String> allowedDocumentFormats = ['pdf', 'doc', 'docx'];
  
  // TODO: Configurações de localização
  static const String defaultLocale = 'pt_BR';
  static const List<String> supportedLocales = ['pt_BR', 'en_US'];
  
  // TODO: Métodos utilitários
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-App-Version': appVersion,
    'X-Platform': platform,
  };
  
  static String get appVersion => '1.0.0'; // TODO: Buscar do pubspec.yaml
  static String get platform => 'mobile'; // TODO: Detectar plataforma
  
  // TODO: Configurações de logging
  static bool get enableLogging => isDebug;
  static bool get enableCrashReporting => isProduction;
  static bool get enableAnalytics => !isDebug;
}