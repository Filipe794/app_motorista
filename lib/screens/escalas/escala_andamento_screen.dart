// TODO: Implementar funcionalidades de GPS tracking
// TODO: Adicionar sistema de check-in nas paradas
// TODO: Implementar botão de emergência
// TODO: Adicionar comunicação com central
// TODO: Implementar registro de ocorrências

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../utils/responsive_helper.dart';
import '../../utils/app_colors.dart';
import '../passageiros/passageiros_list_screen.dart';
import '../chamados/criar_chamado_screen.dart';
import '../validacao/validar_ticket_screen.dart';
import 'monitoramento_tempo_real_screen.dart';

class EscalaAndamentoScreen extends StatefulWidget {
  final String escalaId;
  final String userName;
  
  const EscalaAndamentoScreen({
    super.key,
    required this.escalaId,
    required this.userName,
  });

  @override
  State<EscalaAndamentoScreen> createState() => _EscalaAndamentoScreenState();
}

class _EscalaAndamentoScreenState extends State<EscalaAndamentoScreen> with WidgetsBindingObserver {
  // Timer para atualizar o contador
  Timer? _timer;
  Duration _tempoEscala = Duration.zero;
  bool _escalaAtiva = true;
  
  // Controle de localização
  bool _localizacaoPermitida = false;
  bool _escalaIniciada = false;
  
  // Dados simulados da escala
  final int _totalParadas = 4;
  final int _paradasConcluidas = 1;
  final int _passageirosEmbarcados = 12;
  final String _rota = 'Centro - Antenor Viana';
  
  @override
  void initState() {
    super.initState();
    // Adicionar observer para detectar mudanças no ciclo de vida do app
    WidgetsBinding.instance.addObserver(this);
    // Timer será iniciado apenas quando a escala for iniciada
    // _iniciarTimer();
  }
  
  @override
  void dispose() {
    // Remover observer
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    // Se o app vai para segundo plano e a escala está ativa
    if (state == AppLifecycleState.paused && _escalaIniciada && _escalaAtiva) {
      _mostrarNotificacaoEscalaAtiva();
    }
    
    // Quando o app volta para primeiro plano
    if (state == AppLifecycleState.resumed && _escalaIniciada && !_escalaAtiva) {
      _mostrarDialogoRetornoEscala();
    }
  }
  
  void _mostrarNotificacaoEscalaAtiva() {
    // Aqui você pode implementar uma notificação local
    // Por enquanto, vamos apenas marcar que o app foi minimizado com escala ativa
    debugPrint('App minimizado com escala ativa - usuário: ${widget.userName}');
  }
  
