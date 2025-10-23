import 'package:flutter/material.dart';
import '../model/cidade.dart';
import '../repository/cidade_repository.dart';

class CidadeViewModel extends ChangeNotifier {
  final CidadeRepository _repository = CidadeRepository();

  List<Cidade> _cidades = [];
  List<Cidade> _todasCidades = [];
  List<Cidade> get cidades => _cidades;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Carrega todas as cidades do banco
  Future<void> carregarCidades() async {
    _isLoading = true;
    notifyListeners();

    try {
      _todasCidades = await _repository.getAll();
      _cidades = List.from(_todasCidades);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Erro ao carregar cidades: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  /// 🔍 Filtrar cidades localmente (sem acessar o banco)
  List<Cidade> filtrar(String filtro) {
    return _todasCidades
        .where((c) => c.nomeCidade.toLowerCase().contains(filtro.toLowerCase()))
        .toList();
  }

  /// Adiciona uma nova cidade
  Future<void> adicionarCidade(Cidade cidade) async {
    try {
      await _repository.insert(cidade);
      await carregarCidades(); // atualiza a lista
    } catch (e) {
      _errorMessage = 'Erro ao adicionar cidade: $e';
    }
    notifyListeners();
  }

  /// Atualiza uma cidade existente
  Future<void> atualizarCidade(Cidade cidade) async {
    try {
      await _repository.update(cidade);
      await carregarCidades();
    } catch (e) {
      _errorMessage = 'Erro ao atualizar cidade: $e';
    }
    notifyListeners();
  }

  /// Exclui uma cidade pelo ID
  Future<void> excluirCidade(int id) async {
    try {
      await _repository.delete(id);
      await carregarCidades();
    } catch (e) {
      _errorMessage = 'Erro ao excluir cidade: $e';
    }
    notifyListeners();
  }
}
