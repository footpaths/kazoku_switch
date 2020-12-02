import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/registerData.dart';

class DatabaseHelper {
  //Create a private constructor
  DatabaseHelper._();

  static const databaseName = 'register_database.db';
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database _database;

  Future<Database> get database async {
    if (_database == null) {
      return await initializeDatabase();
    }
    return _database;
  }

  initializeDatabase() async {
    return await openDatabase(join(await getDatabasesPath(), databaseName),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE register(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, dob TEXT,phone TEXT,phone2 TEXT,address TEXT,note TEXT,listHP TEXT, listca TEXT,listcolor TEXT,time TEXT)");
    });
  }

  insertDataStudent(RegisterData registerData) async {
    final db = await database;
    var res = await db.insert(RegisterData.TABLENAME, registerData.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

  Future<List<RegisterData>> retrieveDataStudent() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(RegisterData.TABLENAME);

    return List.generate(maps.length, (i) {
      return RegisterData(
        id: maps[i]['id'],
        dob: maps[i]['dob'],
        name: maps[i]['name'],
        phone: maps[i]['phone'],
        phone2: maps[i]['phone2'],
        address: maps[i]['address'],
        note: maps[i]['note'],
        listHP: maps[i]['listHP'],
        listca: maps[i]['listca'],
        listcolor: maps[i]['listcolor'],
        time: maps[i]['time'],
      );
    });
  }

  updateStudent(RegisterData registerData) async {
    final db = await database;

    await db.update(RegisterData.TABLENAME, registerData.toMap(),
        where: 'id = ?',
        whereArgs: [registerData.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  deleteStudent(int id) async {
    var db = await database;
    db.delete(RegisterData.TABLENAME, where: 'id = ?', whereArgs: [id]);
  }
}
