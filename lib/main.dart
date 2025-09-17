// TODO: Adicionar roteamento completo do app
// TODO: Implementar autenticação na inicialização
// TODO: Adicionar splash screen
// TODO: Implementar tema escuro/claro
// TODO: Adicionar configurações de localização

import 'package:flutter/material.dart';
import 'screens/tela_inicial.dart';

// TODO: Adicionar roteamento completo do app
// TODO: Implementar autenticação na inicialização
// TODO: Adicionar splash screen
// TODO: Implementar tema escuro/claro
// TODO: Adicionar configurações de localização

void main() {
  // TODO: Adicionar inicialização do Firebase
  // TODO: Implementar configurações de crash reporting
  // TODO: Adicionar configurações de analytics
  // TODO: Configurar ambiente (dev/prod)
  runApp(const AppMotorista());
}

class AppMotorista extends StatelessWidget {
  const AppMotorista({super.key});

  // TODO: Implementar hot reload preservando estado
  // TODO: Adicionar configurações de ambiente (dev/prod)

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Motorista - Prefeitura', // TODO: Adicionar localização
      
      // TODO: Implementar tema personalizado da prefeitura
      // Tema otimizado para responsividade e acessibilidade
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32), // Verde institucional
        ),
        
        // Configurações de acessibilidade
        visualDensity: VisualDensity.adaptivePlatformDensity,
        
        // AppBar tema responsivo
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 1,
        ),
        
        // Botões otimizados para toque
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(44, 44), // Acessibilidade
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        
        // Cards responsivos
        cardTheme: const CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      
      // TODO: Implementar tema escuro
      // TODO: Adicionar roteamento nomeado
      // TODO: Implementar middleware de autenticação
      // TODO: Adicionar deep linking
      
      debugShowCheckedModeBanner: false,
      
      // TODO: Implementar splash screen e autenticação
      home: const TelaInicial(
        userName: 'Motorista', // TODO: Buscar do usuário autenticado
      ),
    );
  }
}
