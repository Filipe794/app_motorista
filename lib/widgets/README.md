# 🧩 Widgets - Componentes Reutilizáveis

## 📋 Propósito
Esta pasta contém widgets personalizados e reutilizáveis que compõem a interface do usuário:
- Componentes visuais customizados
- Widgets responsivos e acessíveis
- Elementos de UI complexos e especializados
- Wrappers para funcionalidades comuns
- Widgets de layout e estrutura

## 🏗️ Estrutura Recomendada

```
widgets/
├── README.md                    # Este arquivo
├── app_header.dart             # Cabeçalho do app ✅ IMPLEMENTADO
├── navigation_grid.dart        # Grid de navegação ✅ IMPLEMENTADO
├── next_shift_card.dart        # Card da próxima escala ✅ IMPLEMENTADO
├── notices_card.dart           # Card de avisos ✅ IMPLEMENTADO
├── common/
│   ├── custom_button.dart      # Botão personalizado
│   ├── custom_text_field.dart  # Campo de texto personalizado
│   ├── loading_widget.dart     # Widget de carregamento
│   ├── error_widget.dart       # Widget de erro
│   ├── empty_state_widget.dart # Estado vazio
│   └── confirmation_dialog.dart # Dialog de confirmação
├── forms/
│   ├── form_field_wrapper.dart # Wrapper para campos de formulário
│   ├── date_picker_field.dart  # Campo de seleção de data
│   ├── file_picker_field.dart  # Campo de seleção de arquivo
│   └── dropdown_field.dart     # Campo dropdown personalizado
├── cards/
│   ├── escala_card.dart        # Card de escala
│   ├── despesa_card.dart       # Card de despesa
│   ├── chamado_card.dart       # Card de chamado
│   └── info_card.dart          # Card informativo genérico
├── lists/
│   ├── custom_list_view.dart   # ListView personalizada
│   ├── paginated_list.dart     # Lista com paginação
│   ├── search_list.dart        # Lista com busca
│   └── pull_to_refresh_list.dart # Lista com pull-to-refresh
└── layout/
    ├── responsive_layout.dart  # Layout responsivo
    ├── side_menu.dart         # Menu lateral
    ├── bottom_sheet_wrapper.dart # Wrapper para bottom sheet
    └── modal_wrapper.dart     # Wrapper para modais
```

## 🚀 Como Usar

### 1. Widgets Básicos
```dart
// Botão personalizado
CustomButton(
  text: 'Salvar',
  onPressed: () => _saveData(),
  isLoading: _isLoading,
  variant: ButtonVariant.primary,
)

// Campo de texto personalizado
CustomTextField(
  label: 'Email',
  hint: 'Digite seu email',
  validator: EmailValidator.validate,
  keyboardType: TextInputType.emailAddress,
)

// Widget de carregamento
LoadingWidget(
  message: 'Carregando dados...',
  size: LoadingSize.large,
)
```

### 2. Widgets de Layout
```dart
// Layout responsivo
ResponsiveLayout(
  mobile: _buildMobileLayout(),
  tablet: _buildTabletLayout(),
  desktop: _buildDesktopLayout(),
)

// Wrapper para formulários
FormFieldWrapper(
  label: 'Nome Completo',
  isRequired: true,
  child: TextFormField(
    // configurações do campo
  ),
)
```

### 3. Widgets de Estado
```dart
// Estado vazio
EmptyStateWidget(
  icon: Icons.inbox,
  title: 'Nenhuma escala encontrada',
  message: 'Você não possui escalas cadastradas',
  actionButton: CustomButton(
    text: 'Atualizar',
    onPressed: _refresh,
  ),
)

// Widget de erro
ErrorWidget(
  error: 'Erro ao carregar dados',
  onRetry: _retry,
  showDetails: AppConfig.isDebug,
)
```

### 4. Widgets Especializados
```dart
// Card de escala
EscalaCard(
  escala: escalaModel,
  onTap: () => _openDetails(escalaModel),
  onConfirm: () => _confirmPresence(escalaModel),
  showActions: true,
)

// Lista paginada
PaginatedList<EscalaModel>(
  items: escalas,
  itemBuilder: (context, escala) => EscalaCard(escala: escala),
  onLoadMore: _loadMoreEscalas,
  hasMore: hasMoreEscalas,
)
```

## 💡 Melhores Práticas

