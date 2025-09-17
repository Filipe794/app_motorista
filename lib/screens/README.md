# 📱 Screens - Camada de Interface do Usuário

## 📋 Propósito
Esta pasta contém todas as telas (páginas) do aplicativo, organizadas por módulo funcional:
- Interfaces completas e responsivas
- Gerenciamento de estado local
- Navegação entre telas
- Validação de formulários
- Integração com serviços e repositórios

## 🏗️ Estrutura Recomendada

```
screens/
├── README.md                    # Este arquivo
├── splash_screen.dart           # Tela de carregamento inicial
├── login_screen.dart            # Tela de login
├── forgot_password_screen.dart  # Recuperação de senha
├── tela_inicial.dart           # Dashboard principal ✅ IMPLEMENTADA
├── auth/
│   ├── login_screen.dart       # Variação modular do login
│   ├── register_screen.dart    # Cadastro de usuário
│   └── verify_email_screen.dart # Verificação de email
├── escalas/
│   ├── escalas_screen.dart     # Lista de escalas
│   ├── detalhes_escala_screen.dart # Detalhes de uma escala
│   ├── calendario_escalas_screen.dart # Calendário de escalas
│   └── confirmar_presenca_screen.dart # Confirmação de presença
├── despesas/
│   ├── despesas_screen.dart    # Lista de despesas
│   ├── nova_despesa_screen.dart # Criar nova despesa
│   ├── editar_despesa_screen.dart # Editar despesa existente
│   ├── detalhes_despesa_screen.dart # Visualizar despesa
│   └── relatorio_despesas_screen.dart # Relatório de despesas
├── chamados/
│   ├── chamados_screen.dart    # Lista de chamados
│   ├── novo_chamado_screen.dart # Criar novo chamado
│   ├── detalhes_chamado_screen.dart # Visualizar chamado
│   └── chat_chamado_screen.dart # Chat do chamado
├── perfil/
│   ├── perfil_screen.dart      # Visualizar perfil
│   ├── editar_perfil_screen.dart # Editar dados do perfil
│   ├── alterar_senha_screen.dart # Alterar senha
│   ├── configuracoes_screen.dart # Configurações do app
│   └── sobre_screen.dart       # Sobre o aplicativo
└── common/
    ├── error_screen.dart       # Tela de erro genérica
    ├── loading_screen.dart     # Tela de carregamento
    ├── no_internet_screen.dart # Sem conexão
    └── maintenance_screen.dart # Manutenção do sistema
```

## 🚀 Como Usar

### 1. Navegação Básica
```dart
// Navegar para uma tela
Navigator.pushNamed(context, '/escalas');

// Navegar com dados
Navigator.pushNamed(
  context, 
  '/detalhes-escala',
  arguments: {'escalaId': '123'},
);

// Substituir tela atual
Navigator.pushReplacementNamed(context, '/home');

// Voltar à tela anterior
Navigator.pop(context);
```

### 2. Passagem de Parâmetros
```dart
// Na tela que navega
Navigator.pushNamed(
  context,
  '/editar-perfil',
  arguments: UserModel(id: '123', nome: 'João'),
);

// Na tela de destino
class EditarPerfilScreen extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as UserModel;
    // Usar o objeto user...
  }
}
```

### 3. Gerenciamento de Estado
```dart
class EscalasScreen extends StatefulWidget {
  @override
  _EscalasScreenState createState() => _EscalasScreenState();
}

class _EscalasScreenState extends State<EscalasScreen> {
  List<EscalaModel> escalas = [];
  bool isLoading = true;
  String? error;
  
  @override
  void initState() {
    super.initState();
    _loadEscalas();
  }
  
  Future<void> _loadEscalas() async {
    try {
      setState(() => isLoading = true);
      final result = await EscalasService.instance.getEscalas();
      setState(() {
        escalas = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }
}
```

## 💡 Melhores Práticas

### ✅ **Estrutura de Tela Responsiva**
```dart
class ResponsiveScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isMobile(context) 
        ? AppBar(title: Text('Título'))
        : null,
      body: ResponsiveHelper.buildResponsive(
        context: context,
        mobile: _buildMobileLayout(),
        tablet: _buildTabletLayout(),
        desktop: _buildDesktopLayout(),
      ),
    );
  }
  
  Widget _buildMobileLayout() {
    return Column(
      children: [
        // Layout para mobile
      ],
    );
  }
  
  Widget _buildTabletLayout() {
    return Row(
      children: [
        // Layout para tablet
      ],
    );
  }
  
  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Layout para desktop com sidebar
      ],
    );
  }
}
```

### ✅ **Tratamento de Estados de Loading e Erro**
```dart
class StatefulDataScreen extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    
    if (error != null) {
      return ErrorWidget(
        error: error!,
        onRetry: _loadData,
      );
    }
    
    if (data.isEmpty) {
      return const EmptyStateWidget(
        message: 'Nenhum item encontrado',
      );
    }
    
    return _buildDataContent();
  }
}
```

### ✅ **Formulários com Validação**
```dart
class FormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nomeController,
            decoration: const InputDecoration(labelText: 'Nome'),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Nome é obrigatório';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Email é obrigatório';
              }
              if (!EmailValidator.isValid(value!)) {
                return 'Email inválido';
              }
              return null;
            },
          ),
          ElevatedButton(
            onPressed: _submitForm,
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
  
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Processar dados do formulário
    }
  }
  
  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
```

