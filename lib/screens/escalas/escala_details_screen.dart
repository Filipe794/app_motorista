// TODO: Implementar detalhes da escala selecionada
// TODO: Adicionar mapa interativo da rota
// TODO: Implementar confirmação de presença
// TODO: Adicionar lista de paradas
// TODO: Implementar compartilhamento da escala
// TODO: Adicionar botão de emergência

import 'package:flutter/material.dart';
import '../../utils/responsive_helper.dart';
import '../../utils/app_colors.dart';
import 'escala_andamento_screen.dart';

class EscalaDetailsScreen extends StatefulWidget {
  final String escalaId;
  final String userName;
  
  const EscalaDetailsScreen({
    super.key,
    required this.escalaId,
    required this.userName,
  });

  @override
  State<EscalaDetailsScreen> createState() => _EscalaDetailsScreenState();
}

class _EscalaDetailsScreenState extends State<EscalaDetailsScreen> {
  // Dados simulados da escala baseados no ID
  late EscalaDetalhes _escalaDetalhes;
  
  @override
  void initState() {
    super.initState();
    _carregarDetalhesEscala();
  }
  
  void _carregarDetalhesEscala() {
    // Simulação de dados baseados no ID
    _escalaDetalhes = _obterDadosEscala(widget.escalaId);
  }
  
  EscalaDetalhes _obterDadosEscala(String id) {
    // Dados simulados baseados no ID
    switch (id) {
      case '1':
        return EscalaDetalhes(
          id: '1',
          rota: 'Centro - Antenor Viana',
          horarioInicio: '14:30',
          horarioFim: '18:30',
          veiculo: 'Ônibus 1234',
          motorista: 'João Silva',
          paradas: [
            'Terminal Central',
            'Praça da Matriz',
            'Shopping Center',
            'Antenor Viana'
          ],
          distanciaTotal: '25 km',
          tempoEstimado: '4 horas',
          status: 'Agendado',
          observacoes: 'Rota com maior movimento no horário de pico.',
        );
      case '2':
        return EscalaDetalhes(
          id: '2',
          rota: 'Terminal - Bela Vista',
          horarioInicio: '06:00',
          horarioFim: '10:00',
          veiculo: 'Ônibus 5678',
          motorista: 'Maria Santos',
          paradas: [
            'Terminal Rodoviário',
            'Centro da Cidade',
            'Escola Municipal',
            'Hospital Regional',
            'Vila Nova',
            'Bela Vista'
          ],
          distanciaTotal: '32 km',
          tempoEstimado: '4 horas',
          status: 'Concluído',
          observacoes: 'Rota matinal com estudantes e trabalhadores.',
        );
      default:
        return EscalaDetalhes(
          id: id,
          rota: 'Rota Exemplo',
          horarioInicio: '08:00',
          horarioFim: '12:00',
          veiculo: 'Ônibus 0000',
          motorista: 'Motorista Exemplo',
          paradas: ['Parada 1', 'Parada 2'],
          distanciaTotal: '20 km',
          tempoEstimado: '4 horas',
          status: 'Agendado',
          observacoes: 'Dados de exemplo para escala não encontrada.',
        );
    }
  }
  
