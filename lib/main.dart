import 'package:flutter/material.dart';
import 'screens/tela_inicial.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Motorista',
      
      // Tema otimizado para responsividade e acessibilidade
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4CAF50)),
        
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
      
      // Remove banner de debug
      debugShowCheckedModeBanner: false,
      
      // Tela inicial responsiva
      home: const TelaInicial(
        userName: 'Motorista', // Nome padrão, pode ser personalizado
      ),
    );
  }
}
