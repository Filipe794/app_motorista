import 'package:app_motorista/screens/chamados/criar_chamado_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_motorista/utils/responsive_helper.dart';

class ChamadosListScreen extends StatefulWidget {
  const ChamadosListScreen({super.key});

  @override
  State<ChamadosListScreen> createState() => _ChamadosListScreenState();
}

String? dataSelecionada;
String? categoriaSelecionada;

class _ChamadosListScreenState extends State<ChamadosListScreen> {
  // Lista de chamados
  final List<Map<String, dynamic>> chamados = [
    {
      "id": "0001",
      "titulo": "Pneu Furado",
      "data": "20/02/2025",
      "valor": 350.0,
      "categoria": "Reparos"
    },
    {
      "id": "0002",
      "titulo": "Reparo no Motor",
      "data": "18/02/2025",
      "valor": 1200.0,
      "categoria": "Reparos"
    },
    {
      "id": "0003",
      "titulo": "Troca de Óleo",
      "data": "19/02/2025",
      "valor": 150.0,
      "categoria": "Reparos"
    },
    {
      "id": "0004",
      "titulo": "Alinhamento e Balanceamento",
      "data": "17/02/2025",
      "valor": 250.0,
      "categoria": "Reparos"
    },
    {
      "id": "0005",
      "titulo": "Acidente na Rota",
      "data": "15/02/2025",
      "valor": 0.0,
      "categoria": "Problemas na Rota"
    },
    {
      "id": "0006",
      "titulo": "Bloqueio na Estrada",
      "data": "16/02/2025",
      "valor": 0.0,
      "categoria": "Problemas na Rota"
    },
    {
      "id": "0007",
      "titulo": "Reparo na Suspensão",
      "data": "14/02/2025",
      "valor": 900.0,
      "categoria": "Reparos"
    },
    {
      "id": "0008",
      "titulo": "Lavagem Completa",
      "data": "13/02/2025",
      "valor": 80.0,
      "categoria": "Reparos"
    },
    {
      "id": "0011",
      "titulo": "Lavagem Completa",
      "data": "13/02/2025",
      "valor": 80.0,
      "categoria": "Problemas na Rota"
    },
    {
      "id": "0009",
      "titulo": "Troca de Farol",
      "data": "12/02/2025",
      "valor": 180.0,
      "categoria": "Reparos"
    },
    {
      "id": "0010",
      "titulo": "Problema com GPS",
      "data": "11/02/2025",
      "valor": 0.0,
      "categoria": "Problemas na Rota"
    },
    {
      "id": "0012",
      "titulo": "Troca de Ar Condicionado",
      "data": "21/02/2025",
      "valor": 500.0,
      "categoria": "Climatização"
    },
    {
      "id": "0013",
      "titulo": "Substituição de Pastilhas de Freio",
      "data": "22/02/2025",
      "valor": 300.0,
      "categoria": "Freios"
    },
    {
      "id": "0014",
      "titulo": "Reparo no Sistema de Freios",
      "data": "23/02/2025",
      "valor": 400.0,
      "categoria": "Freios"
    },
  ];

  // Getters para dados e categorias
  List<String> get datas => chamados
      .map((c) => c["data"] as String)
      .toSet()
      .toList();

  List<String> get categorias => [
    "Reparos",
    "Problemas na Rota",
    "Acidente",
    "Climatização",
    "Freios",
  ];


  @override
  Widget build(BuildContext context) {
    // Filtra os chamados pela data e categoria selecionada
    final chamadosFiltrados = chamados.where((c) {
      final bool filtraData = dataSelecionada == null || c["data"] == dataSelecionada;
      final bool filtraCategoria = categoriaSelecionada == null || c["categoria"] == categoriaSelecionada;
      return filtraData && filtraCategoria;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const BackButton(),
        title: Text(
          'Chamados',
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

      //
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Espaçamento superior
            SizedBox(height: context.verticalSpacing),

            // Linha de filtros
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.horizontalPadding,
              ),
              child: Row(
                children: [
                  const SizedBox(width: 8),

                  // Dropdown de Categorias
                  SizedBox(
                    width: 90,
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: const Icon(
                        Icons.filter_alt_outlined,
                        color: Colors.black54,
                      ),
                      value: categoriaSelecionada,
                      items: categorias.map((cat) {
                        return DropdownMenuItem(
                          value: cat,
                          child: Text(cat),
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
                    child: Row(
                      children: [
                        const Icon(
                          Icons.refresh,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Resetar Filtro",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: context.fontSize(14),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: context.verticalSpacing),

            // Lista de chamados filtrados
            Expanded(
              child: ListView(
                children: chamadosFiltrados.map((chamado) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.withAlpha(51), // 0.2 * 255 = 51
                          width: 1,
                        ),
                      ),
                    ),
                    child: ListTile(
                      title: Text(chamado["titulo"]),
                      subtitle: Text(chamado["data"]),
                      trailing: Text(
                        "R\$ ${(chamado["valor"] ?? 0).toStringAsFixed(2)}",
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Botão de adicionar chamado
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CriarChamadoScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Adicionar chamado",
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
