// TODO: Implementar formulário de novo chamado
// TODO: Adicionar seleção de tipo/categoria
// TODO: Implementar upload de anexos
// TODO: Adicionar seleção de prioridade
// TODO: Implementar validação de campos
// TODO: Adicionar campo de descrição detalhada

import 'package:flutter/material.dart';
import 'package:rota_mais/screens/chamados/anexar_midia.dart';

class DescricaoChamados extends StatefulWidget {
  final String userName; // <-- recebe o nome do motorista

  const DescricaoChamados({super.key, required this.userName});

  @override
  State<DescricaoChamados> createState() => _DescricaoChamadosState();
}

class _DescricaoChamadosState extends State<DescricaoChamados> {
  String? categoriaSelecionada;
  final TextEditingController _descricaoController = TextEditingController();

  @override
  void dispose() {
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A),
        leading: const BackButton(
          color: Colors.white,
        ),
        title: const Text(
          'Criar Chamado',
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
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Descrição do chamado:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),

            // Campo de descrição do chamado
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                maxLines: 6,
                controller: _descricaoController,
                decoration: InputDecoration(
                  hintText: 'Descreva o problema ou solicitação...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.blue.shade300,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
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
              // Navegar para a próxima tela
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AnexarMidia(userName: widget.userName), // <-- Corrigido
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
