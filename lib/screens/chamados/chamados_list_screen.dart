import 'package:rota_mais/widgets/card_details.dart';
import 'package:flutter/material.dart';
import 'package:rota_mais/utils/responsive_helper.dart';

class ChamadosListScreen extends StatefulWidget {
  const ChamadosListScreen({super.key});

  @override
  State<ChamadosListScreen> createState() => _ChamadosListScreenState();
}

class _ChamadosListScreenState extends State<ChamadosListScreen> {
  final List<Map<String, dynamic>> chamados = [
    {
      "id": "0001",
      "titulo": "Pneu Furado",
      "data": "20/02/2025",
      "valor": 350.0,
    },
    {
      "id": "0002",
      "titulo": "Reparo no Motor",
      "data": "18/02/2025",
      "valor": 1200.0,
    },
    {
      "id": "0003",
      "titulo": "Troca de Óleo",
      "data": "19/02/2025",
      "valor": 150.0,
    },
    {
      "id": "0004",
      "titulo": "Alinhamento e Balanceamento",
      "data": "17/02/2025",
      "valor": 250.0,
    },
    {
      "id": "0005",
      "titulo": "Substituição de Pastilhas de Freio",
      "data": "15/02/2025",
      "valor": 400.0,
    },
    {
      "id": "0006",
      "titulo": "Troca de Bateria",
      "data": "16/02/2025",
      "valor": 600.0,
    },
    {
      "id": "0007",
      "titulo": "Reparo na Suspensão",
      "data": "14/02/2025",
      "valor": 900.0,
    },
    {
      "id": "0008",
      "titulo": "Lavagem Completa",
      "data": "13/02/2025",
      "valor": 80.0,
    },
    {
      "id": "0009",
      "titulo": "Troca de Farol",
      "data": "12/02/2025",
      "valor": 180.0,
    },
    {
      "id": "0010",
      "titulo": "Reparo no Ar Condicionado",
      "data": "11/02/2025",
      "valor": 550.0,
    },
  ];

  @override
  Widget build(BuildContext context) {
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
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(height: context.verticalSpacing),

            // 🔎 Linha de filtros (ícone, data, resetar filtro)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.horizontalPadding,
              ),
              child: Row(
                children: [
                  const Icon(Icons.filter_alt_outlined, color: Colors.black54),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Data",
                          style: TextStyle(fontSize: context.fontSize(14)),
                        ),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      // TODO: Resetar filtros
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.refresh, color: Colors.red),
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

            // Lista de chamados
            Expanded(
              child: ListView.separated(
                itemCount: chamados.length,
                separatorBuilder: (_, __) => Divider(
                  color: Colors.grey.shade300,
                  indent: 16,
                  endIndent: 16,
                ),
                itemBuilder: (context, index) {
                  final chamado = chamados[index]; // pega o mapa do item atual
                  return Chamado_DespesasCard(
                    id: chamado["id"],
                    titulo: chamado["titulo"],
                    data: chamado["data"],
                    valor: chamado["valor"],
                    onTap: () {
                      // TODO: Navegar para detalhes do chamado
                    },
                  );
                },
              ),
            ),

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
                      // TODO: Criar novo chamado
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