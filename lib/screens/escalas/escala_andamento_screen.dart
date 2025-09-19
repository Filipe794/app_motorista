// TODO: Implementar funcionalidades de GPS tracking
// TODO: Adicionar sistema de check-in nas paradas
// TODO: Implementar botão de emergência
// TODO: Adicionar comunicação com central
// TODO: Implementar registro de ocorrências

import 'dart:async';
import 'package:flutter/material.dart';
import '../../utils/responsive_helper.dart';
import '../chamados/criar_chamado_screen.dart';

class EscalaAndamentoScreen extends StatefulWidget {
  final String escalaId;
  
  const EscalaAndamentoScreen({
    super.key,
    required this.escalaId,
  });

  @override
  State<EscalaAndamentoScreen> createState() => _EscalaAndamentoScreenState();
}

class _EscalaAndamentoScreenState extends State<EscalaAndamentoScreen> {
  // Timer para atualizar o contador
  Timer? _timer;
  Duration _tempoEscala = Duration.zero;
  bool _escalaAtiva = true;
  
  // Dados simulados da escala
  final int _totalParadas = 4;
  final int _paradasConcluidas = 1;
  final int _passageirosEmbarcados = 12;
  final String _rota = 'Centro - Antenor Viana';
  
  @override
  void initState() {
    super.initState();
    _iniciarTimer();
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Escala em Andamento',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
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
                
                // Conteúdo principal
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(context.horizontalPadding),
                    child: Column(
                      children: [
                        SizedBox(height: context.verticalSpacing),
                        
                        // Botões de navegação
                        _buildNavigationButtons(),
                        
                        const Spacer(),
                        
                        // Botão deslizante na parte inferior
                        _buildSlideButton(),
                        
                        SizedBox(height: context.verticalSpacing),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildExpandedHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
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
                        'Escala em Andamento',
                        style: TextStyle(
                          fontSize: context.fontSize(context.isTablet ? 22 : 20),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: context.verticalSpacing * 0.3),
                      Text(
                        _rota,
                        style: TextStyle(
                          fontSize: context.fontSize(context.isTablet ? 16 : 14),
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(width: context.cardSpacing),
                
                // Botão de pausa/finalizar
                GestureDetector(
                  onTap: _pausarOuFinalizarEscala,
                  child: Container(
                    padding: EdgeInsets.all(context.isTablet ? 12 : 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      _escalaAtiva ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: context.isTablet ? 28 : 24,
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: context.verticalSpacing * 1.5),
            
            // Estatísticas
            Row(
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
            ),
            
            SizedBox(height: context.verticalSpacing * 1.5),
          ],
        ),
      ),
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
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: context.isTablet ? 24 : 20,
          ),
          SizedBox(height: context.verticalSpacing * 0.3),
          Text(
            title,
            style: TextStyle(
              fontSize: context.fontSize(10),
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: context.verticalSpacing * 0.2),
          Text(
            value,
            style: TextStyle(
              fontSize: context.fontSize(context.isTablet ? 16 : 14),
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildNavigationButtons() {
    final buttons = [
      {
        'title': 'Visualizar Paradas',
        'icon': Icons.location_on,
        'color': const Color(0xFF2196F3),
        'onTap': () {
          // TODO: Navegar para visualizar paradas
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Visualizar Paradas em desenvolvimento')),
          );
        },
      },
      {
        'title': 'Lista de Passageiros',
        'icon': Icons.people,
        'color': const Color(0xFF4CAF50),
        'onTap': () {
          // TODO: Navegar para lista de passageiros
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Lista de Passageiros em desenvolvimento')),
          );
        },
      },
      {
        'title': 'Abrir Chamado',
        'icon': Icons.report_problem,
        'color': const Color(0xFFFF9800),
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CriarChamadoScreen(),
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
                foregroundColor: Colors.white,
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
        gradient: const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
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
                  Icons.qr_code_scanner,
                  color: Colors.white,
                  size: context.isTablet ? 24 : 20,
                ),
                SizedBox(width: context.cardSpacing),
                Text(
                  'Deslize para Validar Ticket',
                  style: TextStyle(
                    fontSize: context.fontSize(context.isTablet ? 16 : 14),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: context.cardSpacing),
                Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: context.isTablet ? 24 : 20,
                ),
              ],
            ),
          ),
          
          // Botão tocável (temporário até implementar slide)
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // TODO: Navegar para tela de validação de ticket
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Validação de Ticket em desenvolvimento')),
                );
              },
              borderRadius: BorderRadius.circular(30),
              child: Container(
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
        color: Colors.white,
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
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            Text(
              'Ações da Escala',
              style: TextStyle(
                fontSize: context.fontSize(context.isTablet ? 20 : 18),
                fontWeight: FontWeight.bold,
                color: Colors.black87,
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_escalaAtiva ? 'Escala retomada' : 'Escala pausada'),
                    ),
                  );
                },
                icon: Icon(_escalaAtiva ? Icons.pause : Icons.play_arrow),
                label: Text(_escalaAtiva ? 'Pausar Escala' : 'Retomar Escala'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9800),
                  foregroundColor: Colors.white,
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
                  backgroundColor: const Color(0xFFE53935),
                  foregroundColor: Colors.white,
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
                  foregroundColor: Colors.grey[600],
                  side: BorderSide(color: Colors.grey[300]!),
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
              Icon(Icons.warning, color: Color(0xFFE53935)),
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
                Navigator.of(context).pop(); // Volta para a tela anterior
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Escala finalizada com sucesso')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE53935),
                foregroundColor: Colors.white,
              ),
              child: const Text('Finalizar'),
            ),
          ],
        );
      },
    );
  }
}