import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/cidade_viewmodel.dart';
import '../model/cidade.dart';

class BuscaCidadeDialog extends StatefulWidget {
  const BuscaCidadeDialog({super.key});

  @override
  State<BuscaCidadeDialog> createState() => _BuscaCidadeDialogState();
}

class _BuscaCidadeDialogState extends State<BuscaCidadeDialog> {
  String filtro = '';

  @override
  Widget build(BuildContext context) {
    final cidadeVM = context.watch<CidadeViewModel>();
    final cidadesFiltradas = cidadeVM.filtrar(filtro);

    return AlertDialog(
      title: const Text('Buscar Cidade'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Digite o nome da cidade',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => setState(() => filtro = value),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: cidadesFiltradas.length,
                itemBuilder: (context, index) {
                  final cidade = cidadesFiltradas[index];
                  return ListTile(
                    title: Text(cidade.nomeCidade),
                    trailing: TextButton(
                      child: const Text('Selecionar'),
                      onPressed: () => Navigator.pop(context, cidade),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Fechar'),
        ),
      ],
    );
  }
}
