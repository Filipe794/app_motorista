// TODO: Implementar listagem de despesas
// TODO: Adicionar filtros por categoria e período
// TODO: Implementar busca por descrição
// TODO: Adicionar ordenação por data/valor
// TODO: Implementar pull-to-refresh
// TODO: Adicionar FAB para nova despesa

import 'package:flutter/material.dart';
import '../../utils/responsive_helper.dart';
import '../../utils/app_colors.dart';

class DespesasListScreen extends StatefulWidget {
  const DespesasListScreen({super.key});

  @override
  State<DespesasListScreen> createState() => _DespesasListScreenState();
}

class _DespesasListScreenState extends State<DespesasListScreen> {
  // TODO: Adicionar lista de despesas
  // TODO: Implementar filtros
  // TODO: Adicionar gerenciamento de estado
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Despesas',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textOnDark,
          ),
        ),
        backgroundColor: AppColors.primaryDarkBlue,
        foregroundColor: AppColors.textOnDark,
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
                  Icons.receipt_long,
                  size: context.isTablet ? 80 : 64,
                  color: const Color(0xFF2196F3),
                ),
                SizedBox(height: context.verticalSpacing),
                Text(
                  'Lista de Despesas',
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