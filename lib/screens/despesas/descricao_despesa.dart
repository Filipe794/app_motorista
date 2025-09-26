import 'package:flutter/material.dart';
import 'package:rota_mais/screens/chamados/anexar_midia.dart';
import 'package:rota_mais/screens/despesas/anexar_comprovantes.dart';

class DescricaoDespesas extends StatefulWidget {
  final String userName;
  const DescricaoDespesas({super.key, required this.userName});

  @override
  State<DescricaoDespesas> createState() => _DescricaoDespesasState();
}

class _DescricaoDespesasState extends State<DescricaoDespesas> {
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A),
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Descrição da Despesa',
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
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Campo descrição
            const Text(
              'Descrição:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descricaoController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Ex: Almoço com cliente, abastecimento...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue.shade300),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),

            const SizedBox(height: 20),

            // Campo valor
            const Text(
              'Valor gasto:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _valorController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'R\$ 0,00',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue.shade300),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              String descricao = _descricaoController.text.trim();
              String valor = _valorController.text.trim();

              if (descricao.isEmpty || valor.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Preencha todos os campos!'),
                  ),
                );
                return;
              }

              // Navegar para a próxima tela (exemplo AnexarMidia)
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AnexarComprovante(userName: widget.userName),
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
    );
  }
}
