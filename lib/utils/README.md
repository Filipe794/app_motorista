# 🔧 Utils - Utilitários e Helpers

## 📋 Propósito
Esta pasta contém utilitários, helpers e funcionalidades transversais que são usadas em todo o aplicativo:
- Funções auxiliares reutilizáveis
- Constantes e configurações
- Extensões e mixins
- Validadores e formatadores
- Helpers para responsividade e design

## 🏗️ Estrutura Recomendada

```
utils/
├── README.md                    # Este arquivo
├── app_config.dart             # Configurações do aplicativo
├── app_constants.dart          # Constantes globais
├── app_routes.dart             # Definições de rotas
├── responsive_helper.dart      # Helper de responsividade ✅ IMPLEMENTADO
├── theme/
│   ├── app_theme.dart          # Tema principal do app
│   ├── app_colors.dart         # Paleta de cores
│   ├── app_text_styles.dart    # Estilos de texto
│   └── app_dimensions.dart     # Dimensões e espaçamentos
├── validators/
│   ├── form_validators.dart    # Validadores de formulário
│   ├── cpf_validator.dart      # Validador de CPF
│   ├── email_validator.dart    # Validador de email
│   └── phone_validator.dart    # Validador de telefone
├── formatters/
│   ├── date_formatter.dart     # Formatação de datas
│   ├── currency_formatter.dart # Formatação de moeda
│   ├── phone_formatter.dart    # Formatação de telefone
│   └── text_formatters.dart    # Formatadores de texto
├── extensions/
│   ├── string_extensions.dart  # Extensões para String
│   ├── datetime_extensions.dart # Extensões para DateTime
│   ├── context_extensions.dart # Extensões para BuildContext
│   └── widget_extensions.dart  # Extensões para Widget
├── mixins/
│   ├── loading_mixin.dart      # Mixin para loading states
│   ├── error_handling_mixin.dart # Mixin para tratamento de erros
│   └── keyboard_mixin.dart     # Mixin para controle do teclado
└── helpers/
    ├── image_helper.dart       # Helper para imagens
    ├── file_helper.dart        # Helper para arquivos
    ├── permission_helper.dart  # Helper para permissões
    ├── device_helper.dart      # Informações do dispositivo
    └── encryption_helper.dart  # Helper para criptografia
```

## 🚀 Como Usar

### 1. Configurações do App
```dart
// Acessar configurações
final apiUrl = AppConfig.baseUrl;
final isDebug = AppConfig.isDebug;

// Usar constantes
final maxFileSize = AppConstants.maxFileUploadSize;
final emailPattern = AppConstants.emailPattern;
```

### 2. Responsividade
```dart
// Verificar tipo de dispositivo
if (ResponsiveHelper.isMobile(context)) {
  return MobileLayout();
} else if (ResponsiveHelper.isTablet(context)) {
  return TabletLayout();
} else {
  return DesktopLayout();
}

// Usar dimensões responsivas
final padding = context.responsivePadding(16.0);
final fontSize = context.responsiveFontSize(14.0);
```

### 3. Validação de Dados
```dart
// Validar email
if (EmailValidator.isValid(email)) {
  // Email válido
}

// Validar CPF
if (CPFValidator.isValid(cpf)) {
  // CPF válido
}

// Validar formulário
final validation = FormValidators.validateRequired(value, 'Nome');
if (!validation.isValid) {
  return validation.error;
}
```

### 4. Formatação
```dart
// Formatar data
final formattedDate = DateFormatter.formatBR(DateTime.now());

// Formatar moeda
final formattedCurrency = CurrencyFormatter.formatBRL(1234.56);

// Formatar telefone
final formattedPhone = PhoneFormatter.format('11999999999');
```

### 5. Extensões
```dart
// String extensions
final isEmail = 'test@email.com'.isEmail;
final capitalized = 'hello world'.capitalize();

// DateTime extensions
final isToday = DateTime.now().isToday;
final formatted = DateTime.now().toBrazilianFormat();

// Context extensions
final screenWidth = context.screenWidth;
final theme = context.theme;
```

## 💡 Melhores Práticas

### ✅ **Configurações Tipadas e Organizadas**
```dart
class AppConfig {
  // Ambiente
  static const environment = String.fromEnvironment('ENV', defaultValue: 'dev');
  
  // APIs
  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api-dev.example.com',
  );
  
  // Features flags
  static const enableAnalytics = bool.fromEnvironment('ENABLE_ANALYTICS', defaultValue: false);
  static const enableCrashReporting = bool.fromEnvironment('ENABLE_CRASH_REPORTING', defaultValue: false);
  
  // Computed properties
  static bool get isDebug => environment == 'dev';
  static bool get isProduction => environment == 'prod';
  
  // URLs derivadas
  static String get loginUrl => '$baseUrl/auth/login';
  static String get escalasUrl => '$baseUrl/escalas';
}
```

