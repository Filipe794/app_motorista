import 'package:flutter/material.dart';

/// Sistema de cores centralizado do aplicativo
/// 
/// Este arquivo contém todas as cores utilizadas no aplicativo,
/// permitindo fácil modificação e padronização da identidade visual.
class AppColors {
  AppColors._(); // Construtor privado para evitar instanciação

  // ==========================================
  // CORES PRIMÁRIAS DO APLICATIVO
  // ==========================================
  
  /// Cor principal do aplicativo (azul)
  static const Color primary = Color(0xFF2196F3);
  
  /// Cor azul escuro específica do login
  static const Color primaryDarkBlue = Color(0xFF1E3A8A);
  
  /// Variação mais escura da cor principal
  static const Color primaryDark = Color(0xFF1976D2);
  
  /// Variação mais clara da cor principal
  static const Color primaryLight = Color(0xFF42A5F5);
  
  /// Cor secundária (ciano/teal - complementar ao azul)
  static const Color secondary = Color(0xFF03DAC6);
  
  /// Variação mais escura da cor secundária
  static const Color secondaryDark = Color(0xFF00A896);
  
  /// Variação mais clara da cor secundária
  static const Color secondaryLight = Color(0xFF66FFF9);

  // ==========================================
  // CORES DE STATUS E FEEDBACK
  // ==========================================
  
  /// Cor de sucesso (azul-verde/teal)
  static const Color success = Color(0xFF00BCD4);
  
  /// Cor de aviso (laranja)
  static const Color warning = Color(0xFFFF9800);
  
  /// Cor de erro (vermelho)
  static const Color error = Color(0xFFE53935);
  
  /// Cor de informação (azul claro)
  static const Color info = Color(0xFF2196F3);

  // ==========================================
  // CORES ESPECÍFICAS PARA ESCALAS
  // ==========================================
  
  /// Cor para escalas em andamento (verde)
  static const Color escalaAndamento = Color(0xFF4CAF50);
  
  /// Cor para escalas agendadas (azul)
  static const Color escalaAgendada = Color(0xFF2196F3);
  
  /// Cor para escalas concluídas (azul escuro)
  static const Color escalaConcluida = Color(0xFF1565C0);
  
  /// Cor para escalas canceladas (cinza)
  static const Color escalaCancelada = Color(0xFF757575);
  
  /// Cor de emergência (vermelho intenso)
  static const Color emergency = Color(0xFFD32F2F);

  // ==========================================
  // CORES DE FUNDO
  // ==========================================
  
  /// Cor de fundo principal (branco)
  static const Color background = Color(0xFFFFFFFF);
  
  /// Cor de fundo secundária (cinza muito claro)
  static const Color backgroundSecondary = Color(0xFFF5F5F5);
  
  /// Cor de fundo ultra clara (quase branca)
  static const Color backgroundLight = Color(0xFFFAFAFA);
  
  /// Cor de fundo dos cards
  static const Color cardBackground = Color(0xFFFFFFFF);
  
  /// Cor de sobreposição modal
  static const Color overlay = Color(0x80000000);
  
  /// Cor de sombra padrão
  static const Color shadow = Color(0x42000000); // 26% opacity

  // ==========================================
  // CORES DE SUPERFICIE E DIVISORES
  // ==========================================
  
  /// Cor de superfície clara (cinza claro)
  static const Color surfaceLight = Color(0xFFE0E0E0);
  
  /// Cor de superfície média (cinza médio)  
  static const Color surfaceMedium = Color.fromARGB(150, 192, 192, 192);
  
  /// Cor de superfície escura (cinza escuro)
  static const Color surfaceDark = Color(0xFF757575);

  // ==========================================
  // CORES DE TEXTO
  // ==========================================
  
  /// Cor principal do texto (preto suave)
  static const Color textPrimary = Color(0xFF212121);
  
  /// Cor secundária do texto (cinza escuro)
  static const Color textSecondary = Color(0xFF757575);
  
