import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/responsive_helper.dart';
import '../screens/escalas/escala_details_screen.dart';
import '../services/flutter_map_provider.dart';
import '../services/student_app_data_service.dart';
import 'flutter_map_widget.dart';

/// Widget de card da próxima escala totalmente responsivo e acessível
/// 
/// Características:
/// - Layout flexível que se adapta a diferentes tamanhos de tela
/// - Mapa visual responsivo com pontos e rotas
/// - Modal de detalhes responsivo
/// - Suporte completo a acessibilidade
/// - Prevenção de overflow com layouts flexíveis
class NextShiftCard extends StatelessWidget {
  /// Callback opcional para ação customizada ao clicar no botão
  final VoidCallback? onShiftTap;
  
  const NextShiftCard({
    super.key,
    this.onShiftTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return _ResponsiveShiftCardContent(
          onShiftTap: onShiftTap,
          availableWidth: constraints.maxWidth,
        );
      },
    );
  }
}

/// Widget interno que constrói o conteúdo responsivo do card
class _ResponsiveShiftCardContent extends StatelessWidget {
  final VoidCallback? onShiftTap;
  final double availableWidth;
  
  const _ResponsiveShiftCardContent({
    required this.onShiftTap,
    required this.availableWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Card da próxima escala de trabalho',
      child: _MainShiftCard(
        onShiftTap: onShiftTap,
        availableWidth: availableWidth,
      ),
    );
  }
}

/// Card principal com todas as informações da escala
class _MainShiftCard extends StatelessWidget {
  final VoidCallback? onShiftTap;
  final double availableWidth;
  
  const _MainShiftCard({
    required this.onShiftTap,
    required this.availableWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Informações da próxima escala Centro - Antenor Viana',
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0x78EFEFEF),
          borderRadius: context.responsiveBorderRadius,
          border: Border.all(
            color: const Color(0xFFDFDFDF),
            width: 1.0,
          ),
          // Sombra sutil para dar profundidade
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8.0,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Mapa visual responsivo
            _ResponsiveMapSection(availableWidth: availableWidth),
            
            // Informações e botão de ação
            _ShiftInfoSection(onShiftTap: onShiftTap),
          ],
        ),
      ),
    );
  }
}

/// Seção do mapa visual responsivo
class _ResponsiveMapSection extends StatelessWidget {
  final double availableWidth;
  
  const _ResponsiveMapSection({required this.availableWidth});

  @override
  Widget build(BuildContext context) {
    // Altura responsiva do mapa baseada na largura e tipo de dispositivo
    final mapHeight = _calculateMapHeight(context);
    
    return Semantics(
      label: 'Mapa interativo da rota da escala',
      child: ChangeNotifierProvider(
        create: (context) => FlutterMapProvider()..setCurrentRoute(StudentAppDataService.getCurrentRoute()),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: context.responsiveBorderRadius.topLeft,
            topRight: context.responsiveBorderRadius.topRight,
          ),
          child: FlutterMapWidget(
            height: mapHeight,
            showControls: false, // Não mostrar controles no card
            enableTracking: false, // Não habilitar rastreamento no card
            onMapReady: () {
              // Mapa pronto para uso
              print('Mapa carregado no NextShiftCard');
            },
          ),
        ),
      ),
    );
  }

  /// Calcula altura responsiva do mapa
  double _calculateMapHeight(BuildContext context) {
    if (context.isMobile) {
      return context.responsiveHeight(18); // 18% da altura da tela
    } else if (context.isTablet) {
      return context.responsiveHeight(20); // 20% da altura da tela
    } else {
      return context.responsiveHeight(22); // 22% da altura da tela
    }
  }
}

/// Seção com informações da escala e botão de ação
class _ShiftInfoSection extends StatelessWidget {
  final VoidCallback? onShiftTap;
  
  const _ShiftInfoSection({required this.onShiftTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.horizontalPadding * 0.8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Título da rota
          _RouteTitle(),
          
          SizedBox(height: context.verticalSpacing),
          
          // Informações das paradas
          _StopsInfo(),
          
          SizedBox(height: context.verticalSpacing),
          
          // Botão de ação responsivo
          _ActionButton(onShiftTap: onShiftTap),
        ],
      ),
    );
  }
}

/// Título da rota responsivo
class _RouteTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final baseFontSize = context.isMobile ? 16.0 : 
                        context.isTablet ? 18.0 : 20.0;
    
    return Semantics(
      label: 'Rota da escala: Centro até Antenor Viana',
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Text(
          'Centro - Antenor Viana',
          style: TextStyle(
            fontSize: context.fontSize(baseFontSize),
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            height: 1.2,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

/// Informações sobre as paradas
class _StopsInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final iconSize = context.isMobile ? 18.0 : 
                     context.isTablet ? 20.0 : 22.0;
    final baseFontSize = context.isMobile ? 14.0 : 
                        context.isTablet ? 16.0 : 18.0;
    
    return Semantics(
      label: 'Informação: 4 paradas na rota',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.bus_alert,
            size: iconSize,
            color: const Color(0xFF7D7D7D),
            semanticLabel: 'Ícone de paradas de ônibus',
          ),
          
          SizedBox(width: context.cardSpacing),
          
          Flexible(
            child: Text(
              '4 paradas',
              style: TextStyle(
                fontSize: context.fontSize(baseFontSize),
                fontWeight: FontWeight.normal,
                color: const Color(0xFF7D7D7D),
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Botão de ação responsivo e acessível
class _ActionButton extends StatelessWidget {
  final VoidCallback? onShiftTap;
  
  const _ActionButton({required this.onShiftTap});

  @override
  Widget build(BuildContext context) {
    final buttonHeight = context.isMobile ? 48.0 : 
                        context.isTablet ? 52.0 : 56.0;
    final baseFontSize = context.isMobile ? 14.0 : 
                        context.isTablet ? 16.0 : 18.0;
    
    return SizedBox(
      width: double.infinity,
      height: buttonHeight,
      child: Semantics(
        label: 'Botão ver detalhes da escala que inicia em 35 minutos',
        hint: 'Toque duplo para ver mais informações',
        button: true,
        child: ElevatedButton(
          onPressed: () => _handleButtonPress(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFBCBCBC),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 2,
            shadowColor: Colors.black26,
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: context.fontSize(baseFontSize),
                  color: Colors.white,
                  height: 1.2,
                ),
                children: const [
                  TextSpan(
                    text: 'Inicia em ',
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                  TextSpan(
                    text: '35 min',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Gerencia a ação do botão
  void _handleButtonPress(BuildContext context) {
    if (onShiftTap != null) {
      onShiftTap!();
    } else {
      _navigateToShiftDetails(context);
    }
  }

  /// Navega para a tela de detalhes da escala
  void _navigateToShiftDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EscalaDetailsScreen(
          escalaId: '1', // ID da escala padrão para o card da próxima escala
        ),
      ),
    );
  }
}