  void _iniciarEscala() {
    // Navegar para a tela de escala em andamento
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EscalaAndamentoScreen(
          escalaId: widget.escalaId,
          userName: widget.userName,
        ),
      ),
    );
  }
  
  void _confirmarInicioEscala() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.play_arrow, color: AppColors.primaryDarkBlue),
              SizedBox(width: 8),
              Text('Iniciar Escala'),
            ],
          ),
          content: Text(
            'Deseja iniciar a escala ${_escalaDetalhes.rota}?\n\n'
            'Horário: ${_escalaDetalhes.horarioInicio} - ${_escalaDetalhes.horarioFim}\n'
            'Veículo: ${_escalaDetalhes.veiculo}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _iniciarEscala();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDarkBlue,
                foregroundColor: AppColors.textOnDark,
              ),
              child: const Text('Iniciar'),
            ),
          ],
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardBackground,
      appBar: AppBar(
        title: const Text(
          'Detalhes da Escala',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textOnDark,
          ),
        ),
        backgroundColor: AppColors.primaryDarkBlue,
        foregroundColor: AppColors.textOnDark,
        elevation: 2,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: context.maxContainerWidth,
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(context.horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card principal com informações da escala
                  _buildMainInfoCard(),
                  
                  SizedBox(height: context.verticalSpacing * 1.5),
                  
                  // Lista de paradas
                  _buildParadasSection(),
                  
                  SizedBox(height: context.verticalSpacing * 1.5),
                  
                  // Informações adicionais
                  _buildAdditionalInfo(),
                  
                  SizedBox(height: context.verticalSpacing * 2),
                  
                  // Botões de ação
                  _buildActionButtons(),
                  
                  SizedBox(height: context.verticalSpacing),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildMainInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: context.responsiveBorderRadius,
      ),
      child: Padding(
        padding: EdgeInsets.all(context.horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título da rota
            Row(
              children: [
                Icon(
                  Icons.route,
                  color: AppColors.primaryDarkBlue,
                  size: context.isTablet ? 28 : 24,
                ),
                SizedBox(width: context.horizontalPadding * 0.5),
                Expanded(
                  child: Text(
                    _escalaDetalhes.rota,
                    style: TextStyle(
                      fontSize: context.fontSize(context.isTablet ? 20 : 18),
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDarkBlue,
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: context.verticalSpacing),
            
            // Informações básicas
            _buildInfoRow(Icons.access_time, 'Horário', 
                '${_escalaDetalhes.horarioInicio} - ${_escalaDetalhes.horarioFim}'),
            _buildInfoRow(Icons.directions_bus, 'Veículo', _escalaDetalhes.veiculo),
            _buildInfoRow(Icons.person, 'Motorista', _escalaDetalhes.motorista),
            _buildInfoRow(Icons.straighten, 'Distância', _escalaDetalhes.distanciaTotal),
            _buildInfoRow(Icons.timer, 'Tempo Estimado', _escalaDetalhes.tempoEstimado),
            _buildInfoRow(Icons.info_outline, 'Status', _escalaDetalhes.status, 
                statusColor: _getStatusColor(_escalaDetalhes.status)),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoRow(IconData icon, String label, String value, {Color? statusColor}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.verticalSpacing * 0.4),
      child: Row(
        children: [
          Icon(
            icon,
            size: context.isTablet ? 20 : 18,
            color: AppColors.surfaceDark,
          ),
          SizedBox(width: context.horizontalPadding * 0.5),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: context.fontSize(context.isTablet ? 14 : 13),
                color: AppColors.surfaceDark,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: context.fontSize(context.isTablet ? 14 : 13),
                color: statusColor ?? AppColors.textPrimary,
                fontWeight: statusColor != null ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildParadasSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Paradas da Rota',
          style: TextStyle(
            fontSize: context.fontSize(context.isTablet ? 18 : 16),
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDarkBlue,
          ),
        ),
        
        SizedBox(height: context.verticalSpacing),
        
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: context.responsiveBorderRadius,
          ),
          child: ExpansionTile(
            leading: Icon(
              Icons.location_on,
              color: AppColors.primaryDarkBlue,
              size: context.isTablet ? 24 : 20,
            ),
            title: Text(
              'Ver ${_escalaDetalhes.paradas.length} paradas',
              style: TextStyle(
                fontSize: context.fontSize(context.isTablet ? 16 : 14),
                fontWeight: FontWeight.w600,
                color: AppColors.primaryDarkBlue,
              ),
            ),
            subtitle: Text(
              '${_escalaDetalhes.paradas.first} → ${_escalaDetalhes.paradas.last}',
              style: TextStyle(
                fontSize: context.fontSize(context.isTablet ? 13 : 12),
                color: AppColors.textSecondary,
              ),
            ),
            iconColor: AppColors.primaryDarkBlue,
            collapsedIconColor: AppColors.primaryDarkBlue,
            children: [
              const Divider(height: 1),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: _escalaDetalhes.paradas.length,
                separatorBuilder: (context, index) => const Divider(height: 1, indent: 60),
                itemBuilder: (context, index) {
                  final parada = _escalaDetalhes.paradas[index];
                  final isFirst = index == 0;
                  final isLast = index == _escalaDetalhes.paradas.length - 1;
                  
                  return ListTile(
                    dense: context.isMobile,
                    leading: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isFirst ? AppColors.success : 
                               isLast ? AppColors.error : 
                               AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: AppColors.textOnDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      parada,
                      style: TextStyle(
                        fontSize: context.fontSize(context.isTablet ? 14 : 13),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      isFirst ? 'Ponto de partida' : 
                      isLast ? 'Destino final' : 'Parada intermediária',
                      style: TextStyle(
                        fontSize: context.fontSize(10),
                        color: AppColors.textSecondary,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildAdditionalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Observações',
          style: TextStyle(
            fontSize: context.fontSize(context.isTablet ? 18 : 16),
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDarkBlue,
          ),
        ),
        
        SizedBox(height: context.verticalSpacing),
        
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: context.responsiveBorderRadius,
          ),
          child: Padding(
            padding: EdgeInsets.all(context.horizontalPadding),
            child: Row(
              children: [
                Icon(
                  Icons.note_alt_outlined,
                  color: AppColors.surfaceDark,
                  size: context.isTablet ? 24 : 20,
                ),
                SizedBox(width: context.horizontalPadding * 0.5),
                Expanded(
                  child: Text(
                    _escalaDetalhes.observacoes,
                    style: TextStyle(
                      fontSize: context.fontSize(context.isTablet ? 14 : 13),
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildActionButtons() {
    final isEscalaIniciavel = _escalaDetalhes.status == 'Agendado';
    
    return Column(
      children: [
        if (isEscalaIniciavel) ...[
          // Botão principal para iniciar escala
          SizedBox(
            width: double.infinity,
            height: context.isTablet ? 56 : 50,
            child: ElevatedButton.icon(
              onPressed: _confirmarInicioEscala,
              icon: const Icon(Icons.play_arrow, size: 24),
              label: Text(
                'Iniciar Escala',
                style: TextStyle(
                  fontSize: context.fontSize(context.isTablet ? 18 : 16),
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDarkBlue,
                foregroundColor: AppColors.textOnDark,
                shape: RoundedRectangleBorder(
                  borderRadius: context.responsiveBorderRadius,
                ),
                elevation: 4,
              ),
            ),
          ),
          
          SizedBox(height: context.verticalSpacing),
        ],
        
        // Botão para voltar
        SizedBox(
          width: double.infinity,
          height: context.isTablet ? 50 : 44,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Voltar às Escalas'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryDarkBlue,
              side: BorderSide(color: AppColors.primaryDarkBlue),
              shape: RoundedRectangleBorder(
                borderRadius: context.responsiveBorderRadius,
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'agendado':
        return AppColors.escalaAgendada;
      case 'em andamento':
        return AppColors.escalaAndamento;
      case 'concluído':
        return AppColors.escalaConcluida;
      case 'cancelado':
        return AppColors.escalaCancelada;
      default:
        return AppColors.surfaceMedium;
    }
  }
}

/// Modelo de dados para detalhes da escala
class EscalaDetalhes {
  final String id;
  final String rota;
  final String horarioInicio;
  final String horarioFim;
  final String veiculo;
  final String motorista;
  final List<String> paradas;
  final String distanciaTotal;
  final String tempoEstimado;
  final String status;
  final String observacoes;
  
  const EscalaDetalhes({
    required this.id,
    required this.rota,
    required this.horarioInicio,
    required this.horarioFim,
    required this.veiculo,
    required this.motorista,
    required this.paradas,
    required this.distanciaTotal,
    required this.tempoEstimado,
    required this.status,
    required this.observacoes,
  });
}