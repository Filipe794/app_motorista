import 'package:flutter/material.dart';
import 'package:rota_mais/screens/chamados/chamados_list_screen.dart';
import 'package:rota_mais/screens/despesas/despesas_list_screen.dart';
import 'package:rota_mais/screens/escalas/escalas_list_screen.dart';
import 'package:rota_mais/screens/login_screen.dart';
import 'package:rota_mais/screens/tela_inicial.dart';

class LoadingScreen extends StatefulWidget {
  final String userName;

  const LoadingScreen({super.key, required this.userName});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool carregando = true;
  String mensagem = "Carregando comprovante...";

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        carregando = false;
        mensagem = "Pronto!";
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TelaInicial(
            userName: widget.userName,
            onLogout: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (Route<dynamic> route) => false,
              );
            },
            onNavigationTap: (String itemTitle) {
              switch (itemTitle) {
                case 'Chamados':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChamadosListScreen(userName: widget.userName,),
                    ),
                  );
                  break;
                case 'Despesas':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DespesasListScreen(userName: widget.userName,),
                    ),
                  );
                  break;
                case 'Escalas':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EscalasListScreen(userName: widget.userName),
                    ),
                  );
                  break;
                default:
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Navegação para "$itemTitle" em desenvolvimento'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
              }
            },
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                mensagem,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (carregando)
              const Padding(
                padding: EdgeInsets.only(bottom: 40.0),
                child: SizedBox(
                  width: 200,
                  child: LinearProgressIndicator(),
                ),
              ),
            if (!carregando)
              const Padding(
                padding: EdgeInsets.only(bottom: 40.0),
                child: SizedBox(
                  width: 200,
                  child: Divider(thickness: 2),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
