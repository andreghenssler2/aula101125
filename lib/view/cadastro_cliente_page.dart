import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/cliente_viewmodel.dart';
import '../viewmodel/cidade_viewmodel.dart';
import '../model/cidade.dart';

class CadastroClientePage extends StatefulWidget {
  const CadastroClientePage({super.key});

  @override
  State<CadastroClientePage> createState() => _CadastroClientePageState();
}

class _CadastroClientePageState extends State<CadastroClientePage> {
  final _cpfController = TextEditingController();
  final _nomeController = TextEditingController();
  final _idadeController = TextEditingController();
  final _dataNascimentoController = TextEditingController();
  final _cidadeController = TextEditingController();

  Cidade? cidadeSelecionada;

  @override
  void dispose() {
    _cpfController.dispose();
    _nomeController.dispose();
    _idadeController.dispose();
    _dataNascimentoController.dispose();
    _cidadeController.dispose();
    super.dispose();
  }

  void _abrirPopupBuscaCidade(BuildContext context) async {
    final cidadeViewModel = Provider.of<CidadeViewModel>(context, listen: false);
    final TextEditingController filtroController = TextEditingController();
    List<Cidade> listaFiltrada = cidadeViewModel.cidades;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          void filtrarCidades(String filtro) {
            setStateDialog(() {
              listaFiltrada = cidadeViewModel.cidades
                  .where((c) =>
                      c.nomeCidade.toLowerCase().contains(filtro.toLowerCase()))
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
                  onChanged: filtrarCidades,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 200,
                  width: double.maxFinite,
                  child: ListView.builder(
                    itemCount: listaFiltrada.length,
                    itemBuilder: (context, index) {
                      final cidade = listaFiltrada[index];
                      return ListTile(
                        title: Text(cidade.nomeCidade),
                        trailing: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context, cidade);
                          },
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
    ).then((resultado) {
      if (resultado != null && resultado is Cidade) {
        setState(() {
          cidadeSelecionada = resultado;
          _cidadeController.text = resultado.nomeCidade;
        });
      }
    });
  }

  void _salvarCliente() {
    final clienteViewModel =
        Provider.of<ClienteViewModel>(context, listen: false);

    clienteViewModel.adicionarCliente(
      cpf: _cpfController.text,
      nome: _nomeController.text,
      idade: _idadeController.text,
      dataNascimento: _dataNascimentoController.text,
      cidadeNascimento: _cidadeController.text,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cliente salvo com sucesso!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final cidadeViewModel = Provider.of<CidadeViewModel>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Cliente')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _cpfController,
              decoration: const InputDecoration(labelText: 'CPF'),
            ),
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _idadeController,
              decoration: const InputDecoration(labelText: 'Idade'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _dataNascimentoController,
              decoration:
                  const InputDecoration(labelText: 'Data de Nascimento'),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _salvarCliente,
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