### ✅ **Widget Base Reutilizável**
```dart
abstract class BaseWidget extends StatelessWidget {
  const BaseWidget({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: getSemanticLabel(),
      child: buildContent(context),
    );
  }
  
  Widget buildContent(BuildContext context);
  String? getSemanticLabel() => null;
}

// Implementação específica
class CustomButton extends BaseWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonVariant variant;
  
  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.variant = ButtonVariant.primary,
  }) : super(key: key);
  
  @override
  Widget buildContent(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: _getButtonStyle(context),
      child: isLoading 
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Text(text),
    );
  }
  
  @override
  String? getSemanticLabel() => '$text, ${isLoading ? 'carregando' : 'botão'}';
  
  ButtonStyle _getButtonStyle(BuildContext context) {
    switch (variant) {
      case ButtonVariant.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: context.colorScheme.primary,
          foregroundColor: context.colorScheme.onPrimary,
        );
      case ButtonVariant.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: context.colorScheme.secondary,
          foregroundColor: context.colorScheme.onSecondary,
        );
      case ButtonVariant.danger:
        return ElevatedButton.styleFrom(
          backgroundColor: context.colorScheme.error,
          foregroundColor: context.colorScheme.onError,
        );
    }
  }
}

enum ButtonVariant { primary, secondary, danger }
```

### ✅ **Widget Responsivo e Acessível**
```dart
class ResponsiveCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double? elevation;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  
  const ResponsiveCard({
    Key? key,
    required this.child,
    this.padding,
    this.elevation,
    this.backgroundColor,
    this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final responsivePadding = padding ?? EdgeInsets.all(
      ResponsiveHelper.getResponsiveValue(
        context: context,
        mobile: 12.0,
        tablet: 16.0,
        desktop: 20.0,
      ),
    );
    
    final responsiveElevation = elevation ?? ResponsiveHelper.getResponsiveValue(
      context: context,
      mobile: 2.0,
      tablet: 4.0,
      desktop: 6.0,
    );
    
    return Semantics(
      button: onTap != null,
      child: Card(
        elevation: responsiveElevation,
        color: backgroundColor,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: responsivePadding,
            child: child,
          ),
        ),
      ),
    );
  }
}
```

### ✅ **Widget Configurável e Flexível**
```dart
class CustomTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? initialValue;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isRequired;
  
  const CustomTextField({
    Key? key,
    this.label,
    this.hint,
    this.initialValue,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.validator,
    this.onChanged,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.isRequired = false,
  }) : super(key: key);
  
  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController _controller;
  bool _hasError = false;
  
  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          RichText(
            text: TextSpan(
              text: widget.label!,
              style: context.textTheme.bodyMedium,
              children: widget.isRequired ? [
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: context.colorScheme.error),
                ),
              ] : null,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: _controller,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          enabled: widget.enabled,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          onChanged: (value) {
            widget.onChanged?.call(value);
            if (_hasError) {
              setState(() => _hasError = false);
            }
          },
          validator: (value) {
            final error = widget.validator?.call(value);
            if (error != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() => _hasError = true);
              });
            }
            return error;
          },
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: _hasError 
                  ? context.colorScheme.error 
                  : context.colorScheme.outline,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: context.colorScheme.outline,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: context.colorScheme.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: context.colorScheme.error,
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }
}
```

### ✅ **Widget com Estados de Loading e Erro**
```dart
class StatefulDataWidget<T> extends StatefulWidget {
  final Future<T> Function() dataLoader;
  final Widget Function(BuildContext context, T data) builder;
  final Widget? loadingWidget;
  final Widget Function(BuildContext context, String error)? errorBuilder;
  final Widget? emptyWidget;
  final bool Function(T data)? isEmpty;
  
  const StatefulDataWidget({
    Key? key,
    required this.dataLoader,
    required this.builder,
    this.loadingWidget,
    this.errorBuilder,
    this.emptyWidget,
    this.isEmpty,
  }) : super(key: key);
  
  @override
  _StatefulDataWidgetState<T> createState() => _StatefulDataWidgetState<T>();
}

class _StatefulDataWidgetState<T> extends State<StatefulDataWidget<T>> {
  late Future<T> _future;
  
  @override
  void initState() {
    super.initState();
    _future = widget.dataLoader();
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return widget.loadingWidget ?? const LoadingWidget();
        }
        
        if (snapshot.hasError) {
          return widget.errorBuilder?.call(context, snapshot.error.toString()) ??
              ErrorWidget(
                error: snapshot.error.toString(),
                onRetry: _refresh,
              );
        }
        
        if (snapshot.hasData) {
          final data = snapshot.data!;
          final isDataEmpty = widget.isEmpty?.call(data) ?? false;
          
          if (isDataEmpty) {
            return widget.emptyWidget ?? const EmptyStateWidget();
          }
          
          return widget.builder(context, data);
        }
        
        return const SizedBox.shrink();
      },
    );
  }
  
  void _refresh() {
    setState(() {
      _future = widget.dataLoader();
    });
  }
}
```

### ✅ **Widget Builder Pattern**
```dart
class WidgetBuilder {
  static Widget buildCard({
    required Widget child,
    EdgeInsets? margin,
    EdgeInsets? padding,
    double? elevation,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: margin ?? const EdgeInsets.all(8),
      child: Card(
        elevation: elevation ?? 2,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
  
  static Widget buildSectionHeader(String title, {Widget? action}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (action != null) action,
      ],
    );
  }
  
  static Widget buildListTile({
    required String title,
    String? subtitle,
    Widget? leading,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      leading: leading,
      trailing: trailing,
      onTap: onTap,
    );
  }
}
```

