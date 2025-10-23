import 'package:flutter/material.dart';
import '../model/cidade.dart';
import '../repository/cidade_repository.dart';

class CidadeViewModel extends ChangeNotifier {
  final CidadeRepository _repository = CidadeRepository();

  List<Cidade> _cidades = [];
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
      _cidades = await _repository.getAll();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Erro ao carregar cidades: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Adiciona uma nova cidade
  Future<void> adicionarCidade(Cidade cidade) async {
    try {
      await _repository.insert(cidade);
      await carregarCidades(); // atualiza a lista
    } catch (e) {
      _errorMessage = 'Erro ao adicionar cidade: $e';
      notifyListeners();
    }
  }

  /// Atualiza uma cidade existente
  Future<void> atualizarCidade(Cidade cidade) async {
    try {
      await _repository.update(cidade);
      await carregarCidades();
    } catch (e) {
      _errorMessage = 'Erro ao atualizar cidade: $e';
      notifyListeners();
    }
  }

  /// Exclui uma cidade pelo ID
  Future<void> excluirCidade(int id) async {
    try {
      await _repository.delete(id);
      await carregarCidades();
    } catch (e) {
      _errorMessage = 'Erro ao excluir cidade: $e';
      notifyListeners();
    }
  }

  /// Busca cidades por nome (filtro)
  Future<void> buscarPorNome(String nome) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (nome.trim().isEmpty) {
        await carregarCidades();
      } else {
        _cidades = await _repository.searchByName(nome);
      }
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Erro ao buscar cidades: $e';
    }

    _isLoading = false;
    notifyListeners();
  }
}
