import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

// DatabaseHelper class untuk mengelola SQLite database
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  // Inisialisasi database
  Future<Database> get _getDatabase async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Fungsi untuk membuka atau membuat database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'dosen.db'); // Lokasi file database
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        // Membuat tabel dosen
        db.execute('''
          CREATE TABLE dosen(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nama TEXT,
            noHp TEXT,
            email TEXT,
            alamat TEXT
          )
        ''');
      },
    );
  }

  // Fungsi untuk menambahkan data dosen
  Future<void> insertDosen(Map<String, String> dosenData) async {
    final db = await _getDatabase;

    await db.insert(
      'dosen',
      {
        'nama': dosenData['nama'],
        'noHp': dosenData['noHp'],
        'email': dosenData['email'],
        'alamat': dosenData['alamat'],
      },
      conflictAlgorithm: ConflictAlgorithm.replace, // Menimpa data yang sama jika ada
    );
  }

  // Fungsi untuk mengambil semua data dosen
  Future<List<Map<String, dynamic>>> getAllDosen() async {
    final db = await _getDatabase;
    return await db.query('dosen');
  }

  // Fungsi untuk menghapus dosen berdasarkan ID
  Future<void> deleteDosen(int id) async {
    final db = await _getDatabase;
    await db.delete(
      'dosen',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Fungsi untuk mengupdate data dosen berdasarkan ID
  Future<void> updateDosen(int id, Map<String, String> updatedData) async {
    final db = await _getDatabase;
    await db.update(
      'dosen',
      {
        'nama': updatedData['nama'],
        'noHp': updatedData['noHp'],
        'email': updatedData['email'],
        'alamat': updatedData['alamat'],
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Fungsi untuk menghapus semua data dosen
  Future<void> deleteAllDosen() async {
    final db = await _getDatabase;
    await db.delete('dosen'); // Menghapus semua data dari tabel dosen
  }
}
