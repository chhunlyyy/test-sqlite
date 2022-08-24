import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqLiteHelper {
  Future<String> getPath(String dbName) async {
    var databasesPath = await getDatabasesPath();
    return join(databasesPath, dbName);
  }

  Future<Database> createTable(String path, String rawQuery) async {
    return await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute(rawQuery);
    });
  }

  Future<void> insertRecord(Database db, String rawInsertQuery) async {
    await db.transaction((txn) async {
      await txn.rawInsert(rawInsertQuery);
    });
  }

  Future<List<Map>> getRecord(Database db, String getRecordQuery) async {
    return await db.rawQuery(getRecordQuery);
  }

  Future<void> updateRecord(Database db, String updateRawQuery) async {
    await db.rawUpdate(updateRawQuery);
  }

  Future<void> deleteRecord(Database db, String deleteRawQuery) async {
    await db.delete(deleteRawQuery);
  }

  Future<void> closeDatabase(Database db) async {
    await db.close();
  }
}
