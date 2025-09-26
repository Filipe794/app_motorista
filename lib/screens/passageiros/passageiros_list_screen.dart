import 'package:flutter/material.dart';
import '../../utils/responsive_helper.dart';
import '../../utils/app_colors.dart';
import '../../models/passageiro.dart';

class PassageirosListScreen extends StatefulWidget {
  final String escalaId;
  
  const PassageirosListScreen({
    super.key,
    required this.escalaId,
  });

  @override
  State<PassageirosListScreen> createState() => _PassageirosListScreenState();
}

class _PassageirosListScreenState extends State<PassageirosListScreen> {
  // Lista placeholder de passageiros
  final List<Passageiro> _passageiros = [
    Passageiro(
      id: '1',
      nome: 'Ana Silva Santos',
      matricula: '202301001',
      escola: 'E.M. José de Alencar',
      parada: 'Parada Central',
      status: StatusPassageiro.embarcado,
      telefoneResponsavel: '(85) 99999-0001',
      observacoes: 'Precisa de ajuda para embarcar',
    ),
    Passageiro(
      id: '2',
      nome: 'Carlos Eduardo Lima',
      matricula: '202301002',
      escola: 'E.M. José de Alencar',
      parada: 'Parada do Mercado',
      status: StatusPassageiro.embarcado,
      telefoneResponsavel: '(85) 99999-0002',
    ),
    Passageiro(
      id: '3',
      nome: 'Beatriz Costa Oliveira',
      matricula: '202301003',
      escola: 'E.E. Maria Conceição',
      parada: 'Parada Central',
      status: StatusPassageiro.embarcado,
      telefoneResponsavel: '(85) 99999-0003',
    ),
    Passageiro(
      id: '4',
      nome: 'Diego Fernandes',
      matricula: '202301004',
      escola: 'E.M. José de Alencar',
      parada: 'Parada da Igreja',
      status: StatusPassageiro.aguardando,
      telefoneResponsavel: '(85) 99999-0004',
      observacoes: 'Costuma atrasar 5 minutos',
    ),
    Passageiro(
      id: '5',
      nome: 'Eduarda Mendes Silva',
      matricula: '202301005',
      escola: 'E.E. Maria Conceição',
      parada: 'Parada do Posto',
      status: StatusPassageiro.aguardando,
      telefoneResponsavel: '(85) 99999-0005',
    ),
    Passageiro(
      id: '6',
      nome: 'Felipe Santos Rocha',
      matricula: '202301006',
      escola: 'E.M. José de Alencar',
      parada: 'Parada Central',
      status: StatusPassageiro.faltou,
      telefoneResponsavel: '(85) 99999-0006',
    ),
    Passageiro(
      id: '7',
      nome: 'Gabriela Alves',
      matricula: '202301007',
      escola: 'E.E. Maria Conceição',
      parada: 'Parada do Mercado',
      status: StatusPassageiro.embarcado,
      telefoneResponsavel: '(85) 99999-0007',
    ),
    Passageiro(
      id: '8',
      nome: 'Hugo Pereira Costa',
      matricula: '202301008',
      escola: 'E.M. José de Alencar',
      parada: 'Parada da Igreja',
      status: StatusPassageiro.embarcado,
      telefoneResponsavel: '(85) 99999-0008',
      observacoes: 'Tem problema de mobilidade',
    ),
    Passageiro(
      id: '9',
      nome: 'Isabela Rodrigues',
      matricula: '202301009',
      escola: 'E.E. Maria Conceição',
      parada: 'Parada do Posto',
      status: StatusPassageiro.aguardando,
      telefoneResponsavel: '(85) 99999-0009',
    ),
    Passageiro(
      id: '10',
      nome: 'João Pedro Araújo',
      matricula: '202301010',
      escola: 'E.M. José de Alencar',
      parada: 'Parada Central',
      status: StatusPassageiro.embarcado,
      telefoneResponsavel: '(85) 99999-0010',
    ),
  ];

  String _filtroStatus = 'todos';
  final TextEditingController _searchController = TextEditingController();
  String _termoBusca = '';

  List<Passageiro> get _passageirosFiltrados {
    List<Passageiro> passageiros = _passageiros;
    
    // Filtrar por status
    if (_filtroStatus != 'todos') {
      StatusPassageiro status = StatusPassageiro.values.firstWhere(
        (s) => s.name == _filtroStatus,
      );
      passageiros = passageiros.where((p) => p.status == status).toList();
    }
    
    // Filtrar por termo de busca
    if (_termoBusca.isNotEmpty) {
      passageiros = passageiros.where((p) => 
        p.nome.toLowerCase().contains(_termoBusca.toLowerCase()) ||
        p.matricula.contains(_termoBusca) ||
        p.escola.toLowerCase().contains(_termoBusca.toLowerCase())
      ).toList();
    }
    
    return passageiros;
  }

