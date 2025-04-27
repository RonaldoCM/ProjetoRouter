import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:routerapp/models/rota.dart';
import 'package:routerapp/screens/DetalhesdaRota_screen.dart';
import 'package:routerapp/screens/servico_screen.dart';
import 'package:routerapp/services/rota_service.dart'; // Import da ServicoScreen
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
    //_futureRotas = RotaService.fetchRotas();
    _carregarRotas();
  }

  Future<void> _carregarRotas() async {
    setState(() {
      _futureRotas = RotaService.fetchRotas();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(title: const Text('Rotas')),
      body: RefreshIndicator(
        // RefreshIndicator permite que o usuário atualize a lista de rotas manualmente com um gesto de "puxar para baixo".
        onRefresh: _carregarRotas,
        child: FutureBuilder<List<Rota>>(
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
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => DetalhesDaRotaScreen(
                                  rotaId: rota.id,
                                ), // <- passa a rota selecionada
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Código: ${rota.codigo}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('ID: ${rota.id}'),
                            Text(
                              'Criação: ${dateFormat.format(rota.datacriacao)}',
                            ),
                            if (rota.datafechamento != null)
                              Text(
                                'Fechamento: ${dateFormat.format(rota.datafechamento!)}',
                              ),
                            if (rota.observacao != null)
                              Text('Observação: ${rota.observacao}'),
                            Text('Ativo: ${rota.ativo == 1 ? 'Sim' : 'Não'}'),
                            Text('Situação ID: ${rota.idsituacao}'),
                          ],
                        ),
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
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Chamar o serviço para criar a rota com observação nula
          Rota? novaRota = await RotaService.criarRota(null);

          if (novaRota != null) {
            if (mounted) {
              // Navegar para a ServicoScreen, passando a rota criada
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ServicoScreen(rota: novaRota),
                ),
              ).then((_) {
                // Este bloco .then será executado quando a ServicoScreen for desempilhada
                _carregarRotas(); // Recarrega as rotas quando volta para esta tela
              });
            }
          } else {
            // Verificar se o widget ainda está montado antes de mostrar o SnackBar
            if (mounted) {
              // Mostrar uma mensagem de erro se a criação da rota falhar
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Erro ao criar a nova rota.')),
              );
            }
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
