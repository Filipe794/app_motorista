import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';

/// Widget de card de avisos totalmente responsivo e acessível
/// 
/// Características:
/// - Layout flexível que se adapta a diferentes tamanhos de tela
/// - Suporte completo a acessibilidade (VoiceOver, TalkBack)
/// - Prevenção de overflow com textos responsivos
/// - Espaçamentos responsivos baseados em porcentagens
/// - Design visual atrativo com cores de destaque
class NoticesCard extends StatelessWidget {
  /// Tipo de aviso (pode ser usado para categorização)
  final String noticeType;
  
  /// Conteúdo do aviso
  final String noticeContent;
  
  /// Callback opcional para ação ao tocar no card
  final VoidCallback? onNoticeTap;
  
  const NoticesCard({
    super.key,
    this.noticeType = 'Geral',
    this.noticeContent = 'Todos os motoristas podem ler avisos neste campo, os avisos podem ser categorizados',
    this.onNoticeTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return _ResponsiveNoticesContent(
          noticeType: noticeType,
          noticeContent: noticeContent,
          onNoticeTap: onNoticeTap,
          availableWidth: constraints.maxWidth,
        );
      },
    );
  }
}

/// Widget interno que constrói o conteúdo responsivo do card de avisos
class _ResponsiveNoticesContent extends StatelessWidget {
  final String noticeType;
  final String noticeContent;
  final VoidCallback? onNoticeTap;
  final double availableWidth;
  
  const _ResponsiveNoticesContent({
    required this.noticeType,
    required this.noticeContent,
    required this.onNoticeTap,
    required this.availableWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Seção de avisos da empresa',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Título da seção
          _SectionTitle(),
          
          SizedBox(height: context.verticalSpacing),
          
          // Card principal com o aviso
          _MainNoticeCard(
            noticeType: noticeType,
            noticeContent: noticeContent,
            onNoticeTap: onNoticeTap,
          ),
        ],
      ),
    );
  }
}

/// Título da seção de avisos
class _SectionTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final baseFontSize = context.isMobile ? 14.0 : 
                        context.isTablet ? 16.0 : 18.0;
    
    return Semantics(
      label: 'Seção avisos',
      child: Text(
        'Avisos',
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

/// Card principal com o conteúdo do aviso
class _MainNoticeCard extends StatefulWidget {
  final String noticeType;
  final String noticeContent;
  final VoidCallback? onNoticeTap;
  
  const _MainNoticeCard({
    required this.noticeType,
    required this.noticeContent,
    this.onNoticeTap,
  });

  @override
  State<_MainNoticeCard> createState() => _MainNoticeCardState();
}

class _MainNoticeCardState extends State<_MainNoticeCard>
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
      end: 0.98,
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
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: _buildCardContent(context),
        );
      },
    );
  }

  Widget _buildCardContent(BuildContext context) {
    // Calcula se o card deve ser interativo
    final isInteractive = widget.onNoticeTap != null;
    
    return Semantics(
      label: 'Aviso ${widget.noticeType}: ${widget.noticeContent}',
      button: isInteractive,
      hint: isInteractive ? 'Toque duplo para ver mais detalhes' : null,
      child: GestureDetector(
        onTapDown: isInteractive ? (_) => _handleTapDown() : null,
        onTapUp: isInteractive ? (_) => _handleTapUp() : null,
        onTapCancel: isInteractive ? () => _handleTapCancel() : null,
        onTap: isInteractive ? () => _handleTap() : null,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            // Cor de fundo responsiva com transparência
            color: _isPressed 
                ? const Color(0x25F0AD00)
                : const Color(0x1AF0AD00),
            borderRadius: context.responsiveBorderRadius,
            border: Border.all(
              color: const Color(0xFFE4B029),
              width: 1.0,
            ),
            // Sombra sutil para dar profundidade
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE4B029).withAlpha(26), // 0.1 * 255 = ~26
                blurRadius: 6.0,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(context.horizontalPadding * 0.8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Badge do tipo de aviso
                _NoticeTypeBadge(type: widget.noticeType),
                
                SizedBox(height: context.verticalSpacing * 0.8),
                
                // Conteúdo do aviso
                _NoticeContent(content: widget.noticeContent),
              ],
            ),
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
  void _handleTap() {
    if (widget.onNoticeTap != null) {
      widget.onNoticeTap!();
    }
  }
}

