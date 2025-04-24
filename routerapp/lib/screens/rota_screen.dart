import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:routerapp/models/rota.dart';
import 'package:routerapp/screens/servico_screen.dart'; // Import da ServicoScreen
// Importe seus services e outros models necessários

class RotaScreen extends StatefulWidget {
  const RotaScreen({super.key});

  @override
  RotaScreenState createState() => RotaScreenState();
}

class RotaScreenState extends State<RotaScreen> {
  // Suponha que você tenha uma lista de rotas carregada aqui
  Future<List<Rota>>? _futureRotas;

  @override
  void initState() {
    super.initState();
    // Carregue suas rotas aqui (se já não estiverem carregadas)
    // _futureRotas = RotaService.fetchRotas();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(title: const Text('Rotas')),
      body: FutureBuilder<List<Rota>>(
        future: _futureRotas, // Use seu Future<List<Rota>> aqui
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar rotas: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final rotas = snapshot.data!;
            return ListView.builder(
              itemCount: rotas.length,
              itemBuilder: (context, index) {
                final rota = rotas[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Código: ${rota.codigo}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('ID: ${rota.id}'),
                        Text('Criação: ${dateFormat.format(rota.datacriacao)}'),
                        if (rota.datafechamento != null)
                          Text(
                            'Fechamento: ${dateFormat.format(rota.datafechamento!)}',
                          ),
                        if (rota.observacao != null)
                          Text('Observação: ${rota.observacao}'),
                        Text('Ativo: ${rota.ativo == 1 ? 'Sim' : 'Não'}'),
                        Text('Situação ID: ${rota.idsituacao}'),
                        // Você pode adicionar mais detalhes da rota aqui
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('Nenhuma rota encontrada.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Criar uma nova instância de Rota (com valores iniciais, se necessário)
          final novaRota = Rota(
            id: 0, // O ID será gerado pelo backend
            codigo:
                '', // Você pode gerar um código inicial ou deixar o usuário preencher
            datacriacao: DateTime.now(),
            datafechamento: null,
            observacao: null,
            ativo: 1, // Ou outro valor padrão
            idsituacao: 1, // Ou outro valor padrão
          );

          // Navegar para a ServicoScreen, passando a nova rota
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ServicoScreen(rota: novaRota),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
