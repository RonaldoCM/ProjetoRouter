import 'package:flutter/material.dart';
import '../models/rota.dart';
import '../services/rota_service.dart';

class RotaScreen extends StatefulWidget {
  const RotaScreen({super.key});

  @override
  RotaScreenState createState() => RotaScreenState();
}

class RotaScreenState extends State<RotaScreen> {
  late Future<List<Rota>> futureRotas;

  @override
  void initState() {
    super.initState();
    futureRotas = RotaService.fetchRotas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rotas')),
      body: FutureBuilder<List<Rota>>(
        future: futureRotas,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final rotas = snapshot.data!;
            return ListView.builder(
              itemCount: rotas.length,
              itemBuilder: (context, index) {
                final rota = rotas[index];
                return ListTile(
                  title: Text(rota.codigo),
                  subtitle: Text('Situação: ${rota.idsituacao}'),
                  trailing: rota.ativo == 1 ? Text("Ativa") : Text("Inativa"),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
