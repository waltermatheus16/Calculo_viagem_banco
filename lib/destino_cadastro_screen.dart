import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'viagem.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE carros(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            autonomia REAL
          )
        ''');
        await db.execute('''
          CREATE TABLE destinos(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            distancia REAL
          )
        ''');
        await db.execute('''
          CREATE TABLE combustiveis(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            tipo TEXT,
            preco REAL,
            data TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertCarro(Map<String, dynamic> carro) async {
    final db = await database;
    await db.insert('carros', carro);
  }

  Future<List<Map<String, dynamic>>> getCarros() async {
    final db = await database;
    return await db.query('carros');
  }

  Future<void> insertDestino(Map<String, dynamic> destino) async {
    final db = await database;
    await db.insert('destinos', destino);
  }

  Future<List<Map<String, dynamic>>> getDestinos() async {
    final db = await database;
    return await db.query('destinos');
  }

  Future<void> deleteDestinoByName(String nome) async {
    final db = await database;
    await db.delete(
      'destinos',
      where: 'nome = ?',
      whereArgs: [nome],
    );
  }
}
