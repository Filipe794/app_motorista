import 'package:flutter/material.dart';

/// Sistema de responsividade centralizado para padronizar breakpoints
/// e facilitar adaptação da interface em diferentes tamanhos de tela
class ResponsiveHelper {
  // Breakpoints padronizados
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;
  
  // Espaçamentos responsivos baseados em porcentagens
  static const double basePadding = 16.0;
  static const double baseMargin = 8.0;
  
  /// Determina se o dispositivo é mobile (tela pequena)
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }
  
  /// Determina se o dispositivo é tablet (tela média)
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }
  
  /// Determina se o dispositivo é desktop (tela grande)
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletBreakpoint;
  }
  
  /// Retorna padding horizontal responsivo baseado na largura da tela
  static double getHorizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return width * 0.05; // 5% da largura em mobile
    } else if (width < tabletBreakpoint) {
      return width * 0.06; // 6% da largura em tablet (reduzido para usar mais espaço)
    } else {
      return width * 0.08; // 8% da largura em desktop (reduzido)
    }
  }
  
  /// Retorna espaçamento vertical responsivo
  static double getVerticalSpacing(BuildContext context, {double multiplier = 1.0}) {
    final height = MediaQuery.of(context).size.height;
    return (height * 0.02) * multiplier; // 2% da altura base
  }
  
  /// Calcula tamanho de fonte responsivo considerando textScaleFactor para acessibilidade
  static double getFontSize(BuildContext context, double baseFontSize) {
    final width = MediaQuery.of(context).size.width;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    
    double scaleFactor = 1.0;
    if (width < mobileBreakpoint) {
      scaleFactor = 0.9;
    } else if (width < tabletBreakpoint) {
      scaleFactor = 1.0;
    } else {
      scaleFactor = 1.1;
    }
    
    return (baseFontSize * scaleFactor) * textScaleFactor;
  }
  
  /// Retorna o número de colunas para grids baseado na largura da tela
  static int getGridColumns(BuildContext context, {int maxColumns = 3}) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return maxColumns.clamp(1, 2); // Máximo 2 colunas em mobile
    } else if (width < tabletBreakpoint) {
      return maxColumns.clamp(2, 3); // 2-3 colunas em tablet
    } else {
      return maxColumns; // Todas as colunas em desktop
    }
  }
  
  /// Retorna altura responsiva baseada em porcentagem da tela
  static double getResponsiveHeight(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.height * (percentage / 100);
  }
  
  /// Retorna largura responsiva baseada em porcentagem da tela
  static double getResponsiveWidth(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.width * (percentage / 100);
  }
  
  /// Retorna espaçamento para cards baseado no tamanho da tela
  static double getCardSpacing(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return width * 0.02; // 2% em mobile
    } else if (width < tabletBreakpoint) {
      return width * 0.015; // 1.5% em tablet
    } else {
      return width * 0.01; // 1% em desktop
    }
  }
  
  /// Configuração de BorderRadius responsivo
  static BorderRadius getResponsiveBorderRadius(BuildContext context, {double baseBorderRadius = 15.0}) {
    final width = MediaQuery.of(context).size.width;
    double scaleFactor = 1.0;
    
    if (width < mobileBreakpoint) {
      scaleFactor = 0.8;
    } else if (width >= tabletBreakpoint) {
      scaleFactor = 1.2;
    }
    
    return BorderRadius.circular(baseBorderRadius * scaleFactor);
  }
  
  /// Retorna largura máxima adequada para containers em diferentes dispositivos
  static double getMaxContainerWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return double.infinity; // Usar toda largura em mobile
    } else if (width < tabletBreakpoint) {
      return width * 0.85; // 85% da largura em tablet (mais espaço que antes)
    } else {
      return width * 0.6; // 60% da largura em desktop
    }
  }
}

/// Enum para definir tipos de dispositivos de forma mais semântica
enum DeviceType { mobile, tablet, desktop }

/// Extension para facilitar o uso do ResponsiveHelper
extension ResponsiveContext on BuildContext {
  bool get isMobile => ResponsiveHelper.isMobile(this);
  bool get isTablet => ResponsiveHelper.isTablet(this);
  bool get isDesktop => ResponsiveHelper.isDesktop(this);
  
  double get horizontalPadding => ResponsiveHelper.getHorizontalPadding(this);
  double get verticalSpacing => ResponsiveHelper.getVerticalSpacing(this);
  double get cardSpacing => ResponsiveHelper.getCardSpacing(this);
  
  double responsiveHeight(double percentage) => ResponsiveHelper.getResponsiveHeight(this, percentage);
  double responsiveWidth(double percentage) => ResponsiveHelper.getResponsiveWidth(this, percentage);
  
  double fontSize(double base) => ResponsiveHelper.getFontSize(this, base);
  
  BorderRadius get responsiveBorderRadius => ResponsiveHelper.getResponsiveBorderRadius(this);
  
  double get maxContainerWidth => ResponsiveHelper.getMaxContainerWidth(this);
}