## 🔧 Implementação Ideal

### 1. **Widget Factory para Criação Dinâmica**
```dart
class WidgetFactory {
  static Widget createFormField({
    required String type,
    required String label,
    Map<String, dynamic>? config,
  }) {
    switch (type) {
      case 'text':
        return CustomTextField(
          label: label,
          hint: config?['hint'],
          validator: config?['validator'],
        );
      case 'date':
        return DatePickerField(
          label: label,
          initialDate: config?['initialDate'],
          firstDate: config?['firstDate'],
          lastDate: config?['lastDate'],
        );
      case 'dropdown':
        return DropdownField(
          label: label,
          items: config?['items'] ?? [],
          value: config?['value'],
        );
      default:
        return CustomTextField(label: label);
    }
  }
}
```

### 2. **Widget Theme Provider**
```dart
class WidgetTheme {
  static const double defaultRadius = 8.0;
  static const EdgeInsets defaultPadding = EdgeInsets.all(16.0);
  static const Duration defaultAnimation = Duration(milliseconds: 300);
  
  static BoxDecoration cardDecoration(BuildContext context) {
    return BoxDecoration(
      color: context.colorScheme.surface,
      borderRadius: BorderRadius.circular(defaultRadius),
      boxShadow: [
        BoxShadow(
          color: context.colorScheme.shadow.withOpacity(0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
  
  static InputDecoration inputDecoration({
    String? label,
    String? hint,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(defaultRadius),
      ),
    );
  }
}
```

### 3. **Widget Performance Optimizations**
```dart
class OptimizedListView extends StatelessWidget {
  final List<dynamic> items;
  final Widget Function(BuildContext, dynamic) itemBuilder;
  final ScrollController? controller;
  final bool shrinkWrap;
  
  const OptimizedListView({
    Key? key,
    required this.items,
    required this.itemBuilder,
    this.controller,
    this.shrinkWrap = false,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      shrinkWrap: shrinkWrap,
      itemCount: items.length,
      cacheExtent: 1000, // Cache extra items for smooth scrolling
      addAutomaticKeepAlives: false, // Don't keep widgets alive unnecessarily
      addRepaintBoundaries: false, // Reduce paint boundaries
      itemBuilder: (context, index) {
        final item = items[index];
        return RepaintBoundary(
          child: itemBuilder(context, item),
        );
      },
    );
  }
}
```

## 🧪 Testes Recomendados

```dart
group('CustomButton', () {
  testWidgets('should display text and handle tap', (tester) async {
    bool tapped = false;
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(
            text: 'Test Button',
            onPressed: () => tapped = true,
          ),
        ),
      ),
    );
    
    expect(find.text('Test Button'), findsOneWidget);
    
    await tester.tap(find.byType(CustomButton));
    expect(tapped, true);
  });
  
  testWidgets('should show loading indicator when loading', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(
            text: 'Loading Button',
            isLoading: true,
          ),
        ),
      ),
    );
    
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Loading Button'), findsNothing);
  });
});

group('CustomTextField', () {
  testWidgets('should validate input correctly', (tester) async {
    final formKey = GlobalKey<FormState>();
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            key: formKey,
            child: CustomTextField(
              label: 'Email',
              validator: (value) => value?.isEmpty == true ? 'Required' : null,
            ),
          ),
        ),
      ),
    );
    
    // Trigger validation
    formKey.currentState!.validate();
    await tester.pump();
    
    expect(find.text('Required'), findsOneWidget);
  });
});
```

## 📚 Dependências Recomendadas

```yaml
dependencies:
  flutter_hooks: ^0.20.3       # Hooks para estado local
  cached_network_image: ^3.3.0 # Cache de imagens
  shimmer: ^3.0.0              # Efeito shimmer
  lottie: ^2.7.0               # Animações Lottie
  flutter_svg: ^2.0.9         # Suporte a SVG

dev_dependencies:
  flutter_test: any
  golden_toolkit: ^0.15.0      # Testes de golden files
```

## 🎯 Objetivos da Implementação

1. **Reutilização**: Componentes que podem ser usados em múltiplas telas
2. **Consistência**: Visual e comportamento unificados
3. **Acessibilidade**: Suporte completo a screen readers e navegação
4. **Performance**: Otimizações para listas e renderização
5. **Manutenibilidade**: Código limpo e bem documentado
6. **Flexibilidade**: Configurável para diferentes necessidades

## 🔄 Hierarquia de Widgets

```
MaterialApp
├── Scaffold
│   ├── AppHeader (custom)
│   ├── Body
│   │   ├── ResponsiveLayout (custom)
│   │   ├── NavigationGrid (custom)
│   │   ├── CustomCard (custom)
│   │   └── CustomButton (custom)
│   └── FloatingActionButton
└── Dialogs/BottomSheets (custom)
```