import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/cidade_viewmodel.dart';
import '../model/cidade.dart';

class CadastroCidadePage extends StatefulWidget {
  const CadastroCidadePage({super.key});

  @override
  State<CadastroCidadePage> createState() => _CadastroCidadePageState();
}

class _CadastroCidadePageState extends State<CadastroCidadePage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cidadeVM = Provider.of<CidadeViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Cidades')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome da Cidade'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o nome da cidade';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final novaCidade = Cidade(
                    id: cidadeVM.cidades.length + 1,
                    nomeCidade: _nomeController.text.trim(),
                  );
                  await cidadeVM.adicionarCidade(novaCidade);
                  _nomeController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cidade adicionada!')),
                  );
                }
              },
              child: const Text('Salvar Cidade'),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: cidadeVM.cidades.length,
                itemBuilder: (context, index) {
                  final cidade = cidadeVM.cidades[index];
                  return ListTile(
                    title: Text(cidade.nomeCidade),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