### ✅ **Constantes Bem Organizadas**
```dart
class AppConstants {
  // Não permitir instanciação
  AppConstants._();
  
  // Validação
  static const int minPasswordLength = 8;
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  
  // UI
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 8.0;
  static const Duration animationDuration = Duration(milliseconds: 300);
  
  // Regex patterns
  static const String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phonePattern = r'^\(\d{2}\)\s\d{4,5}-\d{4}$';
  
  // Messages
  static const String errorGeneric = 'Ocorreu um erro inesperado';
  static const String successSave = 'Dados salvos com sucesso';
}
```

### ✅ **Extensões Úteis e Seguras**
```dart
extension StringExtensions on String {
  bool get isEmail => RegExp(AppConstants.emailPattern).hasMatch(this);
  
  bool get isNotNullOrEmpty => isNotEmpty;
  
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
  
  String removeSpecialCharacters() {
    return replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '');
  }
  
  String? nullIfEmpty() => isEmpty ? null : this;
}

extension DateTimeExtensions on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
  
  String toBrazilianFormat() {
    return DateFormatter.formatBR(this);
  }
  
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

extension BuildContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
  
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  
  bool get isKeyboardVisible => MediaQuery.of(this).viewInsets.bottom > 0;
  
  void hideKeyboard() => FocusScope.of(this).unfocus();
  
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? colorScheme.error : null,
      ),
    );
  }
}
```

### ✅ **Validadores Robustos**
```dart
class ValidationResult {
  final bool isValid;
  final String? error;
  
  const ValidationResult.valid() : isValid = true, error = null;
  const ValidationResult.invalid(this.error) : isValid = false;
}

class FormValidators {
  static ValidationResult validateRequired(String? value, String fieldName) {
    if (value?.trim().isEmpty ?? true) {
      return ValidationResult.invalid('$fieldName é obrigatório');
    }
    return const ValidationResult.valid();
  }
  
  static ValidationResult validateEmail(String? value) {
    if (value?.isEmpty ?? true) {
      return const ValidationResult.invalid('Email é obrigatório');
    }
    
    if (!value!.isEmail) {
      return const ValidationResult.invalid('Email inválido');
    }
    
    return const ValidationResult.valid();
  }
  
  static ValidationResult validatePassword(String? value) {
    if (value?.isEmpty ?? true) {
      return const ValidationResult.invalid('Senha é obrigatória');
    }
    
    if (value!.length < AppConstants.minPasswordLength) {
      return ValidationResult.invalid(
        'Senha deve ter pelo menos ${AppConstants.minPasswordLength} caracteres',
      );
    }
    
    return const ValidationResult.valid();
  }
}

class CPFValidator {
  static bool isValid(String cpf) {
    final cleanCPF = cpf.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (cleanCPF.length != 11) return false;
    if (RegExp(r'^(\d)\1*$').hasMatch(cleanCPF)) return false;
    
    return _validateDigits(cleanCPF);
  }
  
  static bool _validateDigits(String cpf) {
    // Implementação dos dígitos verificadores do CPF
    // ... lógica de validação
    return true; // Placeholder
  }
}
```

### ✅ **Formatadores Consistentes**
```dart
class DateFormatter {
  static String formatBR(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
  
  static String formatBRWithTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }
  
  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return 'há ${difference.inDays} ${difference.inDays == 1 ? 'dia' : 'dias'}';
    } else if (difference.inHours > 0) {
      return 'há ${difference.inHours} ${difference.inHours == 1 ? 'hora' : 'horas'}';
    } else if (difference.inMinutes > 0) {
      return 'há ${difference.inMinutes} ${difference.inMinutes == 1 ? 'minuto' : 'minutos'}';
    } else {
      return 'agora';
    }
  }
}

class CurrencyFormatter {
  static String formatBRL(double value) {
    return NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    ).format(value);
  }
  
  static double? parseBRL(String value) {
    final cleanValue = value
        .replaceAll('R\$', '')
        .replaceAll('.', '')
        .replaceAll(',', '.')
        .trim();
    
    return double.tryParse(cleanValue);
  }
}
```

