import 'package:flutter/material.dart';
import '../models/navigation_item.dart';
import '../utils/responsive_helper.dart';

/// Widget de grid de navegação totalmente responsivo e acessível
/// 
/// Características:
/// - Layout flexível que se adapta automaticamente ao tamanho da tela
/// - Suporte completo a acessibilidade (VoiceOver, TalkBack)
/// - Prevenção de overflow com Wrap e Flexible
/// - Espaçamentos responsivos baseados em porcentagens
/// - Cards interativos com feedback tátil e visual
class NavigationGrid extends StatelessWidget {
  /// Callback opcional para navegação personalizada
  final Function(String)? onNavigationTap;
  
  const NavigationGrid({
    super.key,
    this.onNavigationTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return _ResponsiveNavigationContent(
          onNavigationTap: onNavigationTap,
          availableWidth: constraints.maxWidth,
        );
      },
    );
  }
}

/// Widget interno que constrói o conteúdo responsivo do grid
class _ResponsiveNavigationContent extends StatelessWidget {
  final Function(String)? onNavigationTap;
  final double availableWidth;
  
  const _ResponsiveNavigationContent({
    required this.onNavigationTap,
    required this.availableWidth,
  });

  /// Lista de itens de navegação da aplicação
  List<NavigationItem> get _navigationItems => [
    NavigationItem(
      title: 'Escalas',
      icon: Icons.schedule,
      color: const Color(0xFF4CAF50),
    ),
    NavigationItem(
      title: 'Despesas',
      icon: Icons.receipt_long,
      color: const Color(0xFF2196F3),
    ),
    NavigationItem(
      title: 'Chamados',
      icon: Icons.support_agent,
      color: const Color(0xFFFF9800),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Determina o número de colunas baseado na largura disponível
    final columns = ResponsiveHelper.getGridColumns(context, maxColumns: 3);
    
    // Calcula se todos os itens cabem em uma linha
    final canFitInRow = _navigationItems.length <= columns;
    
    return Semantics(
      label: 'Grid de navegação principal com ${_navigationItems.length} opções',
      child: canFitInRow 
          ? _buildRowLayout(context)
          : _buildWrapLayout(context),
    );
  }

  /// Constrói layout em linha única quando há espaço suficiente
  Widget _buildRowLayout(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _navigationItems.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: index == 0 || index == _navigationItems.length - 1 
                  ? 0 
                  : context.cardSpacing / 2,
            ),
            child: _NavigationCard(
              item: item,
              onTap: onNavigationTap,
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Constrói layout com quebra quando necessário
  Widget _buildWrapLayout(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      spacing: context.cardSpacing,
      runSpacing: context.verticalSpacing,
      children: _navigationItems.map((item) {
        return SizedBox(
          width: (availableWidth - (context.cardSpacing * 2)) / 3,
          child: _NavigationCard(
            item: item,
            onTap: onNavigationTap,
          ),
        );
      }).toList(),
    );
  }
}

/// Card individual de navegação responsivo e acessível
class _NavigationCard extends StatefulWidget {
  final NavigationItem item;
  final Function(String)? onTap;
  
  const _NavigationCard({
    required this.item,
    this.onTap,
  });

  @override
  State<_NavigationCard> createState() => _NavigationCardState();
}

class _NavigationCardState extends State<_NavigationCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calcula dimensões responsivas do card
        final cardHeight = _calculateCardHeight(context, constraints.maxWidth);
        final iconSize = _calculateIconSize(context);
        
