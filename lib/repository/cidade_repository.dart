import 'package:sqflite/sqflite.dart';
import '../db/db_helper.dart';
import '../model/cidade.dart';

class CidadeRepository {
  final dbHelper = DatabaseHelper.instance;

  /// Insere uma nova cidade no banco
  Future<int> insert(Cidade cidade) async {
    final db = await dbHelper.database;
    return await db.insert('cidade', cidade.toMap());
  }

  /// Atualiza uma cidade existente
  Future<int> update(Cidade cidade) async {
    final db = await dbHelper.database;
    return await db.update(
      'cidade',
      cidade.toMap(),
      where: 'id = ?',
      whereArgs: [cidade.id],
    );
  }

  /// Remove uma cidade pelo ID
  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'cidade',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Retorna todas as cidades ordenadas por nome
  Future<List<Cidade>> getAll() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps =
        await db.query('cidade', orderBy: 'nomeCidade');
    return List.generate(maps.length, (i) => Cidade.fromMap(maps[i]));
  }

  /// Busca cidades pelo nome (filtro)
  Future<List<Cidade>> searchByName(String nome) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'cidade',
      where: 'nomeCidade LIKE ?',
      whereArgs: ['%$nome%'],
      orderBy: 'nomeCidade',
    );
    return List.generate(maps.length, (i) => Cidade.fromMap(maps[i]));
  }

  /// Busca uma cidade específica por ID
  Future<Cidade?> getById(int id) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'cidade',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Cidade.fromMap(maps.first);
    }
    return null;
  }
}
