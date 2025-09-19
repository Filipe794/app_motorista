// TODO: Implementar formulário de novo chamado
// TODO: Adicionar seleção de tipo/categoria
// TODO: Implementar upload de anexos
// TODO: Adicionar seleção de prioridade
// TODO: Implementar validação de campos
// TODO: Adicionar campo de descrição detalhada

import 'package:flutter/material.dart';

import 'package:rota_mais/utils/responsive_helper.dart';

class CriarChamadoScreen extends StatefulWidget {
  const CriarChamadoScreen({super.key});

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
      'descricao': 'Manutenções e consertos'
    },
    {
      'nome': 'Problemas na Rota',
      'icone': Icons.route,
      'cor': Colors.orange,
      'descricao': 'Desvios e bloqueios'
    },
    {
      'nome': 'Acidente',
      'icone': Icons.car_crash,
      'cor': Colors.red,
      'descricao': 'Colisões e incidentes'
    },
    {
      'nome': 'Climatização',
      'icone': Icons.ac_unit,
      'cor': Colors.lightBlue,
      'descricao': 'Ar condicionado'
    },
    {
      'nome': 'Freios',
      'icone': Icons.do_not_step,
      'cor': Colors.purple,
      'descricao': 'Sistema de frenagem'
    },
  ];
  
  @override
  Widget build(BuildContext context) {
    // TODO: Implementar UI do formulário de chamado
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const BackButton(),
        title: const Text(
          'Criar Chamado',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[100],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Selecione a categoria do chamado:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.1,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: categorias.length,
                itemBuilder: (context, index) {
                  final categoria = categorias[index];
                  final isSelected = categoria['nome'] == categoriaSelecionada;
                  
                  return InkWell(
                    onTap: () {
                      setState(() {
                        categoriaSelecionada = categoria['nome'];
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? categoria['cor'] : Colors.grey[300]!,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(13), // 0.05 * 255 = ~13
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            categoria['icone'],
                            size: 32,
                            color: categoria['cor'],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            categoria['nome'],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            categoria['descricao'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}