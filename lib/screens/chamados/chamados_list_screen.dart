import 'package:rota_mais/screens/chamados/criar_chamado_screen.dart';
import 'package:flutter/material.dart';
import '../../utils/responsive_helper.dart';
import '../../utils/app_colors.dart';

class ChamadosListScreen extends StatefulWidget {
  final String userName; // <-- adiciona aqui

  const ChamadosListScreen({super.key, required this.userName});

  @override
  State<ChamadosListScreen> createState() => _ChamadosListScreenState();
}

class _ChamadosListScreenState extends State<ChamadosListScreen> {
  String? dataSelecionada;
  String? categoriaSelecionada;

  // Lista de chamados (mock)
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
      "id": "0005",
      "titulo": "Acidente na Rota",
      "data": "15/02/2025",
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
  ];

  List<String> get datas => chamados.map((c) => c["data"] as String).toSet().toList();

  List<String> get categorias => [
        "Reparos",
        "Problemas na Rota",
        "Acidente",
        "Climatização",
        "Freios",
      ];

  @override
  Widget build(BuildContext context) {
    final chamadosFiltrados = chamados.where((c) {
      final bool filtraData =
          dataSelecionada == null || c["data"] == dataSelecionada;
      final bool filtraCategoria =
          categoriaSelecionada == null || c["categoria"] == categoriaSelecionada;
      return filtraData && filtraCategoria;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryDarkBlue,
        foregroundColor: AppColors.textOnDark,
        leading: const BackButton(color: AppColors.textOnDark),
        title: Text(
          'Chamados',
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
          children: [
            SizedBox(height: context.verticalSpacing),

            // Filtros
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.horizontalPadding),
              child: Row(
                children: [
                  const SizedBox(width: 8),

                  // Filtro Categoria
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
                        setState(() => categoriaSelecionada = value);
                      },
                    ),
                  ),

                  // Filtro Data
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
                        setState(() => dataSelecionada = value);
                      },
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Resetar filtros
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

            // Lista
            Expanded(
              child: ListView(
                children: chamadosFiltrados.map((chamado) {
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
                      backgroundColor: AppColors.success,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CriarChamadoScreen(userName: widget.userName), // ✅
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