### ✅ **Integração com Serviços**
```dart
class ServiceIntegratedScreen extends StatefulWidget {
  @override
  _ServiceIntegratedScreenState createState() => _ServiceIntegratedScreenState();
}

class _ServiceIntegratedScreenState extends State<ServiceIntegratedScreen> {
  final _escalasService = EscalasService.instance;
  
  Future<void> _confirmarPresenca(String escalaId) async {
    try {
      // Mostrar loading
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Confirmando presença...')),
      );
      
      final success = await _escalasService.confirmarPresenca(escalaId);
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Presença confirmada!')),
        );
        _refreshData();
      } else {
        _showError('Erro ao confirmar presença');
      }
    } catch (e) {
      _showError('Erro: ${e.toString()}');
    }
  }
  
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
```

### ✅ **Acessibilidade e Semântica**
```dart
Widget build(BuildContext context) {
  return Semantics(
    label: 'Lista de escalas',
    child: ListView.builder(
      itemCount: escalas.length,
      itemBuilder: (context, index) {
        final escala = escalas[index];
        return Semantics(
          label: 'Escala ${escala.dataInicio}',
          button: true,
          child: ListTile(
            title: Text(escala.titulo),
            subtitle: Text(escala.dataInicio.toString()),
            onTap: () => _abrirDetalhes(escala),
          ),
        );
      },
    ),
  );
}
```

## 🔧 Implementação Ideal

### 1. **Base Screen Reutilizável**
```dart
abstract class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);
}

abstract class BaseScreenState<T extends BaseScreen> extends State<T> {
  bool isLoading = false;
  String? error;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: SafeArea(
        child: buildBody(),
      ),
      floatingActionButton: buildFAB(),
    );
  }
  
  PreferredSizeWidget? buildAppBar();
  Widget buildBody();
  Widget? buildFAB() => null;
  
  void showLoading() => setState(() => isLoading = true);
  void hideLoading() => setState(() => isLoading = false);
  void showError(String message) => setState(() => error = message);
  void clearError() => setState(() => error = null);
}
```

### 2. **Screen Factory para Navegação**
```dart
class ScreenFactory {
  static Route<dynamic> createRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/escalas':
        return MaterialPageRoute(
          builder: (_) => const EscalasScreen(),
          settings: settings,
        );
      case '/detalhes-escala':
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => DetalhesEscalaScreen(
            escalaId: args['escalaId'],
          ),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const ErrorScreen(),
        );
    }
  }
}
```

### 3. **Mixin para Funcionalidades Comuns**
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  void showSuccess(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
```

### 4. **Widget de Estado Condicional**
```dart
class ConditionalWidget extends StatelessWidget {
  final bool isLoading;
  final String? error;
  final bool isEmpty;
  final Widget child;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final Widget? emptyWidget;
  final VoidCallback? onRetry;
  
  const ConditionalWidget({
    Key? key,
    required this.isLoading,
    required this.child,
    this.error,
    this.isEmpty = false,
    this.loadingWidget,
    this.errorWidget,
    this.emptyWidget,
    this.onRetry,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return loadingWidget ?? const Center(child: CircularProgressIndicator());
    }
    
    if (error != null) {
      return errorWidget ?? ErrorStateWidget(
        message: error!,
        onRetry: onRetry,
      );
    }
    
    if (isEmpty) {
      return emptyWidget ?? const EmptyStateWidget();
    }
    
    return child;
  }
}
```

## 🧪 Testes Recomendados

```dart
group('EscalasScreen', () {
  testWidgets('should display loading indicator initially', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: EscalasScreen()),
    );
    
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
  
  testWidgets('should display escalas after loading', (tester) async {
    // Mock do serviço
    when(mockEscalasService.getEscalas())
      .thenAnswer((_) async => [
        EscalaModel(id: '1', titulo: 'Escala 1'),
        EscalaModel(id: '2', titulo: 'Escala 2'),
      ]);
    
    await tester.pumpWidget(
      MaterialApp(home: EscalasScreen()),
    );
    
    // Aguardar carregamento
    await tester.pumpAndSettle();
    
    expect(find.text('Escala 1'), findsOneWidget);
    expect(find.text('Escala 2'), findsOneWidget);
  });
  
  testWidgets('should navigate to details when item tapped', (tester) async {
    // Setup mock e widget
    
    await tester.tap(find.text('Escala 1'));
    await tester.pumpAndSettle();
    
    // Verificar se navegou
    expect(find.byType(DetalhesEscalaScreen), findsOneWidget);
  });
});
```

## 📚 Dependências Recomendadas

```yaml
dependencies:
  flutter_bloc: ^8.1.3         # Gerenciamento de estado
  go_router: ^10.1.2           # Roteamento declarativo
  form_validator: ^2.1.1       # Validação de formulários
  flutter_screenutil: ^5.9.0   # Responsividade
  shimmer: ^3.0.0              # Efeito de loading
  pull_to_refresh: ^2.0.0      # Pull-to-refresh

dev_dependencies:
  flutter_test: any
  mockito: ^5.4.2              # Mocking para testes
```

## 🎯 Objetivos da Implementação

1. **Responsividade**: Adaptação automática a diferentes tamanhos
2. **Acessibilidade**: Suporte completo a screen readers
3. **Performance**: Carregamento otimizado e lazy loading
4. **UX Consistente**: Padrões visuais unificados
5. **Testabilidade**: Widgets facilmente testáveis
6. **Manutenibilidade**: Código organizado e reutilizável

## 🔄 Ciclo de Vida Típico

```
initState()
    ↓
loadData() → setState() → build()
    ↓
User Interaction
    ↓
handleAction() → setState() → build()
    ↓
dispose()
```