// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:routerapp/models/endereco.dart';
import 'package:routerapp/models/pessoafisica.dart';
import 'package:routerapp/models/pessoajuridica.dart';
import 'package:routerapp/screens/cadastropessoafisica_screen.dart';
import 'package:routerapp/screens/endereco.screen.dart';
import 'package:routerapp/services/pessoajuridica_service.dart';
//import 'package:routerapp/screens/endereco_screen.dart';

class CadastroPessoaJuridicaScreen extends StatefulWidget {
  const CadastroPessoaJuridicaScreen({super.key});

  @override
  State<CadastroPessoaJuridicaScreen> createState() =>
      _CadastroPessoaJuridicaScreenState();
}

class _CadastroPessoaJuridicaScreenState
    extends State<CadastroPessoaJuridicaScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cnpjController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();

  // Lista para armazenar as pessoas físicas associadas
  final List<PessoaFisica> _pessoasFisicasAssociadas = [];

  // Objeto para armazenar o endereço
  Endereco? _endereco;

  final _cnpjFormatter = MaskTextInputFormatter(
    mask: '##.###.###/####-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final _telefoneFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

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
                'Dados da Pessoa Jurídica',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite o nome.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cnpjController,
                decoration: const InputDecoration(
                  labelText: 'CNPJ',
                  border: OutlineInputBorder(),
                ),
                inputFormatters: [_cnpjFormatter],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite o CNPJ.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _telefoneController,
                decoration: const InputDecoration(
                  labelText: 'Telefone (Opcional)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [_telefoneFormatter],
              ),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EnderecoScreen(),
                    ),
                  );
                  if (result is Endereco) {
                    setState(() {
                      _endereco = result;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Endereço adicionado.')),
                    );
                  }
                },
                child: const Text('Adicionar Endereço'),
              ),

              const SizedBox(height: 16),
              const Text(
                'Endereço',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              _endereco == null
                  ? const Text('Nenhum endereço adicionado.')
                  : Card(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Logradouro: ${_endereco?.logradouro ?? ''}'),
                          Text('Número: ${_endereco?.numero ?? ''}'),
                          Text('Bairro: ${_endereco?.bairro ?? ''}'),
                          Text('Cidade: ${_endereco?.cidade ?? ''}'),
                          Text('Estado: ${_endereco?.estado ?? ''}'),
                        ],
                      ),
                    ),
                  ),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  //   if (!_formKey.currentState!.validate()) {
                  //     return; // valida primeiro
                  //   }

                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CadastroPessoaFisicaScreen(),
                    ),
                  );

                  // Se a tela de cadastro de pessoa física retornar um resultado (a pessoa física cadastrada)
                  if (result is PessoaFisica) {
                    setState(() {
                      _pessoasFisicasAssociadas.add(result);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${result.nome} adicionado como colaborador.',
                        ),
                      ),
                    );
                  }
                },
                child: const Text('Adicionar Colaborador'),
              ),

              const SizedBox(height: 16),
              const Text(
                'Colaboradores Associados',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              _pessoasFisicasAssociadas.isEmpty
                  ? const Text('Nenhum colaborador adicionado.')
                  : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _pessoasFisicasAssociadas.length,
                    itemBuilder: (context, index) {
                      final colaborador = _pessoasFisicasAssociadas[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(colaborador.nome),
                        ),
                      );
                    },
                  ),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) {
                    return; // valida primeiro
                  }

                  // Captura todos os valores antes do await:
                  final nome = _nomeController.text;
                  final cnpj = _cnpjController.text;
                  final telefone =
                      _telefoneController.text.isNotEmpty
                          ? _telefoneController.text
                          : null;

                  // final estado = _estadoSelecionado!;

                  PessoaJuridica? novaPessoaJuridica =
                      await PessoaJuridicaService.inserirPessoaJuridica(
                        nome: nome,
                        cnpj: cnpj,
                        telefone: telefone,
                        endereco: _endereco, // Passa o objeto _endereco
                        pessoasFisicas: _pessoasFisicasAssociadas,
                      );

                  if (novaPessoaJuridica != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Pessoa Jurídica cadastrada com sucesso!',
                        ),
                      ),
                    );

                    Navigator.pop(context, true);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Erro ao cadastrar a Pessoa Jurídica.'),
                      ),
                    );
                  }
                },
                child: const Text('Salvar Pessoa Jurídica'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
