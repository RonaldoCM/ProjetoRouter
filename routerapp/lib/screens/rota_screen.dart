// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:routerapp/models/rota.dart';
import 'package:routerapp/models/servico.dart';
import 'package:routerapp/screens/detalhesdarota_screen.dart';
import 'package:routerapp/screens/servico_screen.dart';
import 'package:routerapp/services/rota_service.dart';
import 'package:routerapp/services/servico_service.dart';

class RotaScreen extends StatefulWidget {
  const RotaScreen({super.key});

  @override
  RotaScreenState createState() => RotaScreenState();
}

class RotaScreenState extends State<RotaScreen> {
  Future<List<Rota>>? _futureRotas;

  @override
  void initState() {
    super.initState();
    _carregarRotas();
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
          future: _futureRotas,
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
                        ).then((_) {
                          // Este bloco .then será executado quando a ServicoScreen for desempilhada
                          _carregarRotas(); // Recarrega as rotas quando volta para esta tela
                        });
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
                            // Text('ID: ${rota.id}'),
                            Text(
                              'Criação: ${dateFormat.format(rota.datacriacao)}',
                            ),
                            if (rota.datafechamento != null)
                              Text(
                                'Fechamento: ${dateFormat.format(rota.datafechamento!)}',
                              ),
                            if (rota.observacao != null)
                              Text('Observação: ${rota.observacao}'),
                            Text(
                              'Ativo: ${rota.idsituacao == 1 ? 'Sim' : 'Não'}',
                            ),

                            //      Column(
                            //        crossAxisAlignment:
                            //            CrossAxisAlignment
                            //               .start, // Alinha os filhos à direita
                            //        children: <Widget>[
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .start, // Alinha os elementos do Row à direita
                              children: <Widget>[
                                Switch(
                                  value: rota.idsituacao == 1,
                                  onChanged:
                                      rota.idsituacao == 1
                                          ? (value) {
                                            _mostrarConfirmacaoCancelamento(
                                              context,
                                              rota,
                                            );
                                          }
                                          : null, // Desabilita o switch se a rota não estiver ativa
                                ),
                              ],
                            ),
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

  Future<void> _carregarRotas() async {
    setState(() {
      _futureRotas = RotaService.fetchRotas();
    });
  }

  Future<void> _atualizarSituacaoRota(Rota rota, int novaSituacaoId) async {
    bool sucesso = await RotaService.atualizarSituacaoRota(
      idRota: rota.id,
      idSituacaoRota: novaSituacaoId,
    );

    if (sucesso) {
      _carregarRotas();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rota "${rota.codigo}" atualizada.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar a Rota "${rota.codigo}".')),
      );
    }
  }

  Future<void> _mostrarConfirmacaoCancelamento(
    BuildContext context,
    Rota rota,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirmar Desativação',
          ), // Mudando o título para refletir a ação
          content: const Text(
            'Você tem certeza que deseja desativar esta Rota e fechar todos os seus serviços?',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Não'),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
            ),
            TextButton(
              child: const Text('Sim'),
              onPressed: () async {
                // 1. Desativa a rota
                await _atualizarSituacaoRota(rota, 3);

                // 2. Busca todos os serviços da rota desativada
                try {
                  final List<Servico> servicosDaRota =
                      await ServicoService.fetchServicosByRota(rota.id);

                  // 3. Itera sobre os serviços e os fecha
                  for (var servico in servicosDaRota) {
                    await ServicoService.atualizarSituacaoServico(
                      idServico: servico.id,
                      idSituacaoServico: 3,
                    );
                  }

                  // 4. Recarrega a lista de rotas para atualizar a UI
                  _carregarRotas();

                  // 5. Mostra uma mensagem de sucesso
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Rota "${rota.codigo}" desativada e seus serviços fechados.',
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Erro ao desativar a rota ou fechar seus serviços.',
                        ),
                      ),
                    );
                  }
                }

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
