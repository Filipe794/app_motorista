// Splash Screen do App Rota+ com animações e redirecionamento automático
import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../utils/responsive_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> 
    with TickerProviderStateMixin {
  
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startSplashSequence();
  }

  void _setupAnimations() {
    // Controlador para fade in/out
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Controlador para escala do logo
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Controlador para rotação do loading
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Animações
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));
  }

  void _startSplashSequence() async {
    // Iniciar animações
    _fadeController.forward();
    
    // Pequeno delay e então escala do logo
    await Future.delayed(const Duration(milliseconds: 200));
    _scaleController.forward();
    
    // Iniciar rotação do loading
    await Future.delayed(const Duration(milliseconds: 400));
    _rotationController.repeat();
    
    // Aguardar tempo total de splash (2 segundos)
    await Future.delayed(const Duration(seconds: 2));
    
    // Navegar para tela de login
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;
    final logoSize = isTablet ? 180.0 : 150.0;
    final titleFontSize = context.fontSize(isTablet ? 48 : 42);
    final subtitleFontSize = context.fontSize(isTablet ? 18 : 16);
    
    return Scaffold(
      backgroundColor: const Color(0xFF1E3A8A), // Azul similar ao logo
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.horizontalPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo principal com animação de escala
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: logoSize,
                    height: logoSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(logoSize * 0.13),
                      child: Icon(
                        Icons.directions_bus,
                        size: logoSize * 0.53,
                        color: const Color(0xFF1E3A8A),
                      ),
                    ),
                  ),
                ),
                
                SizedBox(height: context.verticalSpacing * 2),
                
                // Nome do app
                Text(
                  'Rota+',
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                
                SizedBox(height: context.verticalSpacing * 0.8),
                
                // Subtítulo
                Text(
                  'Gestão de Frota Municipal',
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    color: Colors.white70,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                
                SizedBox(height: context.verticalSpacing * 4),
                
                // Indicador de carregamento rotativo
                RotationTransition(
                  turns: _rotationAnimation,
                  child: Container(
                    width: isTablet ? 50 : 40,
                    height: isTablet ? 50 : 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                
                SizedBox(height: context.verticalSpacing * 1.5),
                
                // Texto de carregamento
                Text(
                  'Carregando...',
                  style: TextStyle(
                    fontSize: context.fontSize(14),
                    color: Colors.white54,
                  ),
                ),
                
                SizedBox(height: context.verticalSpacing * 4),
                
                // Rodapé com versão
                Text(
                  'v1.0.0',
                  style: TextStyle(
                    fontSize: context.fontSize(12),
                    color: Colors.white38,
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