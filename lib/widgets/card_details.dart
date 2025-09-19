import 'package:flutter/material.dart';
import 'package:rota_mais/utils/responsive_helper.dart';

class Chamado_DespesasCard extends StatelessWidget {
  final String id;
  final String titulo;
  final String data;
  final double valor;
  final VoidCallback? onTap;

  const Chamado_DespesasCard({
    super.key,
    required this.id,
    required this.titulo,
    required this.data,
    required this.valor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: ListTile(
        onTap: onTap,
        leading: const Icon(Icons.build, color: Colors.black87),
        title: Text(
    titulo,
    style: TextStyle(
        color: const Color(0xFF2C2D33),
        fontSize: 20,
        fontFamily: 'Plus Jakarta Sans',
        fontWeight: FontWeight.w700,
    ),
),
        subtitle: Text(
          ' $data',
style: TextStyle(
color: const Color(0xFF153E42),
fontSize: 14,
fontFamily: 'Nunito Sans',
fontWeight: FontWeight.w700,
),
),
        trailing: Text(
          "R\$ ${valor.toStringAsFixed(2)}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: context.fontSize(20),
          ),
        ),
        isThreeLine: true,
      ),
    );
  }
}
