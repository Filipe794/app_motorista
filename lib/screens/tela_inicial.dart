import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';
import '../widgets/app_header.dart';
import '../widgets/navigation_grid.dart';
import '../widgets/next_shift_card.dart';
import '../widgets/notices_card.dart';

/// Tela inicial totalmente responsiva e acessível do aplicativo do motorista
/// 
/// Características:
/// - Layout adaptativo para mobile, tablet e desktop
/// - Suporte completo a acessibilidade (VoiceOver, TalkBack, textScaleFactor)
/// - Prevenção de overflow com ScrollView e layouts flexíveis
/// - Espaçamentos responsivos baseados em porcentagens da tela
/// - Otimização de performance com widgets otimizados
/// - Callbacks personalizáveis para navegação
class TelaInicial extends StatelessWidget {
  /// Nome do usuário a ser exibido na saudação
  final String userName;
  
  /// Callback para ação de logout personalizada
  final VoidCallback? onLogout;
  
  /// Callback para navegação customizada no grid
  final Function(String)? onNavigationTap;
  
  /// Callback para ação customizada na escala
  final VoidCallback? onShiftTap;
  
  /// Callback para ação customizada nos avisos
  final VoidCallback? onNoticeTap;
  
  const TelaInicial({
    super.key,
    required this.userName,
    this.onLogout,
    this.onNavigationTap,
    this.onShiftTap,
    this.onNoticeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return _ResponsiveMainContent(
              userName: userName,
              onLogout: onLogout,
              onNavigationTap: onNavigationTap,
              onShiftTap: onShiftTap,
              onNoticeTap: onNoticeTap,
              screenConstraints: constraints,
            );
          },
        ),
      ),
    );
  }
}

/// Widget interno que constrói o conteúdo principal responsivo
class _ResponsiveMainContent extends StatelessWidget {
  final String userName;
  final VoidCallback? onLogout;
  final Function(String)? onNavigationTap;
  final VoidCallback? onShiftTap;
  final VoidCallback? onNoticeTap;
  final BoxConstraints screenConstraints;
  
  const _ResponsiveMainContent({
    required this.userName,
    required this.onLogout,
    required this.onNavigationTap,
    required this.onShiftTap,
    required this.onNoticeTap,
    required this.screenConstraints,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Tela inicial do aplicativo do motorista',
      child: _buildResponsiveLayout(context),
    );
  }

  /// Constrói o layout responsivo baseado no tamanho da tela
  Widget _buildResponsiveLayout(BuildContext context) {
    // Decide qual layout usar baseado no tamanho da tela
    if (context.isDesktop && screenConstraints.maxWidth > 1200) {
      return _buildDesktopLayout(context);
    } else if (context.isTablet) {
      return _buildTabletLayout(context);
    } else {
      return _buildMobileLayout(context);
    }
  }

