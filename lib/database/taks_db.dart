import 'package:sqflite/sqflite.dart';

import '../models/task.dart';

class TaskDB {
  late Database _database;
  final String kTableName = 'tasks';
  final String kId = 'id';
  final String kTask = 'task';
  final String kIsDone = 'isDone';

  Future _openDB() async {
    _database = await openDatabase(
      'todolist.db',
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE $kTableName($kId INTEGER PRIMARY KEY AUTOINCREMENT, $kTask TEXT, $kIsDone INTEGER)');
      },
      version: 1,
    );
  }

  Future insert(Task task) async {
    await _openDB();
    await _database.insert(kTableName, task.toMap());
  }

  Future update(Task task) async {
    await _openDB();
    await _database.update(kTableName, task.toMap(),
        where: '$kId = ?', whereArgs: [task.id]);
  }

  Future delete(int id) async {
    await _openDB();
    await _database.delete(kTableName, where: '$kId = ?', whereArgs: [id]);
  }

  Future<List<Task>> getTasks() async {
    await _openDB();
    List<Map<String, dynamic>> maps = await _database.query(kTableName);
    return List.generate(
        maps.length,
        (i) => Task(
              id: maps[i][kId],
              task: maps[i][kTask],
              isDone: maps[i][kIsDone] == 0 ? false : true,
            ));
  }
}
