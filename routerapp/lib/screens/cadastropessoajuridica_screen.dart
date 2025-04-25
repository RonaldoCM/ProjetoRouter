import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CadastroPessoaJuridicaScreen extends StatefulWidget {
  const CadastroPessoaJuridicaScreen({super.key});

  @override
  State<CadastroPessoaJuridicaScreen> createState() =>
      _CadastroPessoaJuridicaScreenState();
}

class _CadastroPessoaJuridicaScreenState
    extends State<CadastroPessoaJuridicaScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codigoController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cnpjController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();

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
              /*               const SizedBox(height: 16),
              TextFormField(
                controller: _codigoController,
                decoration: const InputDecoration(
                  labelText: 'Código',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite o código.';
                  }
                  return null;
                },
              ), */
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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    //String codigo = _codigoController.text;
                    String nome = _nomeController.text;
                    String cnpjComMascara = _cnpjController.text;
                    String cnpjSemMascara = _cnpjFormatter.getUnmaskedText();
                    String? telefoneComMascara =
                        _telefoneController.text.isNotEmpty
                            ? _telefoneController.text
                            : null;
                    String? telefoneSemMascara =
                        _telefoneFormatter.getUnmaskedText();

                    /*                     print(
                      'Código: $codigo, Nome: $nome, CNPJ (com máscara): $cnpjComMascara, CNPJ (sem máscara): $cnpjSemMascara, Telefone (com máscara): $telefoneComMascara, Telefone (sem máscara): $telefoneSemMascara',
                    ); */
                    // Lógica para salvar a pessoa jurídica
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

  @override
  void dispose() {
    _codigoController.dispose();
    _nomeController.dispose();
    _cnpjController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }
}