  /// Layout otimizado para desktop (telas grandes)
  Widget _buildDesktopLayout(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.horizontalPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Coluna principal (70% da largura)
          Expanded(
            flex: 7,
            child: _buildMainColumn(context),
          ),
          
          // Espaçamento entre colunas
          SizedBox(width: context.horizontalPadding),
          
          // Coluna lateral (30% da largura)
          Expanded(
            flex: 3,
            child: _buildSideColumn(context),
          ),
        ],
      ),
    );
  }

  /// Layout otimizado para tablet (telas médias)
  Widget _buildTabletLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: context.horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: context.verticalSpacing),
          
          // Header
          AppHeader(
            userName: userName,
            onLogout: onLogout,
          ),
          
          SizedBox(height: context.verticalSpacing * 2),
          
          // Grid de navegação em linha única
          NavigationGrid(onNavigationTap: onNavigationTap),
          
          SizedBox(height: context.verticalSpacing * 1.5),
          
          // Layout em duas colunas para tablet
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Próxima escala (60% da largura)
              Expanded(
                flex: 6,
                child: NextShiftCard(onShiftTap: onShiftTap),
              ),
              
              SizedBox(width: context.cardSpacing),
              
              // Avisos (40% da largura)
              Expanded(
                flex: 4,
                child: NoticesCard(onNoticeTap: onNoticeTap),
              ),
            ],
          ),
          
          SizedBox(height: context.verticalSpacing * 2),
        ],
      ),
    );
  }

  /// Layout otimizado para mobile (telas pequenas)
  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: context.horizontalPadding),
      physics: const BouncingScrollPhysics(), // Física de scroll mais natural
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: context.verticalSpacing),
          
          // Header responsivo
          AppHeader(
            userName: userName,
            onLogout: onLogout,
          ),
          
          SizedBox(height: context.verticalSpacing * 1.5),
          
          // Grid de navegação responsivo
          NavigationGrid(onNavigationTap: onNavigationTap),
          
          SizedBox(height: context.verticalSpacing * 1.2),
          
          // Card da próxima escala
          NextShiftCard(onShiftTap: onShiftTap),
          
          SizedBox(height: context.verticalSpacing),
          
          // Card de avisos
          NoticesCard(onNoticeTap: onNoticeTap),
          
          // Espaçamento final para scroll confortável
          SizedBox(height: context.verticalSpacing * 2),
        ],
      ),
    );
  }

  /// Coluna principal para layout desktop
  Widget _buildMainColumn(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: context.verticalSpacing),
          
          // Header
          AppHeader(
            userName: userName,
            onLogout: onLogout,
          ),
          
          SizedBox(height: context.verticalSpacing * 2),
          
          // Grid de navegação
          NavigationGrid(onNavigationTap: onNavigationTap),
          
          SizedBox(height: context.verticalSpacing * 1.5),
          
          // Card da próxima escala
          NextShiftCard(onShiftTap: onShiftTap),
          
          SizedBox(height: context.verticalSpacing * 2),
        ],
      ),
    );
  }

  /// Coluna lateral para layout desktop
  Widget _buildSideColumn(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Espaçamento para alinhar com o conteúdo principal
          SizedBox(height: context.verticalSpacing * 8),
          
          // Card de avisos
          NoticesCard(onNoticeTap: onNoticeTap),
          
          SizedBox(height: context.verticalSpacing),
          
          // Espaço para widgets adicionais futuros
          _FutureContentPlaceholder(),
        ],
      ),
    );
  }
}

/// Placeholder para conteúdo futuro na coluna lateral
class _FutureContentPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: context.responsiveHeight(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: context.responsiveBorderRadius,
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1.0,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline,
              size: context.isMobile ? 32.0 : 40.0,
              color: Colors.grey[400],
            ),
            
            SizedBox(height: context.verticalSpacing * 0.5),
            
            Text(
              'Conteúdo adicional',
              style: TextStyle(
                fontSize: context.fontSize(14),
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            
            SizedBox(height: context.verticalSpacing * 0.3),
            
            Text(
              'Em breve',
              style: TextStyle(
                fontSize: context.fontSize(12),
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Métodos de conveniência para criar diferentes instâncias da TelaInicial
class TelaInicialFactory {
  /// Factory para criar tela inicial básica
  static TelaInicial basic(String userName) {
    return TelaInicial(userName: userName);
  }
  
  /// Factory para criar tela inicial com callbacks completos
  static TelaInicial withCallbacks({
    required String userName,
    VoidCallback? onLogout,
    Function(String)? onNavigationTap,
    VoidCallback? onShiftTap,
    VoidCallback? onNoticeTap,
  }) {
    return TelaInicial(
      userName: userName,
      onLogout: onLogout,
      onNavigationTap: onNavigationTap,
      onShiftTap: onShiftTap,
      onNoticeTap: onNoticeTap,
    );
  }
}

/// Classe para gerenciar o estado da tela inicial (pode ser usada futuramente)
class TelaInicialController {
  /// Notifica quando dados devem ser atualizados
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  
  /// Dados do usuário
  String? _userName;
  String? get userName => _userName;
  
  /// Atualiza nome do usuário
  void updateUserName(String name) {
    _userName = name;
  }
  
  /// Simula carregamento de dados
  Future<void> refreshData() async {
    isLoading.value = true;
    
    // Simula delay de rede
    await Future.delayed(const Duration(seconds: 1));
    
    isLoading.value = false;
  }
  
  /// Limpa recursos
  void dispose() {
    isLoading.dispose();
  }
}