import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:routerapp/models/finalidadeservico.dart';
import 'package:routerapp/models/pessoajuridica.dart';
import 'package:routerapp/models/rota.dart';
import 'package:routerapp/models/servico.dart';
//import 'package:routerapp/models/situacaoservico.dart';
import 'package:routerapp/screens/cadastropessoajuridica_screen.dart';
import 'package:routerapp/services/finalidadeservico_service.dart';
import 'package:routerapp/services/pessoajuridica_service.dart';
import 'package:routerapp/services/servico_service.dart';
//import 'package:routerapp/services/situacaoservico_service.dart';

class ServicoScreen extends StatefulWidget {
  final Rota rota;

  const ServicoScreen({super.key, required this.rota});

  @override
  ServicoScreenState createState() => ServicoScreenState();
}

class ServicoScreenState extends State<ServicoScreen> {
  late Future<List<PessoaJuridica>> _futurePessoasJuridicas; // Usando late
  late Future<List<FinalidadeServico>> _futureFinalidades; // Usando late
  String? _observacaoServico; // Para armazenar a observação
  //late Future<List<SituacaoServico>> _futureSituacoesServico; // Usando late

  PessoaJuridica? _pessoaJuridicaSelecionada;
  FinalidadeServico? _finalidadeSelecionada;
  //SituacaoServico? _situacaoServicoSelecionada;

  @override
  void initState() {
    super.initState();
    _futurePessoasJuridicas = PessoaJuridicaService.fetchPessoaJuridica();
    _futureFinalidades = FinalidadeServicoService.fetchFinalidadeServico();
    //_futureSituacoesServico = SituacaoServicoService.fetchSituacaoServico();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: Text('Inserir Serviço'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rota: ${widget.rota.codigo}',
              //style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            //SizedBox(height: 8),
            Text('Criação: ${dateFormat.format(widget.rota.datacriacao)}'),
            if (widget.rota.datafechamento != null)
              Text(
                'Fechamento: ${dateFormat.format(widget.rota.datafechamento!)}',
              ),
            if (widget.rota.observacao != null)
              Text('Observação: ${widget.rota.observacao}'),
            Text('Ativo: ${widget.rota.ativo == 1 ? 'Sim' : 'Não'}'),
            Text('Situação Rota: Criada'),
            SizedBox(height: 24),
            Text(
              'Novo Serviço',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 16),
            Text('Situação do Serviço: Aberto'),

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
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
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
                        const SizedBox(height: 16),
                        DropdownButtonFormField<PessoaJuridica>(
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
                        ),
                      ],
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

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () async {
                final observacao = await _mostrarDialogObservacao(context);

                if (observacao != null) {
                  // Só atualiza se usuário clicou em "Salvar"
                  setState(() {
                    _observacaoServico = observacao;
                  });
                }
              },
              child: const Text('Adicionar Observação'),
            ),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_pessoaJuridicaSelecionada != null &&
                        _finalidadeSelecionada != null) {
                      final Servico? novoServico =
                          await ServicoService.inserirServico(
                            observacao: _observacaoServico,
                            idfinalidade: _finalidadeSelecionada!.id,
                            idrota: widget.rota.id,
                            idpessoajuridica: _pessoaJuridicaSelecionada!.id,
                          );

                      if (novoServico != null && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Serviço cadastrado com sucesso!'),
                          ),
                        );

                        _resetarCampos();
                      } else if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Erro ao cadastrar o serviço.'),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Por favor, selecione a Pessoa Jurídica e a Finalidade do Serviço.',
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text('Salvar Serviço'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _resetarCampos() {
    setState(() {
      _pessoaJuridicaSelecionada = null;
      _finalidadeSelecionada = null;
      _observacaoServico = null;
    });
  }

  Future<String?> _mostrarDialogObservacao(BuildContext context) async {
    String? observacao;

    final FocusNode focusNode = FocusNode(); // <-- aqui

    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        TextEditingController observacaoController = TextEditingController(
          text: _observacaoServico,
        );

        // Logo depois que o diálogo for construído, dá foco
        WidgetsBinding.instance.addPostFrameCallback((_) {
          focusNode.requestFocus();
        });

        return AlertDialog(
          title: const Text('Adicionar Observação'),
          content: TextFormField(
            focusNode: focusNode, // <-- conecta aqui

            controller: observacaoController,
            maxLength: 255,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                observacao = observacaoController.text;
                Navigator.of(context).pop(observacao);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );

    focusNode.dispose(); // não esqueça de liberar depois!
    return observacao;
  }
}
