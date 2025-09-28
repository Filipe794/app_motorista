import 'package:flutter/material.dart';
import 'package:rota_mais/screens/chamados/descricao_chamado.dart';
import '../../utils/app_colors.dart';

class CriarChamadoScreen extends StatefulWidget {
  final String userName; // <-- recebe o nome do motorista

  const CriarChamadoScreen({super.key, required this.userName});

  @override
  State<CriarChamadoScreen> createState() => _CriarChamadoScreenState();
}

class _CriarChamadoScreenState extends State<CriarChamadoScreen> {
  String? categoriaSelecionada;

  final List<Map<String, dynamic>> categorias = [
    {
      'nome': 'Reparos',
      'icone': Icons.build,
      'cor': Colors.blue,
      'descricao': 'Manutenções e consertos',
    },
    {
      'nome': 'Problemas na Rota',
      'icone': Icons.route,
      'cor': Colors.orange,
      'descricao': 'Desvios e bloqueios',
    },
    {
      'nome': 'Acidente',
      'icone': Icons.car_crash,
      'cor': Colors.red,
      'descricao': 'Colisões e incidentes',
    },
    {
      'nome': 'Climatização',
      'icone': Icons.ac_unit,
      'cor': Colors.lightBlue,
      'descricao': 'Ar condicionado',
    },
    {
      'nome': 'Freios',
      'icone': Icons.do_not_step,
      'cor': Colors.purple,
      'descricao': 'Sistema de frenagem',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryDarkBlue,
        foregroundColor: AppColors.textOnDark,
        leading: BackButton(color: AppColors.textOnDark),
        title: Text(
          'Criar Chamado',
          style: TextStyle(
            color: AppColors.textOnDark,
            fontSize: 20,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Selecione a categoria do chamado:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),

            // Lista de categorias
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categorias.length,
                itemBuilder: (context, index) {
                  final categoria = categorias[index];
                  final isSelected = categoria['nome'] == categoriaSelecionada;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          categoriaSelecionada = categoria['nome'];
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF1E3A8A)
                                : Colors.grey.withAlpha(51),
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(13),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Ícone
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.withAlpha(26),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                categoria['icone'],
                                color: const Color(0xFF1E3A8A),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Textos
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    categoria['nome'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    categoria['descricao'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Ícone de seleção
                            if (isSelected)
                              const Icon(
                                Icons.check_circle,
                                color: Color(0xFF1E3A8A),
                                size: 24,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Botão Próximo
            if (categoriaSelecionada != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DescricaoChamados(userName: widget.userName), // ✅
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A8A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Próximo',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
