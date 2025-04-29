// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:routerapp/models/endereco.dart';

class EnderecoScreen extends StatefulWidget {
  const EnderecoScreen({super.key});

  @override
  State<EnderecoScreen> createState() => _EnderecoScreenState();
}

class _EnderecoScreenState extends State<EnderecoScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _logradouroController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();

  String? _estadoSelecionado; // Variável para armazenar o estado selecionado

  final List<String> _estados = [
    'AC',
    'AL',
    'AP',
    'AM',
    'BA',
    'CE',
    'DF',
    'ES',
    'GO',
    'MA',
    'MT',
    'MS',
    'MG',
    'PA',
    'PB',
    'PR',
    'PE',
    'PI',
    'RJ',
    'RN',
    'RS',
    'RO',
    'RR',
    'SC',
    'SP',
    'SE',
    'TO',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Pessoa Jurídica')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Dados do Endereço',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _logradouroController,
                decoration: const InputDecoration(
                  labelText: 'Logradouro',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite a Rua';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),
              TextFormField(
                controller: _numeroController,
                decoration: const InputDecoration(
                  labelText: 'Número',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite o Número';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),
              TextFormField(
                controller: _bairroController,
                decoration: const InputDecoration(
                  labelText: 'Bairro',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite o Bairro';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),
              TextFormField(
                controller: _cidadeController,
                decoration: const InputDecoration(
                  labelText: 'Cidade',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite a Cidade';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Estado',
                  border: OutlineInputBorder(),
                ),
                value: _estadoSelecionado,
                items:
                    _estados.map((String estado) {
                      return DropdownMenuItem<String>(
                        value: estado,
                        child: Text(estado),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _estadoSelecionado = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecione o Estado';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }

                  // Captura todos os valores antes do await:
                  final logradouro = _logradouroController.text;
                  final numero = _numeroController.text;
                  final bairro = _bairroController.text;
                  final cidade = _cidadeController.text;
                  final estado = _estadoSelecionado!;

                  final novoEndereco = Endereco(
                    logradouro: logradouro,
                    numero: numero,
                    bairro: bairro,
                    cidade: cidade,
                    estado: estado,

                    // Outros campos de PessoaFisica, se houver
                  );

                  // Retorna o objeto PessoaFisica para a tela anterior
                  Navigator.pop(context, novoEndereco);
                },
                child: const Text('Adicionar Endereço'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