/// Badge responsivo para o tipo de aviso
class _NoticeTypeBadge extends StatelessWidget {
  final String type;
  
  const _NoticeTypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    final baseFontSize = context.isMobile ? 11.0 : 
                        context.isTablet ? 12.0 : 13.0;
    
    return Semantics(
      label: 'Tipo de aviso: $type',
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.horizontalPadding * 0.6,
          vertical: context.verticalSpacing * 0.3,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFE4B029).withAlpha(51), // 0.2 * 255 = 51
          borderRadius: BorderRadius.circular(
            context.isMobile ? 8.0 : 
            context.isTablet ? 10.0 : 12.0,
          ),
          border: Border.all(
            color: const Color(0xFFE4B029).withAlpha(77), // 0.3 * 255 = ~77
            width: 0.5,
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            type,
            style: TextStyle(
              fontSize: context.fontSize(baseFontSize),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2C2D33),
              height: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}

/// Conteúdo responsivo do aviso
class _NoticeContent extends StatelessWidget {
  final String content;
  
  const _NoticeContent({required this.content});

  @override
  Widget build(BuildContext context) {
    final baseFontSize = context.isMobile ? 13.0 : 
                        context.isTablet ? 14.0 : 15.0;
    
    return Semantics(
      label: 'Conteúdo do aviso: $content',
      child: LayoutBuilder(
        builder: (context, constraints) {
          return _buildResponsiveText(context, baseFontSize, constraints);
        },
      ),
    );
  }

  /// Constrói texto responsivo baseado no espaço disponível
  Widget _buildResponsiveText(BuildContext context, double baseFontSize, BoxConstraints constraints) {
    // Calcula número máximo de linhas baseado no tamanho da tela
    final maxLines = context.isMobile ? 4 : 
                     context.isTablet ? 3 : 2;
    
    return Text(
      content,
      style: TextStyle(
        fontSize: context.fontSize(baseFontSize),
        fontWeight: FontWeight.normal,
        color: const Color(0xFF2C2D33),
        height: 1.4, // Altura da linha para melhor legibilidade
      ),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.left,
    );
  }
}

/// Widget de exemplo para múltiplos avisos (pode ser usado futuramente)
class NoticesSection extends StatelessWidget {
  /// Lista de avisos a serem exibidos
  final List<NoticeData> notices;
  
  /// Callback para quando um aviso for tocado
  final Function(NoticeData)? onNoticeTap;
  
  const NoticesSection({
    super.key,
    required this.notices,
    this.onNoticeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Título da seção (reutiliza o widget existente)
        _SectionTitle(),
        
        SizedBox(height: context.verticalSpacing),
        
        // Lista de avisos
        ...notices.asMap().entries.map((entry) {
          final index = entry.key;
          final notice = entry.value;
          
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              NoticesCard(
                noticeType: notice.type,
                noticeContent: notice.content,
                onNoticeTap: onNoticeTap != null 
                    ? () => onNoticeTap!(notice)
                    : null,
              ),
              
              // Espaçamento entre cards (exceto no último)
              if (index < notices.length - 1)
                SizedBox(height: context.verticalSpacing * 0.8),
            ],
          );
        }).toList(),
      ],
    );
  }
}

/// Modelo de dados para avisos
class NoticeData {
  final String id;
  final String type;
  final String content;
  final DateTime createdAt;
  final bool isImportant;
  
  const NoticeData({
    required this.id,
    required this.type,
    required this.content,
    required this.createdAt,
    this.isImportant = false,
  });
  
  /// Factory para criar aviso padrão
  factory NoticeData.defaultNotice() {
    return NoticeData(
      id: 'default',
      type: 'Geral',
      content: 'Todos os motoristas podem ler avisos neste campo, os avisos podem ser categorizados',
      createdAt: DateTime.now(),
    );
  }
}