  void _mostrarDialogoRetornoEscala() {
    // Mostrar diálogo quando voltar ao app com escala pausada
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.play_circle, color: AppColors.success, size: 28),
                SizedBox(width: 12),
                Text('Retomar Escala?'),
              ],
            ),
            content: const Text(
              'Sua escala foi pausada quando você saiu do aplicativo.\n\n'
              'Deseja retomar a escala agora?',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Manter Pausada'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _escalaAtiva = true;
                  });
                  
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.play_arrow, color: Colors.white),
                            SizedBox(width: 12),
                            Text('Escala retomada com sucesso!'),
                          ],
                        ),
                        backgroundColor: AppColors.success,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: AppColors.textOnDark,
                ),
                child: const Text('Retomar Escala'),
              ),
            ],
          ),
        );
      }
    });
  }
  
  void _iniciarTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_escalaAtiva) {
        setState(() {
          _tempoEscala = Duration(seconds: _tempoEscala.inSeconds + 1);
        });
      }
    });
  }
  
  void _pausarOuFinalizarEscala() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildActionModal(),
    );
  }
  
  String _formatarTempo(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }
  
  // Método para solicitar permissão de localização
  Future<void> _solicitarPermissaoLocalizacao() async {
    try {
      // Verificar se o serviço de localização está habilitado
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _mostrarDialogoServicoLocalizacao();
        return;
      }

      // Verificar permissões
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _mostrarDialogoPermissaoNegada();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _mostrarDialogoPermissaoNegadaPermanente();
        return;
      }

      // Permissão concedida, iniciar escala
      setState(() {
        _localizacaoPermitida = true;
        _escalaIniciada = true;
      });
      
      _mostrarSnackBarSucesso();
      
    } catch (e) {
      _mostrarErro('Erro ao solicitar permissão: $e');
    }
  }
  
  // Método principal para iniciar escala
  Future<void> _iniciarEscala() async {
    // Mostrar diálogo de aviso sobre compartilhamento de localização
    bool? aceitou = await _mostrarDialogoCompartilhamentoLocalizacao();
    
    if (aceitou == true) {
      await _solicitarPermissaoLocalizacao();
      // Se a localização foi permitida, iniciar o timer
      if (_localizacaoPermitida) {
        _iniciarTimer();
      }
    }
  }
  
  // Diálogo de confirmação sobre compartilhamento de localização
  Future<bool?> _mostrarDialogoCompartilhamentoLocalizacao() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.location_on, color: AppColors.warning, size: 28),
              SizedBox(width: 12),
              Text(
                'Compartilhar Localização',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          content: const Text(
            'Para iniciar a escala, é necessário compartilhar sua localização. '
            'Isso permitirá que a central monitore a rota em tempo real e '
            'garanta a segurança dos passageiros.\n\n'
            'Sua localização será compartilhada apenas durante a escala ativa.',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDarkBlue,
                foregroundColor: AppColors.textOnDark,
              ),
              child: const Text('Aceitar e Iniciar'),
            ),
          ],
        );
      },
    );
  }
  
  // Diálogos de erro e informação
  void _mostrarDialogoServicoLocalizacao() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Serviço de Localização'),
        content: const Text(
          'O serviço de localização está desabilitado. '
          'Por favor, habilite-o nas configurações do dispositivo.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  
  void _mostrarDialogoPermissaoNegada() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permissão Necessária'),
        content: const Text(
          'A permissão de localização é necessária para iniciar a escala. '
          'Tente novamente e conceda a permissão.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  
  void _mostrarDialogoPermissaoNegadaPermanente() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permissão Negada'),
        content: const Text(
          'A permissão de localização foi negada permanentemente. '
          'Para iniciar a escala, vá nas configurações do app e '
          'habilite a permissão de localização.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Geolocator.openAppSettings();
            },
            child: const Text('Abrir Configurações'),
          ),
        ],
      ),
    );
  }
  
  void _mostrarSnackBarSucesso() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text('Localização ativada! Escala iniciada com sucesso.',style: TextStyle(fontSize: 12),),
          ],
        ),
        backgroundColor: AppColors.primaryDarkBlue,
        duration: Duration(seconds: 3),
      ),
    );
  }
  
  void _mostrarErro(String mensagem) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(mensagem)),
          ],
        ),
        backgroundColor: AppColors.error,
        duration: const Duration(seconds: 4),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          title: Text(
            _escalaIniciada ? 'Escala em Andamento' : 'Iniciar Escala',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textOnDark,
            ),
          ),
          backgroundColor: AppColors.primaryDarkBlue,
          foregroundColor: AppColors.textOnDark,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: AppColors.textOnDark),
          // Interceptar o botão de voltar também
          leading: _escalaIniciada && _escalaAtiva 
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.textOnDark),
                onPressed: () => _tentarSairDaTela(),
              )
            : null,
        ),
        body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: context.maxContainerWidth,
            ),
            child: Column(
              children: [
                // Header expandido
                _buildExpandedHeader(),
                
                // Conteúdo principal flexível
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(context.horizontalPadding),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: context.verticalSpacing),
                        
                        // Conteúdo condicional baseado no status da escala
                        if (_escalaIniciada) ...[
                          // Cards de estatísticas
                          _buildStatsCards(),
                          
                          SizedBox(height: context.verticalSpacing * 1.5),
                          
                          // Botões de navegação
                          _buildNavigationButtons(),
                          
                          SizedBox(height: context.verticalSpacing * 2),
                        ] else ...[
                          // Instruções para iniciar escala
                          _buildInstrucoesIniciarEscala(),
                          
                          SizedBox(height: context.verticalSpacing * 2),
                        ],
                      ],
                    ),
                  ),
                ),
                
                // Botão deslizante fixo na parte inferior
                Container(
                  padding: EdgeInsets.fromLTRB(
                    context.horizontalPadding,
                    0,
                    context.horizontalPadding,
                    context.verticalSpacing,
                  ),
                  child: _buildSlideButton(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  // Método para tentar sair da tela com verificação de escala ativa
  void _tentarSairDaTela() async {
    if (_escalaIniciada && _escalaAtiva) {
      bool? canExit = await _mostrarDialogoConfirmacaoSaida();
      if (canExit == true && mounted) {
        Navigator.of(context).pop();
      }
    } else {
      // Se escala não está ativa, pode sair normalmente
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  // Método para confirmar saída durante escala ativa
  Future<bool?> _mostrarDialogoConfirmacaoSaida() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 28),
              SizedBox(width: 12),
              Text(
                'Escala em Andamento',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          content: const Text(
            'Você tem uma escala ativa em andamento!\n\n'
            'Para sair desta tela, você deve primeiro pausar ou finalizar a escala. '
            'Isso garante a segurança dos passageiros e o controle adequado da rota.\n\n'
            'Deseja pausar a escala agora?',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Continuar Escala'),
            ),
            ElevatedButton(
              onPressed: () {
                // Pausar a escala automaticamente
                setState(() {
                  _escalaAtiva = false;
                });
                
                Navigator.of(context).pop(true);
                
                // Mostrar feedback
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.pause_circle, color: Colors.white),
                          SizedBox(width: 12),
                          Text('Escala pausada. Você pode retomar quando voltar.'),
                        ],
                      ),
                      backgroundColor: AppColors.warning,
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.warning,
                foregroundColor: AppColors.textOnDark,
              ),
              child: const Text('Pausar e Sair'),
            ),
          ],
        );
      },
    );
  }
  
  Widget _buildExpandedHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surfaceMedium,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(context.horizontalPadding),
        child: Column(
          children: [
            SizedBox(height: context.verticalSpacing),
            
            // Título e botão de ação
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rota Ativa',
                        style: TextStyle(
                          fontSize: context.fontSize(context.isTablet ? 22 : 20),
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: context.verticalSpacing * 0.3),
                      Text(
                        _rota,
                        style: TextStyle(
                          fontSize: context.fontSize(context.isTablet ? 16 : 14),
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: context.verticalSpacing * 0.5),
                      // Indicador de status da localização
                      Row(
                        children: [
                          Icon(
                            _escalaIniciada ? Icons.location_on : Icons.location_off,
                            color: _escalaIniciada ? AppColors.success : AppColors.warning,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _escalaIniciada ? 'Localização ativa' : 'Aguardando início',
                            style: TextStyle(
                              fontSize: context.fontSize(12),
                              color: _escalaIniciada ? AppColors.success : AppColors.warning,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                SizedBox(width: context.cardSpacing),
                
                // Botão de pausa/finalizar (só aparece quando escala iniciada)
                if (_escalaIniciada)
                  GestureDetector(
                    onTap: _pausarOuFinalizarEscala,
                    child: Container(
                      padding: EdgeInsets.all(context.isTablet ? 12 : 10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryDarkBlue.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primaryDarkBlue,
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        _escalaAtiva ? Icons.pause : Icons.play_arrow,
                        color: AppColors.primaryDarkBlue,
                        size: context.isTablet ? 28 : 24,
                      ),
                    ),
                  ),
              ],
            ),
            
            SizedBox(height: context.verticalSpacing * 1.5),
          ],
        ),
      ),
    );
  }  Widget _buildStatsCards() {
    return Row(
      children: [
        // Paradas
        Expanded(
          child: _buildStatCard(
            icon: Icons.location_on,
            title: 'Paradas',
            value: '$_paradasConcluidas/$_totalParadas',
          ),
        ),
        
        SizedBox(width: context.cardSpacing),
        
        // Passageiros
        Expanded(
          child: _buildStatCard(
            icon: Icons.people,
            title: 'Passageiros',
            value: '$_passageirosEmbarcados',
          ),
        ),
        
        SizedBox(width: context.cardSpacing),
        
        // Tempo
        Expanded(
          child: _buildStatCard(
            icon: Icons.timer,
            title: 'Tempo',
            value: _formatarTempo(_tempoEscala),
          ),
        ),
      ],
    );
  }
  
  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.all(context.isTablet ? 16 : 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.surfaceLight,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.primaryDarkBlue,
            size: context.isTablet ? 24 : 20,
          ),
          SizedBox(height: context.verticalSpacing * 0.3),
          Text(
            title,
            style: TextStyle(
              fontSize: context.fontSize(10),
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: context.verticalSpacing * 0.2),
          Text(
            value,
            style: TextStyle(
              fontSize: context.fontSize(context.isTablet ? 16 : 14),
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInstrucoesIniciarEscala() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.isTablet ? 16 : 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Ícone principal
          Container(
            padding: EdgeInsets.all(context.isTablet ? 10 : 8),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(
              Icons.location_on,
              size: context.isTablet ? 28 : 24,
              color: AppColors.warning,
            ),
          ),
          
          SizedBox(height: context.verticalSpacing * 0.6),
          
          // Título
          Text(
            'Pronto para começar?',
            style: TextStyle(
              fontSize: context.fontSize(context.isTablet ? 18 : 16),
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: context.verticalSpacing * 0.4),
          
          // Descrição compacta
          Text(
            'Para iniciar sua escala, compartilhe sua localização para monitoramento da rota.',
            style: TextStyle(
              fontSize: context.fontSize(context.isTablet ? 15 : 13),
              color: AppColors.textSecondary,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: context.verticalSpacing * 0.8),
          
          // Lista de benefícios vertical compacta
          Column(
            children: [
              _buildBeneficioRow('📍', 'Localização em tempo real'),
              SizedBox(height: context.verticalSpacing * 0.2),
              _buildBeneficioRow('🚌', 'Monitoramento da rota'),
              SizedBox(height: context.verticalSpacing * 0.2),
              _buildBeneficioRow('👥', 'Segurança dos passageiros'),
            ],
          ),
          
          SizedBox(height: context.verticalSpacing * 0.6),
          
          // Nota de segurança compacta
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.isTablet ? 12 : 10,
              vertical: context.isTablet ? 8 : 6,
            ),
            decoration: BoxDecoration(
              color: AppColors.primaryDarkBlue.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.security,
                  color: AppColors.primaryDarkBlue,
                  size: context.isTablet ? 14 : 12,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Privacidade garantida: localização compartilhada apenas durante a escala.',
                    style: TextStyle(
                      fontSize: context.fontSize(context.isTablet ? 11 : 10),
                      color: AppColors.primaryDarkBlue,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBeneficioRow(String emoji, String texto) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          emoji,
          style: TextStyle(fontSize: context.fontSize(context.isTablet ? 16 : 14)),
        ),
        SizedBox(width: context.isTablet ? 6 : 4),
        Expanded(
          child: Text(
            texto,
            style: TextStyle(
              fontSize: context.fontSize(context.isTablet ? 14 : 12),
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildNavigationButtons() {
    final buttons = [
      {
        'title': 'Visualizar Paradas',
        'icon': Icons.map,
        'color': AppColors.primaryDarkBlue,
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MonitoramentoTempoRealScreen(),
            ),
          );
        },
      },
      {
        'title': 'Lista de Passageiros',
        'icon': Icons.people,
        'color': AppColors.primaryDarkBlue,
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PassageirosListScreen(escalaId: widget.escalaId),
            ),
          );
        },
      },
      {
        'title': 'Abrir Chamado',
        'icon': Icons.report_problem,
        'color': AppColors.warning,
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CriarChamadoScreen(userName: widget.userName),
            ),
          );
        },
      },
    ];

    return Column(
      children: buttons.map((button) {
        return Container(
          margin: EdgeInsets.only(bottom: context.verticalSpacing),
          child: SizedBox(
            width: double.infinity,
            height: context.isTablet ? 60 : 56,
            child: ElevatedButton.icon(
              onPressed: button['onTap'] as VoidCallback,
              icon: Icon(
                button['icon'] as IconData,
                size: context.isTablet ? 24 : 20,
              ),
              label: Text(
                button['title'] as String,
                style: TextStyle(
                  fontSize: context.fontSize(context.isTablet ? 16 : 14),
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: button['color'] as Color,
                foregroundColor: AppColors.textOnDark,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: context.responsiveBorderRadius,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
  
  Widget _buildSlideButton() {
    return Container(
      width: double.infinity,
      height: context.isTablet ? 70 : 60,
      decoration: BoxDecoration(
        color: AppColors.primaryDarkBlue,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Texto centralizado
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _escalaIniciada ? Icons.qr_code_scanner : Icons.play_arrow,
                  color: AppColors.textOnDark,
                  size: context.isTablet ? 24 : 20,
                ),
                SizedBox(width: context.cardSpacing),
                Text(
                  _escalaIniciada ? 'Validar Ticket' : 'Iniciar Escala',
                  style: TextStyle(
                    fontSize: context.fontSize(context.isTablet ? 16 : 14),
                    fontWeight: FontWeight.bold,
                    color: AppColors.textOnDark,
                  ),
                ),
                SizedBox(width: context.cardSpacing),
              ],
            ),
          ),
          

          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (_escalaIniciada) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ValidarTicketScreen(escalaId: widget.escalaId),
                    ),
                  );
                } else {
                  _iniciarEscala();
                }
              },
              borderRadius: BorderRadius.circular(30),
              child: const SizedBox(
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildActionModal() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(context.horizontalPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle do modal
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.only(bottom: context.verticalSpacing),
              decoration: BoxDecoration(
                color: AppColors.surfaceMedium,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            Text(
              'Ações da Escala',
              style: TextStyle(
                fontSize: context.fontSize(context.isTablet ? 20 : 18),
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            
            SizedBox(height: context.verticalSpacing * 1.5),
            
            // Botão Pausar
            SizedBox(
              width: double.infinity,
              height: context.isTablet ? 56 : 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _escalaAtiva = !_escalaAtiva;
                  });
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(_escalaAtiva ? 'Escala retomada' : 'Escala pausada'),
                      ),
                    );
                  }
                },
                icon: Icon(_escalaAtiva ? Icons.pause : Icons.play_arrow),
                label: Text(_escalaAtiva ? 'Pausar Escala' : 'Retomar Escala'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDarkBlue,
                  foregroundColor: AppColors.textOnDark,
                  shape: RoundedRectangleBorder(
                    borderRadius: context.responsiveBorderRadius,
                  ),
                ),
              ),
            ),
            
            SizedBox(height: context.verticalSpacing),
            
            // Botão Finalizar
            SizedBox(
              width: double.infinity,
              height: context.isTablet ? 56 : 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _confirmarFinalizarEscala();
                },
                icon: const Icon(Icons.stop),
                label: const Text('Finalizar Escala'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: AppColors.textOnDark,
                  shape: RoundedRectangleBorder(
                    borderRadius: context.responsiveBorderRadius,
                  ),
                ),
              ),
            ),
            
            SizedBox(height: context.verticalSpacing),
            
            // Botão Cancelar
            SizedBox(
              width: double.infinity,
              height: context.isTablet ? 50 : 44,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  side: BorderSide(color: AppColors.surfaceMedium),
                  shape: RoundedRectangleBorder(
                    borderRadius: context.responsiveBorderRadius,
                  ),
                ),
                child: const Text('Cancelar'),
              ),
            ),
            
            SizedBox(height: context.verticalSpacing),
          ],
        ),
      ),
    );
  }
  
  void _confirmarFinalizarEscala() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning, color: AppColors.error),
              SizedBox(width: 8),
              Text('Finalizar Escala'),
            ],
          ),
          content: const Text(
            'Tem certeza que deseja finalizar esta escala?\n\n'
            'Esta ação não pode ser desfeita.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o dialog
                
                // Reset o estado da escala
                setState(() {
                  _escalaIniciada = false;
                  _localizacaoPermitida = false;
                  _escalaAtiva = true;
                  _tempoEscala = Duration.zero;
                });
                
                // Para o timer se estiver rodando
                _timer?.cancel();
                
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Escala finalizada com sucesso! Você pode iniciar uma nova escala.'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDarkBlue,
                foregroundColor: AppColors.textOnDark,
              ),
              child: const Text('Finalizar'),
            ),
          ],
        );
      },
    );
  }
}