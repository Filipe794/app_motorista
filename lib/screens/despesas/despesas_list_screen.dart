import 'package:flutter/material.dart';
import 'package:rota_mais/screens/despesas/adicionar_despesa_screen.dart';
import 'package:rota_mais/utils/responsive_helper.dart';
import '../../utils/responsive_helper.dart';
import '../../utils/app_colors.dart';

// Tela de lista de despesas
class DespesasListScreen extends StatefulWidget {
  final String userName;

  const DespesasListScreen({super.key, required this.userName});

  @override
  State<DespesasListScreen> createState() => _DespesasListScreenState();
}

String? dataSelecionada;
String? categoriaSelecionada;

class _DespesasListScreenState extends State<DespesasListScreen> {
  // Lista de despesas
  final List<Map<String, dynamic>> despesas = [
    {
      "id": "D001",
      "titulo": "Combustível",
      "data": "20/02/2025",
      "valor": 350.0,
      "categoria": "Transporte"
    },
    {
      "id": "D002",
      "titulo": "Almoço Restaurante",
      "data": "18/02/2025",
      "valor": 45.0,
      "categoria": "Alimentação"
    },
    {
      "id": "D003",
      "titulo": "Supermercado",
      "data": "19/02/2025",
      "valor": 280.0,
      "categoria": "Alimentação"
    },
    {
      "id": "D004",
      "titulo": "Conta de Luz",
      "data": "17/02/2025",
      "valor": 200.0,
      "categoria": "Contas"
    },
    {
      "id": "D005",
      "titulo": "Plano de Internet",
      "data": "15/02/2025",
      "valor": 120.0,
      "categoria": "Contas"
    },
    {
      "id": "D006",
      "titulo": "Lavagem do Carro",
      "data": "16/02/2025",
      "valor": 50.0,
      "categoria": "Serviços"
    },
    {
      "id": "D007",
      "titulo": "Academia",
      "data": "14/02/2025",
      "valor": 90.0,
      "categoria": "Saúde"
    },
    {
      "id": "D008",
      "titulo": "Consulta Médica",
      "data": "13/02/2025",
      "valor": 250.0,
      "categoria": "Saúde"
    },
    {
      "id": "D009",
      "titulo": "Cinema",
      "data": "12/02/2025",
      "valor": 40.0,
      "categoria": "Lazer"
    },
    {
      "id": "D010",
      "titulo": "Streaming",
      "data": "11/02/2025",
      "valor": 30.0,
      "categoria": "Lazer"
    },
  ];

  // Getters para dados e categorias
  List<String> get datas => despesas.map((d) => d["data"] as String).toSet().toList();

  List<String> get categorias => [
        "Transporte",
        "Alimentação",
        "Contas",
        "Serviços",
        "Saúde",
        "Lazer",
      ];

  @override
  Widget build(BuildContext context) {
    // Filtra as despesas pela data e categoria selecionada
    final despesasFiltradas = despesas.where((d) {
      final bool filtraData = dataSelecionada == null || d["data"] == dataSelecionada;
      final bool filtraCategoria = categoriaSelecionada == null || d["categoria"] == categoriaSelecionada;
      return filtraData && filtraCategoria;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A),
        leading: const BackButton(
          color: Colors.white,
        ),
        title: const Text(
          'Despesas',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textOnDark,
          ),
        ),
        backgroundColor: AppColors.primaryDarkBlue,
        foregroundColor: AppColors.textOnDark,
        elevation: 2,
        centerTitle: true,
        elevation: 0,
      ),

      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(height: context.verticalSpacing),

            // Linha de filtros
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.horizontalPadding),
              child: Row(
                children: [
                  const SizedBox(width: 8),

                  // Dropdown de Categorias
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.40,
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: const Icon(Icons.filter_alt_outlined, color: Colors.black54),
                      value: categoriaSelecionada,
                      items: categorias.map((cat) {
                        return DropdownMenuItem(
                          value: cat,
                          child: Text(
                            cat,
                            style: TextStyle(
                              fontSize: context.fontSize(16),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          categoriaSelecionada = value;
                        });
                      },
                    ),
                  ),

                  // Dropdown de Datas
                  Expanded(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: const Text("Data"),
                      value: dataSelecionada,
                      items: datas.map((data) {
                        return DropdownMenuItem(
                          value: data,
                          child: Text(data),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          dataSelecionada = value;
                        });
                      },
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Botão de resetar filtros
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        dataSelecionada = null;
                        categoriaSelecionada = null;
                      });
                    },
                    child: const Icon(Icons.refresh, color: Colors.red),
                  ),
                ],
              ),
            ),

            SizedBox(height: context.verticalSpacing),

            // Lista de despesas filtradas
            Expanded(
              child: ListView(
                children: despesasFiltradas.map((despesa) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.withAlpha(51),
                          width: 1,
                        ),
                      ),
                    ),
                    child: ListTile(
                      title: Text(despesa["titulo"]),
                      subtitle: Text(despesa["data"]),
                      trailing: Text(
                        "R\$ ${(despesa["valor"] ?? 0).toStringAsFixed(2)}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Botão de adicionar despesa
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A8A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                       Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CriarDespesaScreen(userName: widget.userName,),
                        ),
                      );



                    },
                    child: const Text(
                      "Adicionar despesa",
                      style: TextStyle(color: Colors.white, fontSize: 16),
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
