import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/cliente_viewmodel.dart';
import '../viewmodel/cidade_viewmodel.dart';
import '../model/cliente.dart';
import '../model/cidade.dart';
import 'busca_cidade_dialog.dart';

class CadastroClientePage extends StatefulWidget {
  final Cliente? cliente;
  const CadastroClientePage({super.key, this.cliente});

  @override
  State<CadastroClientePage> createState() => _CadastroClientePageState();
}

class _CadastroClientePageState extends State<CadastroClientePage> {
  final _formKey = GlobalKey<FormState>();

  final _cpfController = TextEditingController();
  final _nomeController = TextEditingController();
  final _idadeController = TextEditingController();
  final _dataNascController = TextEditingController();
  final _cidadeController = TextEditingController();

  late Cliente _cliente;

  @override
  void initState() {
    super.initState();

    // Inicializa cliente (novo ou existente)
    _cliente = widget.cliente ??
        Cliente(
          cpf: '',
          nome: '',
          idade: 0,
          dataNascimento: '',
          cidadeNascimento: '',
        );

    // Preenche campos se for edição
    if (widget.cliente != null) {
      _cpfController.text = _cliente.cpf;
      _nomeController.text = _cliente.nome;
      _idadeController.text = _cliente.idade.toString();
      _dataNascController.text = _cliente.dataNascimento;
      _cidadeController.text = _cliente.cidadeNascimento;
    }

    // Carrega as cidades do banco para o popup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CidadeViewModel>().carregarCidades();
    });
  }

  @override
  void dispose() {
    _cpfController.dispose();
    _nomeController.dispose();
    _idadeController.dispose();
    _dataNascController.dispose();
    _cidadeController.dispose();
    super.dispose();
  }

  void _salvar() async {
    if (_formKey.currentState!.validate()) {
      final cliente = Cliente(
        codigo: _cliente.codigo,
        cpf: _cpfController.text,
        nome: _nomeController.text,
        idade: int.tryParse(_idadeController.text) ?? 0,
        dataNascimento: _dataNascController.text,
        cidadeNascimento: _cidadeController.text,
      );

      final clienteVM = context.read<ClienteViewModel>();

      if (widget.cliente == null) {
        // Novo cliente
        await clienteVM.adicionarCliente(
          cpf: cliente.cpf,
          nome: cliente.nome,
          idade: cliente.idade.toString(),
          dataNascimento: cliente.dataNascimento,
          cidadeNascimento: cliente.cidadeNascimento,
        );
      } else {
        // Edição de cliente existente
        await clienteVM.editarCliente(
          codigo: cliente.codigo!,
          cpf: cliente.cpf,
          nome: cliente.nome,
          idade: cliente.idade.toString(),
          dataNascimento: cliente.dataNascimento,
          cidadeNascimento: cliente.cidadeNascimento,
        );
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cliente == null ? 'Novo Cliente' : 'Editar Cliente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _cpfController,
                decoration: const InputDecoration(labelText: 'CPF'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o CPF' : null,
              ),
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o nome' : null,
              ),
              TextFormField(
                controller: _idadeController,
                decoration: const InputDecoration(labelText: 'Idade'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _dataNascController,
                decoration:
                    const InputDecoration(labelText: 'Data de Nascimento'),
              ),
              const SizedBox(height: 16),

              // Campo de cidade + botão de busca (popup)
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cidadeController,
                      decoration: const InputDecoration(
                        labelText: 'Cidade de Nascimento',
                      ),
                      readOnly: true,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () async {
                      final cidadeSelecionada = await showDialog<Cidade>(
                        context: context,
                        builder: (_) => const BuscaCidadeDialog(),
                      );

                      if (cidadeSelecionada != null) {
                        setState(() {
                          _cidadeController.text =
                              cidadeSelecionada.nomeCidade;
                          _cliente.cidadeNascimento =
                              cidadeSelecionada.nomeCidade;
                        });
                      }
                    },
                  ),
                ],
              ),

              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _salvar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Salvar',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
