import 'package:flutter/material.dart';
import '../model/cliente.dart';
import '../repository/cliente_repository.dart';

// DTO (Data Transfer Object)
class ClienteDTO {
  final int? codigo;
  final String cpf;
  final String nome;
  final String idade;
  final String dataNascimento;
  final String cidadeNascimento;
  final String subtitulo;

  ClienteDTO({
    required this.codigo,
    required this.cpf,
    required this.nome,
    required this.idade,
    required this.dataNascimento,
    required this.cidadeNascimento,
    required this.subtitulo,
  });

  // Converte Model → DTO
  factory ClienteDTO.fromModel(Cliente cliente) {
    return ClienteDTO(
      codigo: cliente.codigo,
      cpf: cliente.cpf,
      nome: cliente.nome,
      idade: cliente.idade.toString(),
      dataNascimento: cliente.dataNascimento,
      cidadeNascimento: cliente.cidadeNascimento,
      subtitulo: 'CPF: ${cliente.cpf} · ${cliente.cidadeNascimento}',
    );
  }

  // Converte DTO → Model
  Cliente toModel() {
    return Cliente(
      codigo: codigo,
      cpf: cpf,
      nome: nome,
      idade: int.tryParse(idade) ?? 0,
      dataNascimento: dataNascimento,
      cidadeNascimento: cidadeNascimento,
    );
  }
}

// ViewModel principal (MVVM)
class ClienteViewModel extends ChangeNotifier {
  final ClienteRepository _repository;
  List<Cliente> _clientes = [];
  // List<Cliente> _clientesFiltrados = []; // 👈 ADICIONE ESTA LINHA
  String _ultimoFiltro = '';

  List<ClienteDTO> get clientes =>
      _clientes.map((c) => ClienteDTO.fromModel(c)).toList();

  ClienteViewModel(this._repository) {
    loadClientes();
  }

  // 🔹 Carrega todos os clientes (com filtro opcional)
  Future<void> loadClientes([String filtro = '']) async {
    _ultimoFiltro = filtro;
    _clientes = await _repository.buscar(filtro: filtro);
    notifyListeners();
  }

  // 🔹 Adicionar cliente
  Future<void> adicionarCliente({
    required String cpf,
    required String nome,
    required String idade,
    required String dataNascimento,
    required String cidadeNascimento,
  }) async {
    final cliente = Cliente(
      cpf: cpf,
      nome: nome,
      idade: int.tryParse(idade) ?? 0,
      dataNascimento: dataNascimento,
      cidadeNascimento: cidadeNascimento,
    );

    await _repository.inserir(cliente);
    await loadClientes(_ultimoFiltro);
  }

  // 🔹 Editar cliente
  Future<void> editarCliente({
    required int codigo,
    required String cpf,
    required String nome,
    required String idade,
    required String dataNascimento,
    required String cidadeNascimento,
  }) async {
    final cliente = Cliente(
      codigo: codigo,
      cpf: cpf,
      nome: nome,
      idade: int.tryParse(idade) ?? 0,
      dataNascimento: dataNascimento,
      cidadeNascimento: cidadeNascimento,
    );

    await _repository.atualizar(cliente);
    await loadClientes(_ultimoFiltro);
  }

  // 🔹 Remover cliente por código
  Future<void> removerCliente(int codigo) async {
    await _repository.excluir(codigo);
    await loadClientes(_ultimoFiltro);
  }

  // 🔹 Buscar cliente específico pelo código
  Future<ClienteDTO?> buscarPorCodigo(int codigo) async {
    final cliente = await _repository.buscarPorCodigo(codigo);
    if (cliente != null) {
      return ClienteDTO.fromModel(cliente);
    }
    return null;
  }

  

  // 🔹 Excluir todos os clientes (limpar tabela)
  Future<void> limparLista() async {
    await _repository.excluirTodos();
    _clientes = [];
    notifyListeners();
  }



}
