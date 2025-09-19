import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Título da seção
          _SectionTitle(context: context),
          
          SizedBox(height: context.verticalSpacing),
          
          // Card principal com mapa e informações
          _MainShiftCard(
            onShiftTap: onShiftTap,
            availableWidth: availableWidth,
          ),
        ],
      ),
    );
  }
}

/// Título da seção responsivo
class _SectionTitle extends StatelessWidget {
  final BuildContext context;
  
  const _SectionTitle({required this.context});

  @override
  Widget build(BuildContext context) {
    final baseFontSize = context.isMobile ? 14.0 : 
                        context.isTablet ? 16.0 : 18.0;
    
    return Semantics(
      label: 'Seção próxima escala',
      child: Text(
        'Próxima escala',
        style: TextStyle(
          fontSize: context.fontSize(baseFontSize),
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          height: 1.2,
        ),
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
      label: 'Mapa visual da rota da escala',
      child: Container(
        height: mapHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: context.responsiveBorderRadius.topLeft,
            topRight: context.responsiveBorderRadius.topRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: context.responsiveBorderRadius.topLeft,
            topRight: context.responsiveBorderRadius.topRight,
          ),
          child: Image.asset(
            'assets/images/mapa.png',
            width: double.infinity,
            height: mapHeight,
            fit: BoxFit.cover,
            semanticLabel: 'Mapa da rota Centro - Antenor Viana',
            errorBuilder: (context, error, stackTrace) {
              // Fallback em caso de erro ao carregar a imagem
              return Container(
                height: mapHeight,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF81C784),
                      Color(0xFF4CAF50),
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.map_outlined,
                        size: context.isMobile ? 40 : 48,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                      SizedBox(height: context.verticalSpacing * 0.5),
                      Text(
                        'Mapa da Rota',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: context.fontSize(16),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Centro - Antenor Viana',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: context.fontSize(12),
                        ),
                      ),
                    ],
                  ),
                ),
              );
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
      _showShiftDetails(context);
    }
  }

  /// Exibe modal com detalhes da escala
  void _showShiftDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      builder: (context) => _ResponsiveShiftDetailsModal(),
    );
  }
}

/// Modal responsivo com detalhes da escala
class _ResponsiveShiftDetailsModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final modalHeight = context.isMobile 
        ? context.responsiveHeight(70)
        : context.isTablet 
            ? context.responsiveHeight(60)
            : context.responsiveHeight(50);
    
    return Container(
      height: modalHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Semantics(
        label: 'Modal com detalhes completos da escala',
        child: Padding(
          padding: EdgeInsets.all(context.horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Indicador visual do modal
              _ModalHandle(),
              
              SizedBox(height: context.verticalSpacing),
              
              // Título do modal
              _ModalTitle(),
              
              SizedBox(height: context.verticalSpacing * 1.5),
              
              // Lista de detalhes
              Expanded(
                child: _DetailsList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Handle visual do modal
class _ModalHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

/// Título do modal
class _ModalTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final baseFontSize = context.isMobile ? 20.0 : 
                        context.isTablet ? 22.0 : 24.0;
    
    return Text(
      'Detalhes da Escala',
      style: TextStyle(
        fontSize: context.fontSize(baseFontSize),
        fontWeight: FontWeight.bold,
        color: Colors.black87,
        height: 1.2,
      ),
    );
  }
}

/// Lista de detalhes da escala
class _DetailsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final details = [
      ('Rota:', 'Centro - Antenor Viana'),
      ('Paradas:', '4 paradas'),
      ('Horário:', '14:30 - 18:30'),
      ('Veículo:', 'Ônibus 1234'),
      ('Status:', 'Agendado'),
    ];
    
    return SingleChildScrollView(
      child: Column(
        children: details.map((detail) {
          return _DetailRow(
            label: detail.$1,
            value: detail.$2,
          );
        }).toList(),
      ),
    );
  }
}

/// Linha individual de detalhe
class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  
  const _DetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final baseFontSize = context.isMobile ? 14.0 : 
                        context.isTablet ? 15.0 : 16.0;
    
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.verticalSpacing * 0.5),
      child: Semantics(
        label: '$label $value',
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label com largura flexível
            Flexible(
              flex: 2,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: context.fontSize(baseFontSize),
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
            ),
            
            SizedBox(width: context.cardSpacing),
            
            // Valor com largura flexível
            Expanded(
              flex: 3,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: context.fontSize(baseFontSize),
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}