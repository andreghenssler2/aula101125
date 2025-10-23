import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/cliente_viewmodel.dart';
import '../viewmodel/cidade_viewmodel.dart';
import '../model/cidade.dart';
import '../viewmodel/cliente_viewmodel.dart';

class CadastroClientePage extends StatefulWidget {
  final ClienteDTO? clienteDTO;
  const CadastroClientePage({super.key, this.clienteDTO});

  @override
  State<CadastroClientePage> createState() => _CadastroClientePageState();
}

class _CadastroClientePageState extends State<CadastroClientePage> {
  final _formKey = GlobalKey<FormState>();
  final _cpfController = TextEditingController();
  final _nomeController = TextEditingController();
  final _idadeController = TextEditingController();
  final _dataNascimentoController = TextEditingController();
  final _cidadeController = TextEditingController();

  Cidade? cidadeSelecionada;

  @override
  void initState() {
    super.initState();

    // Carrega as cidades
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CidadeViewModel>().carregarCidades();
    });

    // Se for edição, preencher os campos
    if (widget.clienteDTO != null) {
      final cliente = widget.clienteDTO!;
      _cpfController.text = cliente.cpf;
      _nomeController.text = cliente.nome;
      _idadeController.text = cliente.idade;
      _dataNascimentoController.text = cliente.dataNascimento;
      _cidadeController.text = cliente.cidadeNascimento;
    }
  }

  @override
  void dispose() {
    _cpfController.dispose();
    _nomeController.dispose();
    _idadeController.dispose();
    _dataNascimentoController.dispose();
    _cidadeController.dispose();
    super.dispose();
  }

  Future<void> _abrirPopupBuscaCidade(BuildContext context) async {
    final cidadeViewModel = context.read<CidadeViewModel>();
    final TextEditingController filtroController = TextEditingController();
    List<Cidade> listaFiltrada = cidadeViewModel.cidades;

    final Cidade? resultado = await showDialog<Cidade>(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          void filtrar(String texto) {
            setStateDialog(() {
              listaFiltrada = cidadeViewModel.cidades
                  .where((c) => c.nomeCidade
                      .toLowerCase()
                      .contains(texto.toLowerCase()))
                  .toList();
            });
          }

          return AlertDialog(
            title: const Text('Buscar Cidade'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: filtroController,
                  decoration: const InputDecoration(
                    labelText: 'Digite o nome da cidade',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: filtrar,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 250,
                  width: double.maxFinite,
                  child: ListView.builder(
                    itemCount: listaFiltrada.length,
                    itemBuilder: (context, index) {
                      final cidade = listaFiltrada[index];
                      return ListTile(
                        title: Text(cidade.nomeCidade),
                        trailing: ElevatedButton(
                          onPressed: () => Navigator.pop(context, cidade),
                          child: const Text('Selecionar'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Fechar'),
              ),
            ],
          );
        });
      },
    );

    if (resultado != null) {
      setState(() {
        cidadeSelecionada = resultado;
        _cidadeController.text = resultado.nomeCidade;
      });
    }
  }

  void _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final clienteVM = context.read<ClienteViewModel>();

    if (widget.clienteDTO == null) {
      // Novo cliente
      await clienteVM.adicionarCliente(
        cpf: _cpfController.text,
        nome: _nomeController.text,
        idade: _idadeController.text,
        dataNascimento: _dataNascimentoController.text,
        cidadeNascimento: _cidadeController.text,
      );
    } else {
      // Edição de cliente
      await clienteVM.editarCliente(
        codigo: widget.clienteDTO!.codigo!,
        cpf: _cpfController.text,
        nome: _nomeController.text,
        idade: _idadeController.text,
        dataNascimento: _dataNascimentoController.text,
        cidadeNascimento: _cidadeController.text,
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cliente salvo com sucesso!')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.clienteDTO == null
            ? 'Novo Cliente'
            : 'Editar Cliente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _cpfController,
                decoration: const InputDecoration(labelText: 'CPF'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe o CPF' : null,
              ),
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe o nome' : null,
              ),
              TextFormField(
                controller: _idadeController,
                decoration: const InputDecoration(labelText: 'Idade'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _dataNascimentoController,
                decoration:
                    const InputDecoration(labelText: 'Data de Nascimento'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cidadeController,
                      decoration: const InputDecoration(
                          labelText: 'Cidade de Nascimento'),
                      enabled: false,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => _abrirPopupBuscaCidade(context),
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
