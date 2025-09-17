// TODO: Definir constantes do aplicativo
// TODO: Adicionar strings de localização
// TODO: Implementar constantes de validação
// TODO: Adicionar constantes de design
// TODO: Implementar constantes de API
// TODO: Adicionar constantes de cache

class AppConstants {
  // TODO: Informações do app
  static const String appName = 'App Motorista';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Aplicativo para motoristas da prefeitura';
  
  // TODO: Configurações de validação
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 50;
  static const int maxUsernameLength = 30;
  static const int maxEmailLength = 100;
  static const int maxDescriptionLength = 500;
  static const int maxCommentLength = 1000;
  
  // TODO: Configurações de upload
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif'];
  static const List<String> allowedDocumentTypes = ['pdf', 'doc', 'docx', 'txt'];
  
  // TODO: Configurações de cache
  static const Duration cacheExpiry = Duration(hours: 24);
  static const int maxCacheItems = 100;
  static const String cacheKey = 'app_cache';
  
  // TODO: Configurações de tempo
  static const Duration requestTimeout = Duration(seconds: 30);
  static const Duration refreshInterval = Duration(minutes: 5);
  static const Duration retryDelay = Duration(seconds: 2);
  static const int maxRetries = 3;
  
  // TODO: Chaves de storage local
  static const String userDataKey = 'user_data';
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String themeKey = 'app_theme';
  static const String languageKey = 'app_language';
  static const String notificationsKey = 'notifications_enabled';
  static const String biometricsKey = 'biometrics_enabled';
  
  // TODO: Strings de UI (migrar para localização)
  static const String loginTitle = 'Entrar';
  static const String logoutTitle = 'Sair';
  static const String emailLabel = 'E-mail';
  static const String passwordLabel = 'Senha';
  static const String forgotPasswordLabel = 'Esqueci minha senha';
  static const String loginButton = 'Entrar';
  static const String cancelButton = 'Cancelar';
  static const String saveButton = 'Salvar';
  static const String deleteButton = 'Excluir';
  static const String editButton = 'Editar';
  static const String viewButton = 'Visualizar';
  static const String nextButton = 'Próximo';
  static const String previousButton = 'Anterior';
  static const String confirmButton = 'Confirmar';
  static const String closeButton = 'Fechar';
  
  // TODO: Mensagens de erro (migrar para localização)
  static const String errorGeneric = 'Ocorreu um erro inesperado';
  static const String errorNetwork = 'Erro de conexão';
  static const String errorTimeout = 'Tempo limite excedido';
  static const String errorInvalidCredentials = 'Credenciais inválidas';
  static const String errorEmailInvalid = 'E-mail inválido';
  static const String errorPasswordWeak = 'Senha muito fraca';
  static const String errorFieldRequired = 'Campo obrigatório';
  static const String errorFileTooLarge = 'Arquivo muito grande';
  static const String errorFileTypeNotAllowed = 'Tipo de arquivo não permitido';
  
  // TODO: Mensagens de sucesso (migrar para localização)
  static const String successLogin = 'Login realizado com sucesso';
  static const String successLogout = 'Logout realizado com sucesso';
  static const String successSave = 'Dados salvos com sucesso';
  static const String successDelete = 'Item excluído com sucesso';
  static const String successUpdate = 'Dados atualizados com sucesso';
  static const String successUpload = 'Arquivo enviado com sucesso';
  
  // TODO: Configurações de design
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultRadius = 8.0;
  static const double smallRadius = 4.0;
  static const double largeRadius = 16.0;
  static const double defaultElevation = 2.0;
  static const double highElevation = 8.0;
  
  // TODO: Breakpoints para responsividade
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 1024.0;
  static const double desktopBreakpoint = 1440.0;
  
  // TODO: Configurações de animação
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration fastAnimation = Duration(milliseconds: 150);
  static const Duration slowAnimation = Duration(milliseconds: 500);
  
  // TODO: Endpoints da API (migrar para AppConfig)
  static const String apiVersion = 'v1';
  static const String authEndpoint = '/auth';
  static const String escalasEndpoint = '/escalas';
  static const String despesasEndpoint = '/despesas';
  static const String chamadosEndpoint = '/chamados';
  static const String perfilEndpoint = '/perfil';
  static const String uploadEndpoint = '/upload';
  
  // TODO: Status codes
  static const int statusOK = 200;
  static const int statusCreated = 201;
  static const int statusBadRequest = 400;
  static const int statusUnauthorized = 401;
  static const int statusForbidden = 403;
  static const int statusNotFound = 404;
  static const int statusInternalServerError = 500;
  
  // TODO: Regex patterns
  static const String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phonePattern = r'^\(\d{2}\)\s\d{4,5}-\d{4}$';
  static const String cpfPattern = r'^\d{3}\.\d{3}\.\d{3}-\d{2}$';
}