### ✅ **Mixins Reutilizáveis**
```dart
mixin LoadingMixin<T extends StatefulWidget> on State<T> {
  bool _isLoading = false;
  
  bool get isLoading => _isLoading;
  
  void setLoading(bool loading) {
    if (mounted) {
      setState(() => _isLoading = loading);
    }
  }
  
  Future<R> executeWithLoading<R>(Future<R> Function() action) async {
    setLoading(true);
    try {
      return await action();
    } finally {
      setLoading(false);
    }
  }
}

mixin ErrorHandlingMixin<T extends StatefulWidget> on State<T> {
  void showError(String message) {
    if (mounted) {
      context.showSnackBar(message, isError: true);
    }
  }
  
  void showSuccess(String message) {
    if (mounted) {
      context.showSnackBar(message);
    }
  }
  
  void handleError(dynamic error) {
    String message = AppConstants.errorGeneric;
    
    if (error is ValidationException) {
      message = error.message;
    } else if (error is NetworkException) {
      message = 'Erro de conexão';
    }
    
    showError(message);
  }
}
```

## 🔧 Implementação Ideal

### 1. **Tema Responsivo e Acessível**
```dart
class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ),
    textTheme: _buildTextTheme(),
    elevatedButtonTheme: _buildButtonTheme(),
    inputDecorationTheme: _buildInputTheme(),
  );
  
  static TextTheme _buildTextTheme() {
    return const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        height: 1.2,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        height: 1.5,
      ),
    );
  }
}
```

### 2. **Helper de Permissões**
```dart
class PermissionHelper {
  static Future<bool> requestCamera() async {
    final permission = await Permission.camera.request();
    return permission.isGranted;
  }
  
  static Future<bool> requestLocation() async {
    final permission = await Permission.location.request();
    return permission.isGranted;
  }
  
  static Future<bool> hasPermission(Permission permission) async {
    final status = await permission.status;
    return status.isGranted;
  }
  
  static Future<void> openAppSettings() async {
    await openAppSettings();
  }
}
```

### 3. **Helper de Arquivos**
```dart
class FileHelper {
  static Future<File?> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    return image != null ? File(image.path) : null;
  }
  
  static Future<bool> isValidImageSize(File file) async {
    final size = await file.length();
    return size <= AppConstants.maxFileSize;
  }
  
  static String getFileExtension(String path) {
    return path.split('.').last.toLowerCase();
  }
  
  static bool isValidImageType(String path) {
    final extension = getFileExtension(path);
    return AppConstants.allowedImageFormats.contains(extension);
  }
}
```

## 🧪 Testes Recomendados

```dart
group('FormValidators', () {
  test('should validate required field correctly', () {
    expect(
      FormValidators.validateRequired(null, 'Nome').isValid,
      false,
    );
    expect(
      FormValidators.validateRequired('', 'Nome').isValid,
      false,
    );
    expect(
      FormValidators.validateRequired('João', 'Nome').isValid,
      true,
    );
  });
  
  test('should validate email correctly', () {
    expect(
      FormValidators.validateEmail('invalid-email').isValid,
      false,
    );
    expect(
      FormValidators.validateEmail('valid@email.com').isValid,
      true,
    );
  });
});

group('StringExtensions', () {
  test('should capitalize string correctly', () {
    expect('hello world'.capitalize(), 'Hello world');
    expect(''.capitalize(), '');
    expect('HELLO'.capitalize(), 'Hello');
  });
  
  test('should validate email correctly', () {
    expect('test@email.com'.isEmail, true);
    expect('invalid-email'.isEmail, false);
  });
});

group('DateTimeExtensions', () {
  test('should check if date is today', () {
    expect(DateTime.now().isToday, true);
    expect(DateTime.now().subtract(Duration(days: 1)).isToday, false);
  });
});
```

## 📚 Dependências Recomendadas

```yaml
dependencies:
  intl: ^0.18.1                # Formatação de números e datas
  permission_handler: ^11.0.1  # Gerenciamento de permissões
  image_picker: ^1.0.4         # Seleção de imagens
  crypto: ^3.0.3               # Criptografia
  path: ^1.8.3                 # Manipulação de paths

dev_dependencies:
  flutter_test: any
```

## 🎯 Objetivos da Implementação

1. **Reutilização**: Código compartilhado em todo o app
2. **Consistência**: Padrões unificados de formatação e validação
3. **Performance**: Helpers otimizados e cache quando necessário
4. **Manutenibilidade**: Código bem organizado e documentado
5. **Testabilidade**: Funções puras facilmente testáveis
6. **Configurabilidade**: Flexibilidade para diferentes ambientes

## 🔄 Organização por Responsabilidade

```
Configuração    → app_config.dart, app_constants.dart
Tema/Design     → theme/, app_dimensions.dart
Validação       → validators/, form_validators.dart
Formatação      → formatters/, date_formatter.dart
Extensões       → extensions/, string_extensions.dart
Helpers         → helpers/, device_helper.dart
Mixins          → mixins/, loading_mixin.dart
Responsividade  → responsive_helper.dart
```