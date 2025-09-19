// TODO: Implementar listagem de escalas
// TODO: Adicionar filtros por data e status
// TODO: Implementar pull-to-refresh
// TODO: Adicionar paginação infinita
// TODO: Implementar busca por texto
// TODO: Adicionar ordenação

import 'package:flutter/material.dart';
import '../../utils/responsive_helper.dart';

class EscalasListScreen extends StatefulWidget {
  const EscalasListScreen({super.key});

  @override
  State<EscalasListScreen> createState() => _EscalasListScreenState();
}

class _EscalasListScreenState extends State<EscalasListScreen> {
  // TODO: Adicionar controller de busca
  // TODO: Implementar gerenciamento de estado
  // TODO: Adicionar lista de escalas
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Escalas',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(context.horizontalPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.schedule,
                  size: context.isTablet ? 80 : 64,
                  color: const Color(0xFF4CAF50),
                ),
                SizedBox(height: context.verticalSpacing),
                Text(
                  'Lista de Escalas',
                  style: TextStyle(
                    fontSize: context.fontSize(context.isTablet ? 24 : 20),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E3A8A),
                  ),
                ),
                SizedBox(height: context.verticalSpacing * 0.5),
                Text(
                  'Funcionalidade em desenvolvimento',
                  style: TextStyle(
                    fontSize: context.fontSize(16),
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: context.verticalSpacing * 2),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Voltar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3A8A),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: context.horizontalPadding,
                      vertical: 12,
                    ),
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