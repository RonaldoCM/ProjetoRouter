// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:routerapp/models/rota.dart';
import 'package:routerapp/models/servico.dart';
import 'package:routerapp/screens/servico_screen.dart';
import 'package:routerapp/services/rota_service.dart';
import 'package:routerapp/services/servico_service.dart'; // Importe o serviço de fetch

class DetalhesDaRotaScreen extends StatefulWidget {
  final int rotaId;

  const DetalhesDaRotaScreen({super.key, required this.rotaId});

  @override
  DetalhesDaRotaScreenState createState() => DetalhesDaRotaScreenState();
}

class DetalhesDaRotaScreenState extends State<DetalhesDaRotaScreen> {
  late Future<List<Servico>> _futureServicos;
  Rota? _rota;

  @override
  void initState() {
    super.initState();
    // Carregar os serviços para a rota especificada
    //_futureServicos = ServicoService.fetchServicosByRota(widget.rotaId);
    _carregarDados();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _rota == null ? 'Rota: Carregando...' : 'Rota: ${_rota!.codigo}',
        ),
      ),
      body: FutureBuilder<List<Servico>>(
        future: _futureServicos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar serviços: ${snapshot.error}'),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final servicos = snapshot.data!;

            // Verifica se a rota deve ser fechada após carregar os serviços
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _verificarEFecharRota(servicos);
            });

            return ListView.builder(
              itemCount: servicos.length,

              itemBuilder: (context, index) {
                final servico = servicos[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween, // Espaço máximo entre os filhos
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start, // Alinha os filhos ao topo
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'ID: ${servico.id}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Criação:  ${dateFormat.format(servico.datacriacao)}',
                                  ),
                                  if (servico.datafechamento != null)
                                    Text(
                                      'Fechamento: ${servico.datafechamento}',
                                    ),
                                  Text('Finalidade: ${servico.finalidade}'),
                                  //Text('Rota: ${servico.codigoRota}'),
                                  Text(
                                    'Destino: ${servico.nomePessoaJuridica}',
                                  ),
                                  Text(
                                    '${servico.logradouro}, ${servico.numero} ${servico.bairro}',
                                  ),
                                  Text('${servico.cidade} / ${servico.estado}'),
                                  if (servico.observacao != null)
                                    Text('Observação: ${servico.observacao}'),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start, // Alinha os filhos à direita
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .start, // Alinha os elementos do Row à direita
                                  children: <Widget>[
                                    // const Text('Situação: '),
                                    Switch(
                                      value: servico.situacao == 'Aberto',
                                      onChanged: (bool newValue) {
                                        _atualizarSituacao(
                                          servico,
                                          newValue
                                              ? 1
                                              : 2, // 1 = Aberto, 2 = Fechado
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                Text(servico.situacao),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .start, // Alinha os botões à direita
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                _atualizarSituacao(
                                  servico,
                                  4,
                                ); // 4 = Incompleto
                              },
                              child: const Text('Incompleto'),
                            ),
                            const SizedBox(width: 8.0),
                            ElevatedButton(
                              onPressed:
                                  () => _mostrarConfirmacaoCancelamento(
                                    context,
                                    servico,
                                  ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                              ),
                              child: const Text('Cancelar'),
                            ),
                            //const SizedBox(width: 8.0),
                            /*     IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed:
                                  () => _deletarServico(context, servico), */
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('Nenhum serviço encontrado.'));
          }
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //CHAMAR A TELA DE INSERÇÃO DE SERVIÇO AQUI...

          // Rota rota = await RotaService.fetchRotasById(widget.rotaId);

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ServicoScreen(rota: _rota!),
            ),
          ).then((_) {
            // Este bloco .then será executado quando a ServicoScreen for desempilhada
            setState(() {
              _futureServicos = ServicoService.fetchServicosByRota(
                widget.rotaId,
              );
            });
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _carregarDados() async {
    // Carregar os serviços para a rota especificada
    _futureServicos = ServicoService.fetchServicosByRota(widget.rotaId);
    // Buscar os detalhes da rota
    try {
      final rota = await RotaService.fetchRotaById(widget.rotaId);
      setState(() {
        _rota = rota;
      });
    } catch (error) {
      // Tratar o erro ao carregar a rota, se necessário
      //print('Erro ao carregar detalhes da rota: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar detalhes da rota.')),
      );
    }
  }

  // Mapa para traduzir o ID para a string de situação (para exibição)
  final Map<int, String> _idParaSituacao = {
    1: 'Aberto',
    2: 'Fechado',
    3: 'Cancelado',
    4: 'Incompleto',
  };

  Future<void> _atualizarSituacao(Servico servico, int novaSituacaoId) async {
    bool sucesso = await ServicoService.atualizarSituacaoServico(
      idServico: servico.id,
      idSituacaoServico: novaSituacaoId,
    );

    if (sucesso) {
      setState(() {
        _futureServicos = ServicoService.fetchServicosByRota(widget.rotaId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Serviço "${servico.id}" atualizado para ${_idParaSituacao[novaSituacaoId]}.',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar o serviço "${servico.id}".')),
      );
    }
  }

  Future<void> _mostrarConfirmacaoCancelamento(
    BuildContext context,
    Servico servico,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Cancelamento'),
          content: const Text(
            'Você tem certeza que deseja cancelar este serviço?',
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
                // Realiza o cancelamento (situação 3)
                await _atualizarSituacao(servico, 3);
                Navigator.of(context).pop(); // Fecha o diálogo
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _verificarEFecharRota(List<Servico> servicos) async {
    if (_rota != null && servicos.isNotEmpty) {
      final temServicosAbertos = servicos.any((s) => s.situacao == 'Aberto');
      if (!temServicosAbertos && _rota!.idsituacao != 3) {
        // Se não há serviços abertos e a rota não está fechada, fecha a rota
        bool sucesso = await RotaService.atualizarSituacaoRota(
          idRota: _rota!.id,
          idSituacaoRota: 3, // Situação para "Fechado"
        );
        if (sucesso) {
          // Busca novamente os detalhes da rota atualizados
          try {
            final rotaAtualizada = await RotaService.fetchRotaById(_rota!.id);
            setState(() {
              _rota =
                  rotaAtualizada; // Atualiza o estado com a rota mais recente
            });
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Rota "${_rota!.codigo}" fechada.')),
              );
            }
          } catch (error) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Erro ao recarregar detalhes da rota.')),
              );
            }
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Erro ao fechar a rota "${_rota!.codigo}".'),
              ),
            );
          }
        }
      }
    }
  }

  /*
  // Método para verificar se a rota deve ser fechada
  Future<void> _verificarEFecharRota(List<Servico> servicos) async {
    if (_rota != null && servicos.isNotEmpty) {
      final temServicosAbertos = servicos.any((s) => s.situacao == 'Aberto');
      if (!temServicosAbertos && _rota!.idsituacao != 3) {
        // Se não há serviços abertos e a rota não está fechada, fecha a rota
        bool sucesso = await RotaService.atualizarSituacaoRota(
          idRota: _rota!.id,
          idSituacaoRota:
              3, // Situação para "Fechado" (você pode usar "Cancelado" se preferir)
        );
        if (sucesso) {
          setState(() {
            _rota!.idsituacao = 3;
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Rota "${_rota!.codigo}" fechada.')),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Erro ao fechar a rota "${_rota!.codigo}".'),
              ),
            );
          }
        }
      }
    }
  }

*/
}
