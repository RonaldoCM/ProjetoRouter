// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:routerapp/models/pessoafisica.dart';

class CadastroPessoaFisicaScreen extends StatefulWidget {
  const CadastroPessoaFisicaScreen({super.key});

  @override
  State<CadastroPessoaFisicaScreen> createState() =>
      _CadastroPessoaFisicaScreenState();
}

class _CadastroPessoaFisicaScreenState
    extends State<CadastroPessoaFisicaScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();

  final _cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final _telefoneFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Colaboradores')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Dados do colaborador',
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
                controller: _cpfController,
                decoration: const InputDecoration(
                  labelText: 'CPF',
                  border: OutlineInputBorder(),
                ),
                inputFormatters: [_cpfFormatter],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite o CPF.';
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
                  if (!_formKey.currentState!.validate()) {
                    return; // valida primeiro
                  }

                  // Captura todos os valores antes do await:
                  final id = null;
                  final nome = _nomeController.text;
                  final cpf = _cpfController.text;
                  final telefone =
                      _telefoneController.text.isNotEmpty
                          ? _telefoneController.text
                          : null;

                  final novaPessoaFisica = PessoaFisica(
                    id: id,
                    nome: nome,
                    cpf: cpf,
                    telefone: telefone,
                  );

                  // Retorna o objeto PessoaFisica para a tela anterior
                  Navigator.pop(context, novaPessoaFisica);
                },
                child: const Text('Adicionar colaborador'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
