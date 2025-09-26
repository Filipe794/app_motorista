// Tela de recuperação de senha do App Rota+ 
// Permite que o motorista solicite recuperação de senha via email
import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';
import '../utils/app_colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> with TickerProviderStateMixin {
  // Controllers para os campos de texto
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  // Estados da interface
  bool _isLoading = false;
  bool _emailSent = false;
  
  // Controladores de animação
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Iniciar animações
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _slideController.forward();
    });
  }
  bool _validateEmail(String email) {
    // Regex para validação de email
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  Future<void> _sendRecoveryEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Simular chamada de API para envio de email
      await Future.delayed(const Duration(seconds: 2));
      
      // TODO: Implementar chamada real para API de recuperação
      // final success = await AuthService.sendPasswordReset(
      //   email: _emailController.text,
      // );
      
      // Simulação de sucesso
      bool success = true;
      
      if (success) {
        setState(() {
          _emailSent = true;
        });
        
        _showSuccessDialog();
      }
    } catch (e) {
      _showErrorDialog('Erro ao enviar email. Tente novamente.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: AppColors.success),
              SizedBox(width: 8),
              Text('Email Enviado'),
            ],
          ),
          content: Text(
            'Instruções para recuperação de senha foram enviadas para ${_emailController.text}.\n\nVerifique sua caixa de entrada e spam.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o dialog
                Navigator.of(context).pop(); // Volta para login
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.error_outline, color: AppColors.error),
              SizedBox(width: 8),
              Text('Erro'),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;
    final logoSize = isTablet ? 100.0 : 80.0;
    
    return Scaffold(
      backgroundColor: AppColors.primaryDarkBlue,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(context.horizontalPadding),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: context.responsiveHeight(85),
                  maxWidth: context.maxContainerWidth,
                ),
                child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Botão de voltar
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: AppColors.textOnDark,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.textOnDark.withValues(alpha: 0.1),
                            padding: const EdgeInsets.all(12),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: context.verticalSpacing * 2),
                    
                    // Logo do app
                    Hero(
                      tag: 'app_logo',
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
                          padding: EdgeInsets.all(logoSize * 0.14),
                          child: Icon(
                            Icons.lock_reset,
                            size: logoSize * 0.5,
                            color: const Color(0xFF1E3A8A),
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: context.verticalSpacing * 2),
                    
                    // Título
                    Text(
                      'Esqueci a Senha',
                      style: TextStyle(
                        fontSize: context.fontSize(isTablet ? 32 : 28),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    SizedBox(height: context.verticalSpacing),
                    
                    // Descrição
                    Text(
                      'Insira seu email de cadastro\npara receber instruções de recuperação',
                      style: TextStyle(
                        fontSize: context.fontSize(isTablet ? 16 : 14),
                        color: Colors.white70,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    SizedBox(height: context.verticalSpacing * 3),
                    
                    // Card do formulário
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: context.responsiveBorderRadius,
                      ),
                      child: Padding(
                          padding: EdgeInsets.all(context.horizontalPadding * 1.5),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Ícone do formulário
                                Icon(
                                  Icons.email_outlined,
                                  size: isTablet ? 48 : 40,
                                  color: const Color(0xFF1E3A8A),
                                ),
                                
                                SizedBox(height: context.verticalSpacing * 1.5),
                                
                                // Campo Email
                                TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    labelText: 'Email de Cadastro',
                                    hintText: 'exemplo@email.com',
                                    prefixIcon: const Icon(Icons.email_outlined),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF1E3A8A),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, digite seu email';
                                    }
                                    if (!_validateEmail(value)) {
                                      return 'Email inválido';
                                    }
                                    return null;
                                  },
                                ),
                                
                                SizedBox(height: context.verticalSpacing * 2.5),
                                
                                // Botão de enviar
                                SizedBox(
                                  height: isTablet ? 56 : 50,
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _sendRecoveryEmail,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF1E3A8A),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 4,
                                    ),
                                    child: _isLoading
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.send, size: 20),
                                              const SizedBox(width: 8),
                                              Text(
                                                'Enviar Email',
                                                style: TextStyle(
                                                  fontSize: context.fontSize(isTablet ? 18 : 16),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ),
                    
                    SizedBox(height: context.verticalSpacing * 3),
                    
                    // Informações adicionais
                    Container(
                      padding: EdgeInsets.all(context.horizontalPadding),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: context.responsiveBorderRadius,
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: Colors.white70,
                            size: 20,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Não recebeu o email?\nVerifique sua caixa de spam ou entre em contato\ncom a Secretaria de Transportes',
                            style: TextStyle(
                              fontSize: context.fontSize(isTablet ? 14 : 12),
                              color: Colors.white70,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: context.verticalSpacing * 2),
                    
                    // Link de volta ao login
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Voltar ao Login',
                        style: TextStyle(
                          fontSize: context.fontSize(isTablet ? 16 : 14),
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ),
          ),
        ),
      ),
    );
  }
}