  int get _totalEmbarcados => _passageiros.where((p) => p.status == StatusPassageiro.embarcado).length;
  int get _totalAguardando => _passageiros.where((p) => p.status == StatusPassageiro.aguardando).length;
  int get _totalFaltaram => _passageiros.where((p) => p.status == StatusPassageiro.faltou).length;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text(
          'Lista de Passageiros',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textOnDark,
          ),
        ),
        backgroundColor: AppColors.primaryDarkBlue,
        foregroundColor: AppColors.textOnDark,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textOnDark),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: context.maxContainerWidth,
            ),
            child: Column(
              children: [
                // Header com estatísticas
                _buildStatsHeader(),
                
                // Barra de busca e filtros
                _buildSearchAndFilters(),
                
                // Lista de passageiros
                Expanded(
                  child: _buildPassageirosList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsHeader() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(context.horizontalPadding),
      padding: EdgeInsets.all(context.horizontalPadding),
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
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              icon: Icons.people,
              label: 'Embarcados',
              value: _totalEmbarcados.toString(),
              color: AppColors.success,
            ),
          ),
          
          Container(
            width: 1,
            height: 40,
            color: AppColors.surfaceLight,
            margin: EdgeInsets.symmetric(horizontal: context.cardSpacing),
          ),
          
          Expanded(
            child: _buildStatItem(
              icon: Icons.schedule,
              label: 'Aguardando',
              value: _totalAguardando.toString(),
              color: AppColors.warning,
            ),
          ),
          
          Container(
            width: 1,
            height: 40,
            color: AppColors.surfaceLight,
            margin: EdgeInsets.symmetric(horizontal: context.cardSpacing),
          ),
          
          Expanded(
            child: _buildStatItem(
              icon: Icons.person_off,
              label: 'Faltaram',
              value: _totalFaltaram.toString(),
              color: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: context.isTablet ? 24 : 20,
        ),
        SizedBox(height: context.verticalSpacing * 0.3),
        Text(
          value,
          style: TextStyle(
            fontSize: context.fontSize(context.isTablet ? 18 : 16),
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: context.fontSize(10),
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilters() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.horizontalPadding),
      child: Column(
        children: [
          // Barra de busca
          TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _termoBusca = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Buscar por nome, matrícula ou escola...',
              prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
              suffixIcon: _termoBusca.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _termoBusca = '';
                        });
                      },
                    )
                  : null,
              filled: true,
              fillColor: AppColors.cardBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.surfaceLight),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.surfaceLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primaryLight),
              ),
            ),
          ),
          
          SizedBox(height: context.verticalSpacing),
          
          // Filtros de status
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('Todos', 'todos'),
                SizedBox(width: context.cardSpacing),
                _buildFilterChip('Embarcados', 'embarcado'),
                SizedBox(width: context.cardSpacing),
                _buildFilterChip('Aguardando', 'aguardando'),
                SizedBox(width: context.cardSpacing),
                _buildFilterChip('Faltaram', 'faltou'),
              ],
            ),
          ),
          
          SizedBox(height: context.verticalSpacing),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _filtroStatus == value;
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _filtroStatus = value;
        });
      },
      selectedColor: AppColors.primaryLight.withValues(alpha: 0.2),
      checkmarkColor: AppColors.primaryLight,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primaryLight : AppColors.textSecondary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? AppColors.primaryLight : AppColors.surfaceLight,
      ),
    );
  }

  Widget _buildPassageirosList() {
    final passageiros = _passageirosFiltrados;
    
    if (passageiros.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: context.verticalSpacing),
            Text(
              'Nenhum passageiro encontrado',
              style: TextStyle(
                fontSize: context.fontSize(16),
                color: AppColors.textSecondary,
              ),
            ),
            if (_termoBusca.isNotEmpty || _filtroStatus != 'todos')
              TextButton(
                onPressed: () {
                  setState(() {
                    _termoBusca = '';
                    _filtroStatus = 'todos';
                    _searchController.clear();
                  });
                },
                child: const Text('Limpar filtros'),
              ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: EdgeInsets.all(context.horizontalPadding),
      itemCount: passageiros.length,
      itemBuilder: (context, index) {
        final passageiro = passageiros[index];
        return _buildPassageiroCard(passageiro);
      },
    );
  }

  Widget _buildPassageiroCard(Passageiro passageiro) {
    return Container(
      margin: EdgeInsets.only(bottom: context.verticalSpacing),
      child: Card(
        color: AppColors.cardBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: AppColors.surfaceLight,
            width: 1,
          ),
        ),
        child: InkWell(
          onTap: () => _showPassageiroDetails(passageiro),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(context.horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header do card
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        passageiro.nome,
                        style: TextStyle(
                          fontSize: context.fontSize(context.isTablet ? 16 : 14),
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    _buildStatusChip(passageiro.status),
                  ],
                ),
                
                SizedBox(height: context.verticalSpacing * 0.5),
                
                // Informações do passageiro
                Row(
                  children: [
                    Icon(
                      Icons.badge,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: context.cardSpacing * 0.5),
                    Text(
                      'Matrícula: ${passageiro.matricula}',
                      style: TextStyle(
                        fontSize: context.fontSize(12),
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: context.verticalSpacing * 0.3),
                
                Row(
                  children: [
                    Icon(
                      Icons.school,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: context.cardSpacing * 0.5),
                    Expanded(
                      child: Text(
                        passageiro.escola,
                        style: TextStyle(
                          fontSize: context.fontSize(12),
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: context.verticalSpacing * 0.3),
                
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: context.cardSpacing * 0.5),
                    Expanded(
                      child: Text(
                        passageiro.parada,
                        style: TextStyle(
                          fontSize: context.fontSize(12),
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                
                // Observações (se houver)
                if (passageiro.observacoes != null && passageiro.observacoes!.isNotEmpty) ...[
                  SizedBox(height: context.verticalSpacing * 0.5),
                  Container(
                    padding: EdgeInsets.all(context.cardSpacing),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.warning.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: AppColors.warning,
                        ),
                        SizedBox(width: context.cardSpacing * 0.5),
                        Expanded(
                          child: Text(
                            passageiro.observacoes!,
                            style: TextStyle(
                              fontSize: context.fontSize(11),
                              color: AppColors.warning,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(StatusPassageiro status) {
    Color color;
    String label;
    IconData icon;
    
    switch (status) {
      case StatusPassageiro.embarcado:
        color = AppColors.success;
        label = 'Embarcado';
        icon = Icons.check_circle;
        break;
      case StatusPassageiro.aguardando:
        color = AppColors.warning;
        label = 'Aguardando';
        icon = Icons.schedule;
        break;
      case StatusPassageiro.faltou:
        color = AppColors.error;
        label = 'Faltou';
        icon = Icons.cancel;
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: context.fontSize(10),
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showPassageiroDetails(Passageiro passageiro) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle do modal
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.only(bottom: context.verticalSpacing),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMedium,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              
              // Nome e status
              Row(
                children: [
                  Expanded(
                    child: Text(
                      passageiro.nome,
                      style: TextStyle(
                        fontSize: context.fontSize(context.isTablet ? 20 : 18),
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  _buildStatusChip(passageiro.status),
                ],
              ),
              
              SizedBox(height: context.verticalSpacing),
              
              // Informações detalhadas
              _buildDetailRow(Icons.badge, 'Matrícula', passageiro.matricula),
              _buildDetailRow(Icons.school, 'Escola', passageiro.escola),
              _buildDetailRow(Icons.location_on, 'Parada', passageiro.parada),
              _buildDetailRow(Icons.phone, 'Responsável', passageiro.telefoneResponsavel),
              
              if (passageiro.observacoes != null && passageiro.observacoes!.isNotEmpty) ...[
                SizedBox(height: context.verticalSpacing * 0.5),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(context.cardSpacing),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.warning.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 16,
                            color: AppColors.warning,
                          ),
                          SizedBox(width: context.cardSpacing * 0.5),
                          Text(
                            'Observações:',
                            style: TextStyle(
                              fontSize: context.fontSize(12),
                              fontWeight: FontWeight.w600,
                              color: AppColors.warning,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: context.verticalSpacing * 0.3),
                      Text(
                        passageiro.observacoes!,
                        style: TextStyle(
                          fontSize: context.fontSize(12),
                          color: AppColors.warning,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              
              SizedBox(height: context.verticalSpacing * 1.5),
              
              // Botões de ação
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        // TODO: Implementar ligação para o responsável
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Função de ligação em desenvolvimento')),
                        );
                      },
                      icon: const Icon(Icons.phone),
                      label: const Text('Ligar'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryLight,
                        side: BorderSide(color: AppColors.primaryLight),
                        padding: EdgeInsets.symmetric(vertical: context.verticalSpacing * 0.8),
                      ),
                    ),
                  ),
                  
                  SizedBox(width: context.cardSpacing),
                  
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _alterarStatusPassageiro(passageiro);
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Alterar Status'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryLight,
                        foregroundColor: AppColors.textOnDark,
                        padding: EdgeInsets.symmetric(vertical: context.verticalSpacing * 0.8),
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: context.verticalSpacing),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.verticalSpacing * 0.5),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: AppColors.textSecondary,
          ),
          SizedBox(width: context.cardSpacing),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: context.fontSize(14),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: context.fontSize(14),
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _alterarStatusPassageiro(Passageiro passageiro) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Alterar Status - ${passageiro.nome}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: StatusPassageiro.values.map((status) {
            return RadioListTile<StatusPassageiro>(
              title: Text(_getStatusLabel(status)),
              value: status,
              groupValue: passageiro.status,
              onChanged: (value) {
                setState(() {
                  final index = _passageiros.indexWhere((p) => p.id == passageiro.id);
                  if (index != -1) {
                    _passageiros[index] = _passageiros[index].copyWith(status: value);
                  }
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Status alterado para ${_getStatusLabel(value!)}'),
                  ),
                );
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  String _getStatusLabel(StatusPassageiro status) {
    switch (status) {
      case StatusPassageiro.embarcado:
        return 'Embarcado';
      case StatusPassageiro.aguardando:
        return 'Aguardando';
      case StatusPassageiro.faltou:
        return 'Faltou';
    }
  }
}