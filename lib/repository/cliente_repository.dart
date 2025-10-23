import '../model/cliente.dart';
import '../db/db_helper.dart';

abstract class IClienteRepository {
  Future<int> inserir(Cliente cliente);
  Future<int> atualizar(Cliente cliente);
  Future<int> excluir(int codigo);
  Future<List<Cliente>> buscar({String filtro = ''});

  // 🔹 Novos métodos
  Future<Cliente?> buscarPorCodigo(int codigo);
  Future<void> excluirTodos();
}

class ClienteRepository implements IClienteRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  Future<int> inserir(Cliente cliente) async {
    final db = await _dbHelper.database;
    return await db.insert('clientes', cliente.toMap());
  }

  @override
  Future<int> atualizar(Cliente cliente) async {
    final db = await _dbHelper.database;
    return await db.update(
      'clientes',
      cliente.toMap(),
      where: 'codigo = ?',
      whereArgs: [cliente.codigo],
    );
  }

  @override
  Future<int> excluir(int codigo) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'clientes',
      where: 'codigo = ?',
      whereArgs: [codigo],
    );
  }

  @override
  Future<List<Cliente>> buscar({String filtro = ''}) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = filtro.isEmpty
        ? await db.query('clientes', orderBy: 'nome')
        : await db.query(
            'clientes',
            where: 'nome LIKE ?',
            whereArgs: ['%$filtro%'],
            orderBy: 'nome',
          );
    return maps.map((m) => Cliente.fromMap(m)).toList();
  }

  // 🔹 Novo método: buscar cliente por código
  @override
  Future<Cliente?> buscarPorCodigo(int codigo) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'clientes',
      where: 'codigo = ?',
      whereArgs: [codigo],
    );

    if (maps.isNotEmpty) {
      return Cliente.fromMap(maps.first);
    }
    return null;
  }

  // 🔹 Novo método: excluir todos os clientes
  @override
  Future<void> excluirTodos() async {
    final db = await _dbHelper.database;
    await db.delete('clientes');
  }
}
