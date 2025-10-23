import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/cidade_viewmodel.dart';
import '../model/cidade.dart';
import 'cadastro_cidade_page.dart'; // tela de cadastro

class ListaCidadePage extends StatefulWidget {
  const ListaCidadePage({super.key});

  @override
  State<ListaCidadePage> createState() => _ListaCidadePageState();
}

class _ListaCidadePageState extends State<ListaCidadePage> {
  final TextEditingController _filtroController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Carrega cidades ao abrir a tela
    Future.microtask(() =>
        Provider.of<CidadeViewModel>(context, listen: false).carregarCidades());
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CidadeViewModel>();
    final cidades = _filtroController.text.isEmpty
        ? viewModel.cidades
        : viewModel.filtrar(_filtroController.text);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Cidades'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _filtroController,
              decoration: InputDecoration(
                labelText: 'Buscar cidade',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _filtroController.clear();
                    setState(() {});
                  },
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: viewModel.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : cidades.isEmpty
                      ? const Center(child: Text('Nenhuma cidade cadastrada'))
                      : ListView.builder(
                          itemCount: cidades.length,
                          itemBuilder: (context, index) {
                            final cidade = cidades[index];
                            return ListTile(
                              title: Text(cidade.nomeCidade),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  await viewModel.excluirCidade(cidade.id!);
                                },
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // abre tela de cadastro
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CadastroCidadePage(),
            ),
          );
          // recarrega lista ao voltar
          viewModel.carregarCidades();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
