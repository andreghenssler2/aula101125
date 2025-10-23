import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/cidade.dart';
import '../viewmodel/cidade_viewmodel.dart';

class CadastroCidadePage extends StatefulWidget {
  final Cidade? cidade; // se for null => novo cadastro
  const CadastroCidadePage({super.key, this.cidade});

  @override
  State<CadastroCidadePage> createState() => _CadastroCidadePageState();
}

class _CadastroCidadePageState extends State<CadastroCidadePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.cidade != null) {
      _nomeController.text = widget.cidade!.nomeCidade;
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
      if (_formKey.currentState!.validate()) {
      final viewModel = context.read<CidadeViewModel>();

      final novaCidade = Cidade(
        id: widget.cidade?.id,
        nomeCidade: _nomeController.text.trim(),
      );

      if (widget.cidade == null) {
        await viewModel.adicionarCidade(novaCidade);
      } else {
        await viewModel.atualizarCidade(novaCidade);
      }

      // ✅ Recarrega as cidades para atualizar o diálogo de busca
      await viewModel.carregarCidades();

      if (mounted) {
        Navigator.pop(context); // volta para a tela anterior
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditando = widget.cidade != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditando ? 'Editar Cidade' : 'Cadastrar Cidade'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome da Cidade',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o nome da cidade';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _salvar,
                icon: const Icon(Icons.save),
                label: Text(isEditando ? 'Atualizar' : 'Cadastrar'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
