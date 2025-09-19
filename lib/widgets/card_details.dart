import 'package:flutter/material.dart';
import 'package:app_motorista/utils/responsive_helper.dart';

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
            fontWeight: FontWeight.w600,
            fontSize: context.fontSize(20),
          ),
        ),
        subtitle: Text(
          "\n$data",
          style: TextStyle(fontSize: context.fontSize(16)),
        ),
        trailing: Text(
          "R\$ ${valor.toStringAsFixed(2)}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: context.fontSize(14),
          ),
        ),
        isThreeLine: true,
      ),
    );
  }
}
