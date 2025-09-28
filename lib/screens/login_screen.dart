// Tela de login do App Rota+ com autenticação por CPF e senha
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/responsive_helper.dart';
import '../utils/app_colors.dart';
import 'tela_inicial.dart';
import 'chamados/chamados_list_screen.dart';
import 'despesas/despesas_list_screen.dart';
import 'escalas/escalas_list_screen.dart';

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

  /// Formatter customizado para CPF que preserva a posição do cursor
  TextEditingValue _cpfFormatter(TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove tudo que não é número do novo valor
    final newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    
    // Limita a 11 dígitos
    final limitedText = newText.length > 11 ? newText.substring(0, 11) : newText;
    
    // Aplica a formatação
    String formattedText = '';
    for (int i = 0; i < limitedText.length; i++) {
      if (i == 3 || i == 6) {
        formattedText += '.';
      } else if (i == 9) {
        formattedText += '-';
      }
      formattedText += limitedText[i];
    }
    
    // Calcula a nova posição do cursor de forma mais simples
    int newCursorPosition = formattedText.length;
    
    // Se o usuário está digitando, mantém o cursor no final
    if (newValue.selection.baseOffset <= newValue.text.length) {
      newCursorPosition = formattedText.length;
    }
    
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
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
          // Extrair nome do motorista do CPF ou usar um nome padrão
          final cpfSemFormatacao = _cpfController.text.replaceAll(RegExp(r'[^0-9]'), '');
          final nomeMotorista = 'Motorista ${cpfSemFormatacao.substring(0, 3)}***';
          
          Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => 
                  TelaInicial(
                    userName: nomeMotorista,
                    onLogout: () {
                      // Voltar para a tela de login
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    onNavigationTap: (String itemTitle) {
                      // Navegar para a tela correspondente baseado no título
                      switch (itemTitle) {
                        case 'Chamados':
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChamadosListScreen(userName: nomeMotorista,),
                            ),
                          );
                          break;
                        case 'Despesas':
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DespesasListScreen(userName: nomeMotorista,),
                            ),
                          );
                          break;
                        case 'Escalas':
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EscalasListScreen(userName: nomeMotorista),
                            ),
                          );
                          break;
                        default:
                          // Exibir snackbar para itens não implementados
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Navegação para "$itemTitle" em desenvolvimento'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                      }
                    },
                  ),
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
            (Route<dynamic> route) => false, // Remove todas as rotas anteriores
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
              Icon(Icons.error_outline, color: AppColors.error),
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
                          color: AppColors.cardBackground,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadow,
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
                            color: AppColors.primaryDarkBlue,
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
                        color: AppColors.textOnDark,
                        letterSpacing: 2,
                      ),
                    ),
                    
                    SizedBox(height: context.verticalSpacing * 0.8),
                    
                    // Subtítulo
                    Text(
                      'Gestão de Frota Municipal',
                      style: TextStyle(
                        fontSize: context.fontSize(isTablet ? 18 : 16),
                        color: AppColors.textOnDarkSecondary,
                        fontWeight: FontWeight.w300,
                      ),
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
                                // Título do formulário
                                Text(
                                  'Acesso do Motorista',
                                  style: TextStyle(
                                    fontSize: context.fontSize(isTablet ? 24 : 20),
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryDarkBlue,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                
                                SizedBox(height: context.verticalSpacing * 2.5),
                                
                                // Campo CPF
                                TextFormField(
                                  controller: _cpfController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    TextInputFormatter.withFunction(_cpfFormatter),
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
                                      borderSide: BorderSide(
                                        color: AppColors.primaryDarkBlue,
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
                                      borderSide: BorderSide(
                                        color: AppColors.primaryDarkBlue,
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
                                      activeColor: AppColors.primaryDarkBlue,
                                    ),
                                    const Expanded(
                                      child: Text(
                                        'Lembrar de mim',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: _forgotPassword,
                                      child: Text(
                                        'Esqueci a senha',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.primaryDarkBlue,
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
                                      backgroundColor: AppColors.primaryDarkBlue,
                                      foregroundColor: AppColors.textOnDark,
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
                                                AppColors.textOnDark,
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
                    
                    SizedBox(height: context.verticalSpacing * 3),
                    
                    // Informações adicionais
                    Container(
                      padding: EdgeInsets.all(context.horizontalPadding),
                      decoration: BoxDecoration(
                        color: AppColors.overlayOnDark,
                        borderRadius: context.responsiveBorderRadius,
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: AppColors.textOnDarkSecondary,
                            size: 20,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Para problemas de acesso, entre em contato\ncom a Secretaria de Transportes',
                            style: TextStyle(
                              fontSize: context.fontSize(isTablet ? 14 : 12),
                              color: AppColors.textOnDarkSecondary,
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
                        color: AppColors.textOnDarkTertiary,
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
      ),
    );
  }
}