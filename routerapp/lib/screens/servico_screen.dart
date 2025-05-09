// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:routerapp/models/finalidadeservico.dart';
import 'package:routerapp/models/pessoafisica.dart';
import 'package:routerapp/models/pessoajuridica.dart';
import 'package:routerapp/models/rota.dart';
import 'package:routerapp/models/servico.dart';
import 'package:routerapp/screens/cadastropessoajuridica_screen.dart';
import 'package:routerapp/services/finalidadeservico_service.dart';
import 'package:routerapp/services/pessoafisica_service.dart';
import 'package:routerapp/services/pessoajuridica_service.dart';
import 'package:routerapp/services/servico_service.dart';

class ServicoScreen extends StatefulWidget {
  final Rota rota;

  const ServicoScreen({super.key, required this.rota});

  @override
  ServicoScreenState createState() => ServicoScreenState();
}

class ServicoScreenState extends State<ServicoScreen> {
  late Future<List<PessoaJuridica>> _futurePessoasJuridicas;
  late Future<List<FinalidadeServico>> _futureFinalidades;
  String? _observacaoServico;

  PessoaJuridica? _pessoaJuridicaSelecionada;
  PessoaFisica? _pessoaFisicaSelecionada;
  FinalidadeServico? _finalidadeSelecionada;

  List<PessoaFisica> _pessoasFisicasAssociadas = [];
  bool _isLoadingPF = false;

  @override
  void initState() {
    super.initState();
    _futurePessoasJuridicas = PessoaJuridicaService.fetchPessoaJuridica();
    _futureFinalidades = FinalidadeServicoService.fetchFinalidadeServico();
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
            SizedBox(
              width: double.infinity,
              child: Card(
                margin: const EdgeInsets.all(16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Rota: ${widget.rota.codigo}'),
                      Text(
                        'Criação: ${dateFormat.format(widget.rota.datacriacao)}',
                      ),
                      if (widget.rota.datafechamento != null)
                        Text(
                          'Fechamento: ${dateFormat.format(widget.rota.datafechamento!)}',
                        ),
                      if (widget.rota.observacao != null)
                        Text('Observação: ${widget.rota.observacao}'),
                      Text('Ativo: ${widget.rota.ativo == 1 ? 'Sim' : 'Não'}'),
                      Text('Situação Rota: Criada'),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
            const Text('Situação do Serviço: Aberto'),
            const SizedBox(height: 16),
            FutureBuilder<List<PessoaJuridica>>(
              future: _futurePessoasJuridicas,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
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
                        const Text('Nenhuma Pessoa Jurídica cadastrada.'),
                        const SizedBox(height: 8),
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
                        const SizedBox(height: 8),
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
                            labelText: 'Cliente',
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
                          onChanged: (PessoaJuridica? newValue) async {
                            if (newValue != null) {
                              setState(() {
                                _pessoaJuridicaSelecionada = newValue;
                                _pessoasFisicasAssociadas =
                                    []; // Limpa a lista anterior
                                _pessoaFisicaSelecionada =
                                    null; // Reseta o dropdown de PF
                                _isLoadingPF =
                                    true; // Inicia o carregamento das PFs
                              });
                              try {
                                final pessoas =
                                    await PessoaFisicaService.fetchPessoasFisicasAssociadas(
                                      idpessoajuridica: newValue.id,
                                    );
                                setState(() {
                                  _pessoasFisicasAssociadas = pessoas;
                                  _isLoadingPF =
                                      false; // Finaliza o carregamento das PFs
                                });
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Erro: $e')),
                                  );
                                }
                                setState(() {
                                  _isLoadingPF =
                                      false; // Garante que o loading seja desativado em caso de erro
                                });
                              }
                            }
                          },
                          validator:
                              (value) =>
                                  value == null ? 'Selecione uma PJ' : null,
                        ),
                        const SizedBox(height: 16),
                        // Dropdown de Pessoa Física
                        DropdownButtonFormField<PessoaFisica>(
                          decoration: InputDecoration(
                            labelText: 'Responsável',
                            border: const OutlineInputBorder(),
                            // Exibe um indicador de carregamento dentro do InputDecoration
                            suffixIcon:
                                _isLoadingPF
                                    ? const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.blue,
                                      ), // Cor do indicador
                                      strokeWidth:
                                          2.0, // Espessura da linha do indicador
                                    )
                                    : null, // Não exibe nada se não estiver carregando
                          ),
                          value: _pessoaFisicaSelecionada,
                          items:
                              _pessoasFisicasAssociadas.map((PessoaFisica pf) {
                                return DropdownMenuItem<PessoaFisica>(
                                  value: pf,
                                  child: Text(pf.nome),
                                );
                              }).toList(),
                          onChanged:
                              _isLoadingPF || _pessoasFisicasAssociadas.isEmpty
                                  ? null
                                  : (PessoaFisica? newValue) {
                                    setState(() {
                                      _pessoaFisicaSelecionada = newValue;
                                    });
                                  },
                          hint: Text(
                            _pessoasFisicasAssociadas.isNotEmpty
                                ? 'Selecione um responsável'
                                : 'Nenhum responsável associado',
                          ),
                          validator: (value) {
                            if (_pessoasFisicasAssociadas.isNotEmpty &&
                                value == null) {
                              return 'Selecione um responsável';
                            }
                            return null;
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
                    validator:
                        (value) =>
                            value == null ? 'Selecione a finalidade' : null,
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
                            idPessoaFisica: _pessoaFisicaSelecionada?.id,
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
      _pessoaFisicaSelecionada = null;
      _finalidadeSelecionada = null;
      _observacaoServico = null;
      _pessoasFisicasAssociadas = [];
    });
  }

  Future<String?> _mostrarDialogObservacao(BuildContext context) async {
    String? observacao;

    final FocusNode focusNode = FocusNode();

    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        TextEditingController observacaoController = TextEditingController(
          text: _observacaoServico,
        );

        WidgetsBinding.instance.addPostFrameCallback((_) {
          focusNode.requestFocus();
        });

        return AlertDialog(
          title: const Text('Adicionar Observação'),
          content: TextFormField(
            focusNode: focusNode,
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

    focusNode.dispose();
    return observacao;
  }
}
