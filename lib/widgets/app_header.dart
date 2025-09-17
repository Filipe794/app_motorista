// TODO: Adicionar foto de perfil do usuário
// TODO: Implementar notificações em tempo real
// TODO: Adicionar indicador de status online/offline
// TODO: Implementar configurações rápidas
// TODO: Adicionar badge de notificações não lidas

import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';

/// Widget de cabeçalho do aplicativo totalmente responsivo e acessível
/// 
/// Características:
/// - Adapta-se automaticamente a diferentes tamanhos de tela
/// - Suporte completo a acessibilidade (screen readers, textScaleFactor)
/// - Layout flexível que previne overflow
/// - Espaçamentos responsivos baseados em porcentagens
class AppHeader extends StatelessWidget {
  /// Nome do usuário a ser exibido na saudação
  final String userName;
  
  /// Callback opcional para ação de logout personalizada
  final VoidCallback? onLogout;
  
  // TODO: Adicionar propriedade para foto de perfil
  // TODO: Adicionar propriedade para status online/offline
  // TODO: Adicionar propriedade para contador de notificações
  
  const AppHeader({
    super.key, 
    required this.userName,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return _ResponsiveHeaderContent(
          userName: userName,
          onLogout: onLogout,
          availableWidth: constraints.maxWidth,
        );
      },
    );
  }
}

/// Widget interno que constrói o conteúdo responsivo do header
class _ResponsiveHeaderContent extends StatelessWidget {
  final String userName;
  final VoidCallback? onLogout;
  final double availableWidth;
  
  const _ResponsiveHeaderContent({
    required this.userName,
    required this.onLogout,
    required this.availableWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Cabeçalho do aplicativo com saudação do usuário e opção de logout',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Saudação do usuário - responsiva e acessível
          Expanded(
            flex: 3,
            child: _GreetingWidget(
              userName: userName,
              availableWidth: availableWidth,
            ),
          ),
          
          // Espaçamento flexível entre os elementos
          SizedBox(width: context.cardSpacing),
          
          // Botão de logout - responsivo e acessível
          Flexible(
            flex: 1,
            child: _LogoutButton(
              userName: userName,
              onLogout: onLogout,
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget para exibir a saudação do usuário de forma responsiva
class _GreetingWidget extends StatelessWidget {
  final String userName;
  final double availableWidth;
  
  const _GreetingWidget({
    required this.userName,
    required this.availableWidth,
  });

  @override
  Widget build(BuildContext context) {
    // Calcula o tamanho da fonte baseado na largura disponível e acessibilidade
    final baseFontSize = context.isMobile ? 18.0 : 
                       context.isTablet ? 22.0 : 26.0;
    
    return Semantics(
      label: 'Saudação: Olá, $userName',
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Text(
          'Olá, $userName',
          style: TextStyle(
            fontSize: context.fontSize(baseFontSize),
            fontWeight: FontWeight.bold,
            color: Colors.black,
            // Altura da linha responsiva para melhor legibilidade
            height: 1.2,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

/// Widget para o botão de logout responsivo e acessível
class _LogoutButton extends StatelessWidget {
  final String userName;
  final VoidCallback? onLogout;
  
  const _LogoutButton({
    required this.userName,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    // Tamanho mínimo do botão para acessibilidade (44x44 pontos mínimo)
    final minButtonSize = context.isMobile ? 44.0 : 48.0;
    final baseFontSize = context.isMobile ? 12.0 : 
                        context.isTablet ? 14.0 : 16.0;
    
    return Semantics(
      label: 'Botão sair do aplicativo',
      hint: 'Toque duplo para fazer logout',
      button: true,
      child: SizedBox(
        height: minButtonSize,
        child: TextButton(
          onPressed: () => _handleLogout(context),
          style: TextButton.styleFrom(
            // Padding responsivo baseado no tamanho da tela
            padding: EdgeInsets.symmetric(
              horizontal: context.isMobile ? 12.0 : 16.0,
              vertical: 8.0,
            ),
            minimumSize: Size(minButtonSize, minButtonSize),
            tapTargetSize: MaterialTapTargetSize.padded,
            // Border radius responsivo
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Sair',
              style: TextStyle(
                fontSize: context.fontSize(baseFontSize),
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFE5959),
                height: 1.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Gerencia a ação de logout com dialog responsivo
  void _handleLogout(BuildContext context) {
    if (onLogout != null) {
      onLogout!();
    } else {
      _showResponsiveLogoutDialog(context);
    }
  }

  /// Exibe dialog de confirmação de logout totalmente responsivo
  void _showResponsiveLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return _ResponsiveLogoutDialog(userName: userName);
      },
    );
  }
}

/// Dialog de logout responsivo e acessível
class _ResponsiveLogoutDialog extends StatelessWidget {
  final String userName;
  
  const _ResponsiveLogoutDialog({required this.userName});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calcula largura do dialog baseada no tamanho da tela
        final dialogWidth = context.isMobile 
            ? context.responsiveWidth(90) // 90% da largura em mobile
            : context.isTablet 
                ? context.responsiveWidth(60) // 60% em tablet
                : context.responsiveWidth(40); // 40% em desktop
        
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: dialogWidth,
              maxHeight: context.responsiveHeight(80),
            ),
            child: Semantics(
              label: 'Dialog de confirmação de logout',
              child: AlertDialog(
                // Padding responsivo
                contentPadding: EdgeInsets.all(context.horizontalPadding),
                
                title: Text(
                  'Confirmar saída',
                  style: TextStyle(
                    fontSize: context.fontSize(18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                content: SingleChildScrollView(
                  child: Text(
                    '$userName, deseja realmente sair do aplicativo?',
                    style: TextStyle(
                      fontSize: context.fontSize(16),
                      height: 1.4,
                    ),
                  ),
                ),
                
                actions: [
                  _DialogActionButton(
                    text: 'Cancelar',
                    isPrimary: false,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  
                  SizedBox(width: context.cardSpacing),
                  
                  _DialogActionButton(
                    text: 'Sair',
                    isPrimary: true,
                    onPressed: () => _confirmLogout(context),
                  ),
                ],
                
                // Layout responsivo dos botões
                actionsAlignment: context.isMobile 
                    ? MainAxisAlignment.spaceEvenly 
                    : MainAxisAlignment.end,
                
                shape: RoundedRectangleBorder(
                  borderRadius: context.responsiveBorderRadius,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Confirma o logout e fecha o dialog
  void _confirmLogout(BuildContext context) {
    Navigator.of(context).pop();
    
    // Feedback visual acessível
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Semantics(
          label: 'Logout realizado com sucesso',
          child: Text(
            'Logout realizado',
            style: TextStyle(fontSize: context.fontSize(14)),
          ),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

/// Botão responsivo para actions do dialog
class _DialogActionButton extends StatelessWidget {
  final String text;
  final bool isPrimary;
  final VoidCallback onPressed;
  
  const _DialogActionButton({
    required this.text,
    required this.isPrimary,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$text botão do dialog',
      button: true,
      child: SizedBox(
        height: 44.0, // Altura mínima para acessibilidade
        child: isPrimary
            ? ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.horizontalPadding * 0.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    text,
                    style: TextStyle(fontSize: context.fontSize(14)),
                  ),
                ),
              )
            : TextButton(
                onPressed: onPressed,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.horizontalPadding * 0.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    text,
                    style: TextStyle(fontSize: context.fontSize(14)),
                  ),
                ),
              ),
      ),
    );
  }
}