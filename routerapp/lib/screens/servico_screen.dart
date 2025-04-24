import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:routerapp/models/finalidadeservico.dart';
import 'package:routerapp/models/pessoajuridica.dart';
import 'package:routerapp/models/rota.dart';
import 'package:routerapp/models/servico.dart';
import 'package:routerapp/models/situacaoservico.dart';
import 'package:routerapp/services/finalidadeservico_service.dart';
import 'package:routerapp/services/pessoajuridica_service.dart';
import 'package:routerapp/services/situacaoservico_service.dart';

class ServicoScreen extends StatefulWidget {
  final Rota rota;

  const ServicoScreen({super.key, required this.rota});

  @override
  ServicoScreenState createState() => ServicoScreenState();
}

class ServicoScreenState extends State<ServicoScreen> {
  late Future<List<PessoaJuridica>> _futurePessoasJuridicas; // Usando late
  late Future<List<FinalidadeServico>> _futureFinalidades; // Usando late
  late Future<List<SituacaoServico>> _futureSituacoesServico; // Usando late

  PessoaJuridica? _pessoaJuridicaSelecionada;
  FinalidadeServico? _finalidadeSelecionada;
  SituacaoServico? _situacaoServicoSelecionada;

  @override
  void initState() {
    super.initState();
    _futurePessoasJuridicas = PessoaJuridicaService.fetchPessoaJuridica();
    _futureFinalidades = FinalidadeServicoService.fetchFinalidadeServico();
    _futureSituacoesServico = SituacaoServicoService.fetchSituacaoServico();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(title: Text('Inserir Serviço')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rota: ${widget.rota.codigo}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('ID: ${widget.rota.id}'),
            Text('Criação: ${dateFormat.format(widget.rota.datacriacao)}'),
            if (widget.rota.datafechamento != null)
              Text(
                'Fechamento: ${dateFormat.format(widget.rota.datafechamento!)}',
              ),
            if (widget.rota.observacao != null)
              Text('Observação: ${widget.rota.observacao}'),
            Text('Ativo: ${widget.rota.ativo == 1 ? 'Sim' : 'Não'}'),
            Text('Situação ID: ${widget.rota.idsituacao}'),
            SizedBox(height: 24),
            Text(
              'Novo Serviço',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            FutureBuilder<List<PessoaJuridica>>(
              future: _futurePessoasJuridicas,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text(
                    'Erro ao carregar Pessoas Jurídicas: ${snapshot.error}',
                  );
                } else if (snapshot.hasData) {
                  final pessoasJuridicas = snapshot.data!;
                  if (pessoasJuridicas.isEmpty) {
                    return Column(
                      children: [
                        Text('Nenhuma Pessoa Jurídica cadastrada.'),
                        SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        const CadastroPessoaJuridicaScreen(),
                              ),
                            ).then((value) {
                              if (value != null && value == true) {
                                setState(() {
                                  _futurePessoasJuridicas =
                                      PessoaJuridicaService.fetchPessoaJuridica();
                                });
                              }
                            });
                          },
                          child: const Text('Cadastrar Pessoa Jurídica'),
                        ),
                      ],
                    );
                  } else {
                    return DropdownButtonFormField<PessoaJuridica>(
                      decoration: const InputDecoration(
                        labelText: 'Pessoa Jurídica',
                        border: OutlineInputBorder(),
                      ),
                      value: _pessoaJuridicaSelecionada,
                      items:
                          pessoasJuridicas.map((PessoaJuridica pj) {
                            return DropdownMenuItem<PessoaJuridica>(
                              value: pj,
                              child: Text(pj.nome),
                            );
                          }).toList(),
                      onChanged: (PessoaJuridica? newValue) {
                        setState(() {
                          _pessoaJuridicaSelecionada = newValue;
                        });
                      },
                    );
                  }
                } else {
                  return const Text('Erro ao carregar informações.');
                }
              },
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<FinalidadeServico>>(
              future: _futureFinalidades,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text(
                    'Erro ao carregar Finalidades: ${snapshot.error}',
                  );
                } else if (snapshot.hasData) {
                  final finalidades = snapshot.data!;
                  return DropdownButtonFormField<FinalidadeServico>(
                    decoration: const InputDecoration(
                      labelText: 'Finalidade do Serviço',
                      border: OutlineInputBorder(),
                    ),
                    value: _finalidadeSelecionada,
                    items:
                        finalidades.map((FinalidadeServico finalidade) {
                          return DropdownMenuItem<FinalidadeServico>(
                            value: finalidade,
                            child: Text(finalidade.descricao),
                          );
                        }).toList(),
                    onChanged: (FinalidadeServico? newValue) {
                      setState(() {
                        _finalidadeSelecionada = newValue;
                      });
                    },
                  );
                } else {
                  return const Text('Erro ao carregar informações.');
                }
              },
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<SituacaoServico>>(
              future: _futureSituacoesServico,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text(
                    'Erro ao carregar Situações do Serviço: ${snapshot.error}',
                  );
                } else if (snapshot.hasData) {
                  final situacoesServico = snapshot.data!;
                  return DropdownButtonFormField<SituacaoServico>(
                    decoration: const InputDecoration(
                      labelText: 'Situação do Serviço',
                      border: OutlineInputBorder(),
                    ),
                    value: _situacaoServicoSelecionada,
                    items:
                        situacoesServico.map((SituacaoServico situacao) {
                          return DropdownMenuItem<SituacaoServico>(
                            value: situacao,
                            child: Text(
                              situacao.descricao,
                            ), // Use o campo correto
                          );
                        }).toList(),
                    onChanged: (SituacaoServico? newValue) {
                      setState(() {
                        _situacaoServicoSelecionada = newValue;
                      });
                    },
                  );
                } else {
                  return const Text('Erro ao carregar informações.');
                }
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                if (_pessoaJuridicaSelecionada != null &&
                    _finalidadeSelecionada != null &&
                    _situacaoServicoSelecionada != null) {
                  /*                   final novoServico = Servico(
                    id: 0,
                    datacriacao: DateTime.now(),
                    datafechamento: null,
                    idsituacaoservico: _situacaoServicoSelecionada!.id,
                    idfinalidade: _finalidadeSelecionada!.id,
                    idrota: widget.rota.id,
                    idpessoajuridica: _pessoaJuridicaSelecionada!.id,
                  ); */
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Por favor, selecione a Pessoa Jurídica, Finalidade e Situação do Serviço.',
                      ),
                    ),
                  );
                }
              },
              child: const Text('Salvar Serviço'),
            ),
          ],
        ),
      ),
    );
  }
}

class CadastroPessoaJuridicaScreen extends StatelessWidget {
  const CadastroPessoaJuridicaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Pessoa Jurídica')),
      body: const Center(child: Text('Tela de Cadastro de Pessoa Jurídica')),
    );
  }
}

extension ServicoToJson on Servico {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'datacriacao': datacriacao.toIso8601String(),
      'datafechamento': datafechamento?.toIso8601String(),
      'idsituacaoservico': idsituacaoservico,
      'idfinalidade': idfinalidade,
      'idrota': idrota,
      'idpessoajuridica': idpessoajuridica,
    };
  }
}
