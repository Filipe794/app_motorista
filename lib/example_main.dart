import 'package:flutter/material.dart';
import 'screens/tela_inicial.dart';

/// Exemplo de como usar a nova TelaInicial responsiva
/// 
/// Para integração com flutter_screenutil ou responsive_framework,
/// adicione as dependências no pubspec.yaml:
/// 
/// dependencies:
///   flutter_screenutil: ^5.9.0
///   responsive_framework: ^1.1.1
/// 
/// E configure no main.dart conforme mostrado abaixo.

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Motorista - Responsivo',
      
      // Configuração de tema responsivo
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        
        // Tipografia responsiva
        textTheme: const TextTheme().apply(
          fontSizeFactor: 1.0,
          fontSizeDelta: 0.0,
        ),
      ),
      
      // Para usar com responsive_framework (opcional):
      /*
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
      */
      
      home: const ExampleHomePage(),
      
      // Configurações de acessibilidade
      debugShowCheckedModeBanner: false,
    );
  }
}

/// Página exemplo mostrando diferentes formas de usar a TelaInicial
class ExampleHomePage extends StatefulWidget {
  const ExampleHomePage({super.key});

  @override
  State<ExampleHomePage> createState() => _ExampleHomePageState();
}

class _ExampleHomePageState extends State<ExampleHomePage> {
  String userName = 'João Silva';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Motorista - Exemplo Responsivo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Escolha uma versão da Tela Inicial:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            
            const SizedBox(height: 30),
            
            // Versão básica
            ElevatedButton(
              onPressed: () => _navigateToBasicScreen(),
              child: const Text('Tela Inicial Básica'),
            ),
            
            const SizedBox(height: 15),
            
            // Versão com callbacks
            ElevatedButton(
              onPressed: () => _navigateToAdvancedScreen(),
              child: const Text('Tela Inicial com Callbacks'),
            ),
            
            const SizedBox(height: 30),
            
            // Informações sobre responsividade
            const Card(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '✅ Características Implementadas:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text('• Layout responsivo (Mobile, Tablet, Desktop)'),
                    Text('• Acessibilidade completa (VoiceOver, TalkBack)'),
                    Text('• Prevenção de overflow'),
                    Text('• Espaçamentos baseados em porcentagens'),
                    Text('• Animações e feedback tátil'),
                    Text('• Suporte a textScaleFactor'),
                    Text('• Widgets modulares e reutilizáveis'),
                    Text('• Sistema de breakpoints padronizado'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Navega para versão básica da tela inicial
  void _navigateToBasicScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaInicialFactory.basic(userName),
      ),
    );
  }

  /// Navega para versão avançada com callbacks
  void _navigateToAdvancedScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaInicialFactory.withCallbacks(
          userName: userName,
          onLogout: () => _handleLogout(),
          onNavigationTap: (section) => _handleNavigation(section),
          onShiftTap: () => _handleShiftDetails(),
          onNoticeTap: () => _handleNoticeDetails(),
        ),
      ),
    );
  }

  /// Callback de logout personalizado
  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout Personalizado'),
        content: Text('$userName será desconectado do sistema.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Fecha dialog
              Navigator.pop(context); // Volta para tela anterior
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logout realizado com sucesso!')),
              );
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  /// Callback de navegação personalizado
  void _handleNavigation(String section) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navegação personalizada para: $section'),
        action: SnackBarAction(
          label: 'IR',
          onPressed: () {
            // Implementar navegação específica aqui
            print('Navegando para $section...');
          },
        ),
      ),
    );
  }

  /// Callback de detalhes da escala personalizado
  void _handleShiftDetails() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: const Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Detalhes Personalizados da Escala',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text('Esta é uma implementação personalizada do modal de detalhes.'),
              Text('Você pode customizar completamente o conteúdo aqui.'),
            ],
          ),
        ),
      ),
    );
  }

  /// Callback de detalhes dos avisos personalizado
  void _handleNoticeDetails() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Avisos Detalhados')),
          body: const Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lista Completa de Avisos',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.info, color: Colors.blue),
                    title: Text('Aviso Geral'),
                    subtitle: Text('Informações importantes para todos os motoristas.'),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.warning, color: Colors.orange),
                    title: Text('Manutenção'),
                    subtitle: Text('Período de manutenção programada do sistema.'),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.announcement, color: Colors.red),
                    title: Text('Urgente'),
                    subtitle: Text('Mudanças nas rotas devido ao trânsito.'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Exemplo de configuração para flutter_screenutil (opcional)
/// 
/// Adicione no main.dart dentro do MaterialApp:
/// 
/// ```dart
/// home: ScreenUtilInit(
///   designSize: const Size(375, 812), // Tamanho de design base
///   minTextAdapt: true,
///   splitScreenMode: true,
///   builder: (context, child) {
///     return const TelaInicial(userName: 'João Silva');
///   },
/// ),
/// ```
/// 
/// E use ScreenUtil nos widgets:
/// ```dart
/// Text(
///   'Hello',
///   style: TextStyle(fontSize: 16.sp), // Responsivo
/// ),
/// SizedBox(height: 20.h), // Altura responsiva
/// Container(width: 200.w), // Largura responsiva
/// ```

/// Configuração para responsive_framework (opcional)
/// 
/// ```dart
/// dependencies:
///   responsive_framework: ^1.1.1
/// 
/// // No MaterialApp:
/// builder: (context, child) => ResponsiveBreakpoints.builder(
///   child: child!,
///   breakpoints: [
///     const Breakpoint(start: 0, end: 450, name: MOBILE),
///     const Breakpoint(start: 451, end: 800, name: TABLET),
///     const Breakpoint(start: 801, end: 1920, name: DESKTOP),
///   ],
/// ),
/// 
/// // Uso nos widgets:
/// ResponsiveRowColumn(
///   layout: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
///       ? ResponsiveRowColumnType.COLUMN
///       : ResponsiveRowColumnType.ROW,
///   children: [...],
/// )
/// ```