        return AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: _buildCardContent(context, cardHeight, iconSize),
            );
          },
        );
      },
    );
  }

  /// Calcula altura responsiva do card
  double _calculateCardHeight(BuildContext context, double width) {
    if (context.isMobile) {
      return width * 1.2; // Proporção 1:1.2 em mobile
    } else if (context.isTablet) {
      return width * 1.1; // Proporção 1:1.1 em tablet
    } else {
      return width * 1.0; // Proporção 1:1 em desktop
    }
  }

  /// Calcula tamanho responsivo do ícone
  double _calculateIconSize(BuildContext context) {
    if (context.isMobile) {
      return 28.0;
    } else if (context.isTablet) {
      return 32.0;
    } else {
      return 36.0;
    }
  }

  /// Constrói o conteúdo visual do card
  Widget _buildCardContent(BuildContext context, double cardHeight, double iconSize) {
    return Semantics(
      label: 'Botão ${widget.item.title}',
      hint: 'Toque duplo para navegar para ${widget.item.title}',
      button: true,
      child: GestureDetector(
        onTapDown: (_) => _handleTapDown(),
        onTapUp: (_) => _handleTapUp(),
        onTapCancel: () => _handleTapCancel(),
        onTap: () => _handleTap(context),
        child: Container(
          height: cardHeight,
          decoration: BoxDecoration(
            color: _isPressed 
                ? const Color(0xFFE0E0E0) 
                : const Color(0xFFEFEFEF),
            borderRadius: context.responsiveBorderRadius,
            border: Border.all(
              color: const Color(0xFFD9D9D9),
              width: 1.0,
            ),
            // Sombra sutil para dar profundidade
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(13), // 0.05 * 255 = ~13
                blurRadius: 4.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Container do ícone com fundo colorido
              Flexible(
                flex: 3,
                child: _IconContainer(
                  item: widget.item,
                  iconSize: iconSize,
                ),
              ),
              
              // Espaçamento responsivo
              SizedBox(height: context.verticalSpacing * 0.5),
              
              // Título do card
              Flexible(
                flex: 1,
                child: _CardTitle(
                  title: widget.item.title,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Gerencia animação quando pressionado
  void _handleTapDown() {
    setState(() => _isPressed = true);
    _animationController.forward();
  }

  /// Gerencia animação quando liberado
  void _handleTapUp() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  /// Gerencia cancelamento do toque
  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  /// Gerencia ação do toque
  void _handleTap(BuildContext context) {
    // Feedback háptico
    // HapticFeedback.lightImpact(); // Comentado pois pode não estar disponível em todas as versões

    if (widget.onTap != null) {
      widget.onTap!(widget.item.title);
    } else {
      _showDefaultFeedback(context);
    }
  }

  /// Exibe feedback padrão quando não há callback personalizado
  void _showDefaultFeedback(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Semantics(
          label: 'Navegando para ${widget.item.title}',
          child: Text(
            'Navegando para ${widget.item.title}',
            style: TextStyle(fontSize: context.fontSize(14)),
          ),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

/// Container responsivo para o ícone do card
class _IconContainer extends StatelessWidget {
  final NavigationItem item;
  final double iconSize;
  
  const _IconContainer({
    required this.item,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calcula tamanho do container baseado no espaço disponível
        final containerSize = constraints.maxWidth * 0.7;
        
        return Container(
          width: containerSize,
          height: containerSize,
          decoration: BoxDecoration(
            color: item.color.withAlpha(26), // 0.1 * 255 = ~26
            borderRadius: BorderRadius.circular(containerSize * 0.2),
            // Borda sutil na cor do item
            border: Border.all(
              color: item.color.withAlpha(51), // 0.2 * 255 = 51
              width: 1.0,
            ),
          ),
          child: Center(
            child: Icon(
              item.icon,
              size: iconSize,
              color: item.color,
              semanticLabel: 'Ícone ${item.title}',
            ),
          ),
        );
      },
    );
  }
}

/// Título responsivo do card
class _CardTitle extends StatelessWidget {
  final String title;
  
  const _CardTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final baseFontSize = context.isMobile ? 12.0 : 
                        context.isTablet ? 13.0 : 14.0;
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.cardSpacing),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          title,
          style: TextStyle(
            fontSize: context.fontSize(baseFontSize),
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}