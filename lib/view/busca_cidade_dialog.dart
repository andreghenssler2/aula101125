import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/cidade.dart';
import '../viewmodel/cidade_viewmodel.dart';

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
      content: Column(
        mainAxisSize: MainAxisSize.min,
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
              shrinkWrap: true,
              itemCount: cidadesFiltradas.length,
              itemBuilder: (context, index) {
                final cidade = cidadesFiltradas[index];
                return ListTile(
                  title: Text(cidade.nomeCidade),
                  onTap: () => Navigator.pop(context, cidade),
                );
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Fechar'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