  /// Cor do texto em fundos escuros (branco)
  static const Color textOnDark = Color(0xFFFFFFFF);
  
  /// Cor do texto em fundos escuros com opacidade (branco transparente)
  static const Color textOnDarkSecondary = Color(0xB3FFFFFF); // 70% opacity
  
  /// Cor do texto em fundos escuros com baixa opacidade (branco mais transparente)
  static const Color textOnDarkTertiary = Color(0x61FFFFFF); // 38% opacity
  
  /// Cor do texto em fundos escuros com opacidade muito baixa
  static const Color textOnDarkQuaternary = Color(0x8AFFFFFF); // 54% opacity
  
  /// Cor de fundo transparente sobre fundos escuros
  static const Color overlayOnDark = Color(0x1AFFFFFF); // 10% opacity
  
  /// Cor do texto desabilitado
  static const Color textDisabled = Color(0xFFBDBDBD);
  
  /// Cor do texto em links
  static const Color textLink = Color(0xFF2196F3);

  // ==========================================
  // CORES DE BORDAS E DIVISORES
  // ==========================================
  
  /// Cor principal das bordas
  static const Color border = Color(0xFFE0E0E0);
  
  /// Cor das bordas ativas/focadas
  static const Color borderActive = Color(0xFF2196F3);
  
  /// Cor dos divisores
  static const Color divider = Color(0xFFE0E0E0);

  // ==========================================
  // CORES PARA GRADIENTES
  // ==========================================
  
  /// Gradiente principal (azul)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  /// Gradiente secundário (ciano/teal)
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryDark],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  
  /// Gradiente da tela de login
  static const LinearGradient loginGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Gradiente para escalas em andamento (verde)
  static const LinearGradient escalaAndamentoGradient = LinearGradient(
    colors: [escalaAndamento, Color(0xFF45A049)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // ==========================================
  // CORES ESPECÍFICAS POR FUNCIONALIDADE
  // ==========================================
  
  /// Cores para os botões de navegação
  static const Color navigationButton = primary;
  static const Color navigationButtonPressed = primaryDark;
  
  /// Cores para status de escalas
  static const Color escalaAtiva = success;
  static const Color escalaInativa = Color(0xFF9E9E9E);
  static const Color escalaPausada = warning;
  static const Color escalaFinalizada = textSecondary;
  
  /// Cores para status de paradas
  static const Color paradaConcluida = success;
  static const Color paradaAtual = primary;
  static const Color paradaPendente = Color(0xFF9E9E9E);
  
  /// Cores para prioridades de chamados
  static const Color prioridadeBaixa = success;
  static const Color prioridadeMedia = warning;
  static const Color prioridadeAlta = error;
  
  /// Cores para tipos de despesas
  static const Color despesaCombustivel = Color(0xFFFF5722);
  static const Color despesaManutencao = Color(0xFF9C27B0);
  static const Color despesaOutros = Color(0xFF607D8B);

  // ==========================================
  // CORES DE SOMBRAS
  // ==========================================
  
  /// Sombra padrão dos cards
  static const Color cardShadow = Color(0x1F000000);
  
  /// Sombra dos botões
  static const Color buttonShadow = Color(0x26000000);

  // ==========================================
  // MÉTODOS AUXILIARES PARA CORES
  // ==========================================
  
  /// Retorna uma cor com opacidade específica
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }
  
  /// Retorna a cor primária com opacidade
  static Color primaryWithOpacity(double opacity) {
    return primary.withValues(alpha: opacity);
  }
  
  /// Retorna a cor secundária com opacidade
  static Color secondaryWithOpacity(double opacity) {
    return secondary.withValues(alpha: opacity);
  }
  
  /// Retorna cor de superfície baseada no tema
  static Color getSurfaceColor(bool isDark) {
    return isDark ? Color(0xFF121212) : background;
  }
  
  /// Retorna cor do texto baseada no tema
  static Color getTextColor(bool isDark) {
    return isDark ? textOnDark : textPrimary;
  }
}