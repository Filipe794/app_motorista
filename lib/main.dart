// TODO: Adicionar roteamento completo do app
// TODO: Implementar autenticação na inicialização
// TODO: Implementar tema escuro/claro
// TODO: Adicionar configurações de localização

import 'package:rota_mais/screens/chamados/chamados_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:device_preview/device_preview.dart';
import 'screens/tela_inicial.dart';
import 'screens/splash_screen.dart';

void main() {
  // TODO: Adicionar inicialização do Firebase
  // TODO: Implementar configurações de crash reporting
  // TODO: Adicionar configurações de analytics
  runApp(
    DevicePreview(
      enabled: !kReleaseMode, // Ativo apenas em debug/profile
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // TODO: Implementar hot reload preservando estado
  // TODO: Adicionar configurações de ambiente (dev/prod)

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Configurações do Device Preview
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      
      title: 'Rota+ - App Motorista', // TODO: Adicionar localização
      
      // TODO: Implementar tema personalizado da prefeitura
      // TODO: Adicionar suporte a tema escuro
      // Tema otimizado para responsividade e acessibilidade
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E3A8A)),
        
        // Configurações de acessibilidade
        visualDensity: VisualDensity.adaptivePlatformDensity,
        
        // AppBar theme responsivo
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 1,
        ),
        
        // Tema de botões otimizado para toque
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(44, 44), // Tamanho mínimo para acessibilidade
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        
        // Tema de cards responsivo
        cardTheme: const CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      
      // TODO: Implementar roteamento nomeado
      // TODO: Adicionar middleware de autenticação
      // TODO: Implementar deep linking
      // Remove banner de debug
      debugShowCheckedModeBanner: false, // TODO: Configurar baseado no ambiente
      
      // Splash Screen como tela inicial
      home: const TelaInicial(userName: "Filipe",)
    );
  }
}