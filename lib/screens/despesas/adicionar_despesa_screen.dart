import 'package:flutter/material.dart';
import 'package:rota_mais/screens/despesas/descricao_despesa.dart';
import 'package:rota_mais/utils/responsive_helper.dart';
import 'package:rota_mais/screens/login_screen.dart';

// TODO: Implementar formulário de nova despesa
// TODO: Adicionar seleção de categoria
// TODO: Implementar upload de comprovante/anexo
// TODO: Adicionar campo de valor
// TODO: Implementar validação de campos
// TODO: Adicionar campo de descrição detalhada

class CriarDespesaScreen extends StatefulWidget {
  final String userName;

  const CriarDespesaScreen({super.key, required this.userName});

  @override
  State<CriarDespesaScreen> createState() => _CriarDespesaScreenState();
}

class _CriarDespesaScreenState extends State<CriarDespesaScreen> {
  String? categoriaSelecionada;

  final List<Map<String, dynamic>> categorias = [
    {
      'nome': 'Alimentação',
      'icone': Icons.restaurant,
      'cor': Colors.orange,
      'descricao': 'Refeições, mercado, delivery',
    },
    {
      'nome': 'Transporte',
      'icone': Icons.local_gas_station,
      'cor': Colors.blue,
      'descricao': 'Combustível, transporte público',
    },
    {
      'nome': 'Contas',
      'icone': Icons.receipt_long,
      'cor': Colors.red,
      'descricao': 'Água, luz, internet, telefone',
    },
    {
      'nome': 'Saúde',
      'icone': Icons.local_hospital,
      'cor': Colors.green,
      'descricao': 'Consultas, medicamentos, academia',
    },
    {
      'nome': 'Lazer',
      'icone': Icons.movie,
      'cor': Colors.purple,
      'descricao': 'Cinema, viagens, hobbies',
    },
    {
      'nome': 'Serviços',
      'icone': Icons.miscellaneous_services,
      'cor': Colors.teal,
      'descricao': 'Lavagem, manutenção, outros',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A),
        leading: const BackButton(
          color: Colors.white,
        ),
        title: const Text(
          'Criar Despesa',
          style: TextStyle(
            color: Colors.white,
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
            // Título
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Selecione a categoria da despesa:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
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
                            color: isSelected ? const Color(0xFF1E3A8A) : Colors.grey.withAlpha(51),
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
                            // Ícone com fundo colorido
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: categoria['cor'].withAlpha(26),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                categoria['icone'],
                                color: categoria['cor'],
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Nome + descrição
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

                            // Check de seleção
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

            // Botão próximo (vai para tela de detalhes da despesa)
            if (categoriaSelecionada != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Navegar para tela de descrição/valor da despesa
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => DescricaoDespesaScreen()));
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DescricaoDespesas(userName: widget.userName,),
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
