// TODO: Implementar roteamento completo do app
// TODO: Adicionar middleware de autenticação
// TODO: Implementar navegação aninhada
// TODO: Adicionar transições personalizadas
// TODO: Implementar deep linking
// TODO: Adicionar guard de rotas

import 'package:flutter/material.dart';

// Importações das telas - TODO: Uncomment quando implementadas
// import '../screens/splash_screen.dart';
// import '../screens/login_screen.dart';
// import '../screens/forgot_password_screen.dart';
import '../screens/tela_inicial.dart';
// import '../screens/escalas/escalas_screen.dart';
// import '../screens/escalas/detalhes_escala_screen.dart';
// import '../screens/despesas/despesas_screen.dart';
// import '../screens/despesas/nova_despesa_screen.dart';
// import '../screens/chamados/chamados_screen.dart';
// import '../screens/chamados/novo_chamado_screen.dart';
// import '../screens/perfil/perfil_screen.dart';
// import '../screens/perfil/editar_perfil_screen.dart';

class AppRoutes {
  // TODO: Definir todas as rotas do app
  static const String splash = '/';
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String escalas = '/escalas';
  static const String detalhesEscala = '/escalas/detalhes';
  static const String despesas = '/despesas';
  static const String novaDespesa = '/despesas/nova';
  static const String chamados = '/chamados';
  static const String novoChamado = '/chamados/novo';
  static const String perfil = '/perfil';
  static const String editarPerfil = '/perfil/editar';

  // TODO: Implementar geração de rotas
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        // TODO: Retornar SplashScreen quando implementada
        return _createRoute(
          const TelaInicial(userName: 'Motorista'),
        );
      
      case login:
        // TODO: Retornar LoginScreen quando implementada
        return _createRoute(
          const Scaffold(
            body: Center(
              child: Text('TODO: Implementar LoginScreen'),
            ),
          ),
        );
      
      case home:
        return _createRoute(
          const TelaInicial(userName: 'Motorista'),
        );
      
      case escalas:
        // TODO: Retornar EscalasScreen quando implementada
        return _createRoute(
          Scaffold(
            appBar: AppBar(title: const Text('Escalas')),
            body: const Center(
              child: Text('TODO: Implementar EscalasScreen'),
            ),
          ),
        );
      
      case despesas:
        // TODO: Retornar DespesasScreen quando implementada
        return _createRoute(
          Scaffold(
            appBar: AppBar(title: const Text('Despesas')),
            body: const Center(
              child: Text('TODO: Implementar DespesasScreen'),
            ),
          ),
        );
      
      case chamados:
        // TODO: Retornar ChamadosScreen quando implementada
        return _createRoute(
          Scaffold(
            appBar: AppBar(title: const Text('Chamados')),
            body: const Center(
              child: Text('TODO: Implementar ChamadosScreen'),
            ),
          ),
        );
      
      case perfil:
        // TODO: Retornar PerfilScreen quando implementada
        return _createRoute(
          Scaffold(
            appBar: AppBar(title: const Text('Perfil')),
            body: const Center(
              child: Text('TODO: Implementar PerfilScreen'),
            ),
          ),
        );
      
      default:
        // TODO: Implementar página de erro 404
        return _createRoute(
          const Scaffold(
            body: Center(
              child: Text('Página não encontrada'),
            ),
          ),
        );
    }
  }

  // TODO: Implementar transições personalizadas
  static PageRoute _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // TODO: Adicionar diferentes tipos de transição baseado na plataforma
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  // TODO: Implementar middleware de autenticação
  static bool isAuthRequired(String route) {
    const publicRoutes = [splash, login, forgotPassword];
    return !publicRoutes.contains(route);
  }

  // TODO: Implementar navegação programática
  static void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      home,
      (route) => false,
    );
  }

  static void navigateToLogin(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      login,
      (route) => false,
    );
  }

  // TODO: Implementar passagem de parâmetros entre telas
  static void navigateToDetalhesEscala(BuildContext context, String escalaId) {
    Navigator.pushNamed(
      context,
      detalhesEscala,
      arguments: {'escalaId': escalaId},
    );
  }
}