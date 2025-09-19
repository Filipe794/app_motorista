// TODO: Implementar detalhes da escala selecionada
// TODO: Adicionar mapa interativo da rota
// TODO: Implementar confirmação de presença
// TODO: Adicionar lista de paradas
// TODO: Implementar compartilhamento da escala
// TODO: Adicionar botão de emergência

import 'package:flutter/material.dart';
import '../../utils/responsive_helper.dart';
import 'escala_andamento_screen.dart';

class EscalaDetailsScreen extends StatefulWidget {
  final String escalaId;
  
  const EscalaDetailsScreen({
    super.key,
    required this.escalaId,
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
        builder: (context) => EscalaAndamentoScreen(escalaId: widget.escalaId),
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
              Icon(Icons.play_arrow, color: Color(0xFF4CAF50)),
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
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Detalhes da Escala',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
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
                  color: const Color(0xFF1E3A8A),
                  size: context.isTablet ? 28 : 24,
                ),
                SizedBox(width: context.horizontalPadding * 0.5),
                Expanded(
                  child: Text(
                    _escalaDetalhes.rota,
                    style: TextStyle(
                      fontSize: context.fontSize(context.isTablet ? 20 : 18),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E3A8A),
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
            color: Colors.grey[600],
          ),
          SizedBox(width: context.horizontalPadding * 0.5),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: context.fontSize(context.isTablet ? 14 : 13),
                color: Colors.grey[600],
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
                color: statusColor ?? Colors.black87,
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
            color: const Color(0xFF1E3A8A),
          ),
        ),
        
        SizedBox(height: context.verticalSpacing),
        
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: context.responsiveBorderRadius,
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _escalaDetalhes.paradas.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final parada = _escalaDetalhes.paradas[index];
              final isFirst = index == 0;
              final isLast = index == _escalaDetalhes.paradas.length - 1;
              
              return ListTile(
                leading: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isFirst ? const Color(0xFF4CAF50) : 
                           isLast ? const Color(0xFFF44336) : 
                           const Color(0xFF2196F3),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  parada,
                  style: TextStyle(
                    fontSize: context.fontSize(context.isTablet ? 15 : 14),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  isFirst ? 'Ponto de partida' : 
                  isLast ? 'Destino final' : 'Parada intermediária',
                  style: TextStyle(
                    fontSize: context.fontSize(12),
                    color: Colors.grey[600],
                  ),
                ),
              );
            },
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
            color: const Color(0xFF1E3A8A),
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
                  color: Colors.grey[600],
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
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
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
              foregroundColor: const Color(0xFF1E3A8A),
              side: const BorderSide(color: Color(0xFF1E3A8A)),
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
        return const Color(0xFF2196F3);
      case 'em andamento':
        return const Color(0xFF4CAF50);
      case 'concluído':
        return const Color(0xFF9E9E9E);
      case 'cancelado':
        return const Color(0xFFF44336);
      default:
        return Colors.grey;
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