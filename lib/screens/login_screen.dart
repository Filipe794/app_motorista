// Tela de login do App Rota+ com autenticação por CPF e senha
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/responsive_helper.dart';
import 'chamados/chamados_list_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  // Controllers para os campos de texto
  final _cpfController = TextEditingController();
  final _senhaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  // Estados da interface
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;
  
  // Controladores de animação
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadSavedCredentials();
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

  void _loadSavedCredentials() {
    // TODO: Implementar carregamento de credenciais salvas do SharedPreferences
    // if (_rememberMe) {
    //   _cpfController.text = savedCpf;
    // }
  }

  String _formatCpf(String cpf) {
    // Remove tudo que não é número
    cpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');
    
    // Aplica a formatação XXX.XXX.XXX-XX
    if (cpf.length > 3) {
      cpf = '${cpf.substring(0, 3)}.${cpf.substring(3)}';
    }
    if (cpf.length > 7) {
      cpf = '${cpf.substring(0, 7)}.${cpf.substring(7)}';
    }
    if (cpf.length > 11) {
      cpf = '${cpf.substring(0, 11)}-${cpf.substring(11)}';
    }
    
    return cpf;
  }

  bool _validateCpf(String cpf) {
    // Remove formatação
    cpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');
    
    // Verifica se tem 11 dígitos
    if (cpf.length != 11) return false;
    
    // Verifica se todos os dígitos são iguais
    if (RegExp(r'^(\d)\1*$').hasMatch(cpf)) return false;
    
    // Validação do CPF (algoritmo oficial)
    int sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += int.parse(cpf[i]) * (10 - i);
    }
    int digit1 = 11 - (sum % 11);
    if (digit1 >= 10) digit1 = 0;
    
    sum = 0;
    for (int i = 0; i < 10; i++) {
      sum += int.parse(cpf[i]) * (11 - i);
    }
    int digit2 = 11 - (sum % 11);
    if (digit2 >= 10) digit2 = 0;
    
    return digit1 == int.parse(cpf[9]) && digit2 == int.parse(cpf[10]);
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Simular chamada de API
      await Future.delayed(const Duration(seconds: 2));
      
      // TODO: Implementar autenticação real
      // final success = await AuthService.login(
      //   cpf: _cpfController.text,
      //   senha: _senhaController.text,
      // );
      
      // Simulação de sucesso
      bool success = true;
      
      if (success) {
        // TODO: Salvar token e dados do usuário
        // if (_rememberMe) {
        //   await _saveCredentials();
        // }
        
        if (mounted) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => 
                  const ChamadosListScreen(),
              transitionDuration: const Duration(milliseconds: 500),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
            ),
          );
        }
      }
    } catch (e) {
      _showErrorDialog('Erro de conexão. Tente novamente.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red),
              SizedBox(width: 8),
              Text('Erro de Login'),
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

  void _forgotPassword() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Esqueci a Senha'),
          content: const Text(
            'Para recuperar sua senha, entre em contato com o administrador do sistema ou visite a secretaria de transportes.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Entendi'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _cpfController.dispose();
    _senhaController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;
    final logoSize = isTablet ? 140.0 : 120.0;
    
    return Scaffold(
      backgroundColor: const Color(0xFF1E3A8A),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(context.horizontalPadding),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: context.responsiveHeight(85),
              ),
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Espaçamento responsivo
                    SizedBox(height: context.verticalSpacing * 3),
                    
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
                            Icons.directions_bus,
                            size: logoSize * 0.5,
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
                        fontSize: context.fontSize(isTablet ? 38 : 32),
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
                        fontSize: context.fontSize(isTablet ? 18 : 16),
                        color: Colors.white70,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    
                    SizedBox(height: context.verticalSpacing * 3),
                    
                    // Card do formulário
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: isTablet ? 400 : double.infinity,
                      ),
                      child: Card(
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
                                // Título do formulário
                                Text(
                                  'Acesso do Motorista',
                                  style: TextStyle(
                                    fontSize: context.fontSize(isTablet ? 24 : 20),
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF1E3A8A),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                
                                SizedBox(height: context.verticalSpacing * 2.5),
                                
                                // Campo CPF
                                TextFormField(
                                  controller: _cpfController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(11),
                                    TextInputFormatter.withFunction((oldValue, newValue) {
                                      return newValue.copyWith(
                                        text: _formatCpf(newValue.text),
                                      );
                                    }),
                                  ],
                                  decoration: InputDecoration(
                                    labelText: 'CPF do Motorista',
                                    hintText: '000.000.000-00',
                                    prefixIcon: const Icon(Icons.person_outline),
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
                                      return 'Por favor, digite seu CPF';
                                    }
                                    if (!_validateCpf(value)) {
                                      return 'CPF inválido';
                                    }
                                    return null;
                                  },
                                ),
                                
                                SizedBox(height: context.verticalSpacing * 1.5),
                                
                                // Campo Senha
                                TextFormField(
                                  controller: _senhaController,
                                  obscureText: _obscurePassword,
                                  decoration: InputDecoration(
                                    labelText: 'Senha',
                                    hintText: 'Digite sua senha',
                                    prefixIcon: const Icon(Icons.lock_outline),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword 
                                            ? Icons.visibility_outlined 
                                            : Icons.visibility_off_outlined,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                    ),
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
                                      return 'Por favor, digite sua senha';
                                    }
                                    if (value.length < 4) {
                                      return 'A senha deve ter pelo menos 4 caracteres';
                                    }
                                    return null;
                                  },
                                ),
                                
                                SizedBox(height: context.verticalSpacing * 1.5),
                                
                                // Checkbox "Lembrar de mim"
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _rememberMe,
                                      onChanged: (value) {
                                        setState(() {
                                          _rememberMe = value ?? false;
                                        });
                                      },
                                      activeColor: const Color(0xFF1E3A8A),
                                    ),
                                    const Expanded(
                                      child: Text(
                                        'Lembrar de mim',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: _forgotPassword,
                                      child: const Text(
                                        'Esqueci a senha',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF1E3A8A),
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                
                                SizedBox(height: context.verticalSpacing * 2.5),
                                
                                // Botão de login
                                SizedBox(
                                  height: isTablet ? 56 : 50,
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _login,
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
                                              const Icon(Icons.login, size: 20),
                                              const SizedBox(width: 8),
                                              Text(
                                                'Entrar',
                                                style: TextStyle(
                                                  fontSize: isTablet ? 18 : 16,
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
                            'Para problemas de acesso, entre em contato\ncom a Secretaria de Transportes',
                            style: TextStyle(
                              fontSize: context.fontSize(isTablet ? 14 : 12),
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: context.verticalSpacing * 2),
                    
                    // Versão do app
                    Text(
                      'Rota+ v1.0.0 - Prefeitura Municipal',
                      style: TextStyle(
                        fontSize: context.fontSize(isTablet ? 12 : 10),
                        color: Colors.white38,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}