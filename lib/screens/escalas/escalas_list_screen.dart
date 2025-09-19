import 'package:flutter/material.dart';
import '../../utils/responsive_helper.dart';
import '../../widgets/next_shift_card.dart';
import 'escala_details_screen.dart';

class EscalasListScreen extends StatefulWidget {
  const EscalasListScreen({super.key});

  @override
  State<EscalasListScreen> createState() => _EscalasListScreenState();
}

class _EscalasListScreenState extends State<EscalasListScreen> {
  // Lista de escalas simuladas
  late List<EscalaInfo> _escalas;
  
  @override
  void initState() {
    super.initState();
    _initializeEscalas();
  }
  
  void _initializeEscalas() {
    _escalas = [
      EscalaInfo(
        id: '1',
        rota: 'Centro - Antenor Viana',
        horario: '14:30 - 18:30',
        veiculo: 'Ônibus 1234',
        paradas: 4,
        status: EscalaStatus.agendado,
        isDestaque: true,
      ),
      EscalaInfo(
        id: '2',
        rota: 'Terminal - Bela Vista',
        horario: '06:00 - 10:00',
        veiculo: 'Ônibus 5678',
        paradas: 6,
        status: EscalaStatus.concluido,
      ),
      EscalaInfo(
        id: '3',
        rota: 'Shopping - Cohab',
        horario: '19:00 - 23:00',
        veiculo: 'Ônibus 9101',
        paradas: 8,
        status: EscalaStatus.agendado,
      ),
      EscalaInfo(
        id: '4',
        rota: 'Rodoviária - Vila Nova',
        horario: '11:00 - 15:00',
        veiculo: 'Ônibus 1121',
        paradas: 5,
        status: EscalaStatus.emAndamento,
      ),
      EscalaInfo(
        id: '5',
        rota: 'Centro - Parque Industrial',
        horario: '07:30 - 11:30',
        veiculo: 'Ônibus 3141',
        paradas: 7,
        status: EscalaStatus.agendado,
      ),
    ];
  }
  
  void _navigateToDetails(String escalaId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EscalaDetailsScreen(escalaId: escalaId),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final escalaDestaque = _escalas.firstWhere((e) => e.isDestaque);
    final outrasEscalas = _escalas.where((e) => !e.isDestaque).toList();
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Escalas',
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
                  // Título da seção de destaque
                  Text(
                    'Próxima Escala',
                    style: TextStyle(
                      fontSize: context.fontSize(context.isTablet ? 18 : 16),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E3A8A),
                    ),
                  ),
                  
                  SizedBox(height: context.verticalSpacing),
                  
                  // Escala em destaque (reutiliza NextShiftCard)
                  NextShiftCard(
                    onShiftTap: () => _navigateToDetails(escalaDestaque.id),
                  ),
                  
                  SizedBox(height: context.verticalSpacing * 2),
                  
                  // Título da lista de outras escalas
                  Text(
                    'Outras Escalas',
                    style: TextStyle(
                      fontSize: context.fontSize(context.isTablet ? 18 : 16),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E3A8A),
                    ),
                  ),
                  
                  SizedBox(height: context.verticalSpacing),
                  
                  // Lista de outras escalas
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: outrasEscalas.length,
                    separatorBuilder: (context, index) => 
                        SizedBox(height: context.verticalSpacing),
                    itemBuilder: (context, index) {
                      final escala = outrasEscalas[index];
                      return _EscalaListItem(
                        escala: escala,
                        onTap: () => _navigateToDetails(escala.id),
                      );
                    },
                  ),
                  
                  // Espaçamento final para scroll confortável
                  SizedBox(height: context.verticalSpacing * 2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget para item individual da lista de escalas
class _EscalaListItem extends StatelessWidget {
  final EscalaInfo escala;
  final VoidCallback onTap;
  
  const _EscalaListItem({
    required this.escala,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Escala ${escala.rota} das ${escala.horario}',
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: context.responsiveBorderRadius,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(context.horizontalPadding * 0.8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: context.responsiveBorderRadius,
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Ícone da escala
                Container(
                  width: context.isTablet ? 50 : 40,
                  height: context.isTablet ? 50 : 40,
                  decoration: BoxDecoration(
                    color: _getStatusColor(escala.status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.schedule,
                    color: _getStatusColor(escala.status),
                    size: context.isTablet ? 28 : 24,
                  ),
                ),
                
                SizedBox(width: context.horizontalPadding * 0.8),
                
                // Informações da escala
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Rota
                      Text(
                        escala.rota,
                        style: TextStyle(
                          fontSize: context.fontSize(context.isTablet ? 16 : 14),
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      SizedBox(height: context.verticalSpacing * 0.3),
                      
                      // Horário e veículo
                      Text(
                        '${escala.horario} • ${escala.veiculo}',
                        style: TextStyle(
                          fontSize: context.fontSize(context.isTablet ? 14 : 12),
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      SizedBox(height: context.verticalSpacing * 0.3),
                      
                      // Paradas e status
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: context.isTablet ? 16 : 14,
                            color: Colors.grey[500],
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${escala.paradas} paradas',
                            style: TextStyle(
                              fontSize: context.fontSize(context.isTablet ? 12 : 11),
                              color: Colors.grey[500],
                            ),
                          ),
                          SizedBox(width: context.horizontalPadding * 0.5),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(escala.status).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _getStatusText(escala.status),
                              style: TextStyle(
                                fontSize: context.fontSize(context.isTablet ? 11 : 10),
                                fontWeight: FontWeight.w500,
                                color: _getStatusColor(escala.status),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Seta indicativa
                Icon(
                  Icons.arrow_forward_ios,
                  size: context.isTablet ? 18 : 16,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Color _getStatusColor(EscalaStatus status) {
    switch (status) {
      case EscalaStatus.agendado:
        return const Color(0xFF2196F3);
      case EscalaStatus.emAndamento:
        return const Color(0xFF4CAF50);
      case EscalaStatus.concluido:
        return const Color(0xFF9E9E9E);
      case EscalaStatus.cancelado:
        return const Color(0xFFF44336);
    }
  }
  
  String _getStatusText(EscalaStatus status) {
    switch (status) {
      case EscalaStatus.agendado:
        return 'Agendado';
      case EscalaStatus.emAndamento:
        return 'Em andamento';
      case EscalaStatus.concluido:
        return 'Concluído';
      case EscalaStatus.cancelado:
        return 'Cancelado';
    }
  }
}

/// Enum para status da escala
enum EscalaStatus {
  agendado,
  emAndamento,
  concluido,
  cancelado,
}

/// Modelo de dados para informações da escala
class EscalaInfo {
  final String id;
  final String rota;
  final String horario;
  final String veiculo;
  final int paradas;
  final EscalaStatus status;
  final bool isDestaque;
  
  const EscalaInfo({
    required this.id,
    required this.rota,
    required this.horario,
    required this.veiculo,
    required this.paradas,
    required this.status,
    this.isDestaque = false,
  });
}