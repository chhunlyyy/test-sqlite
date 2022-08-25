import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqLiteHelper {
  Future<String> getPath(String dbName) async {
    var databasesPath = await getDatabasesPath();
    return join(databasesPath, dbName);
  }

  Future<Database> openDb(String path) async {
    return await openDatabase(path).then((database) => database);
  }

  Future<void> createTable(String path, String rawQuery) async {
    await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute(rawQuery);
    });
  }

  Future<void> insertRecord(String path, String rawInsertQuery) async {
    await openDb(path).then((db) async {
      await db.transaction((txn) async {
        await txn.rawInsert(rawInsertQuery);
      });
    });
  }

  Future<List<Map>> getRecord(String path, String getRecordQuery) async {
    return await openDb(path).then((db) async {
      return await db.rawQuery(getRecordQuery);
    });
  }

  Future<void> updateRecord(String path, String updateRawQuery) async {
    await openDb(path).then((db) async {
      await db.rawUpdate(updateRawQuery);
    });
  }

  Future<void> deleteRecord(String path, String deleteRawQuery) async {
    await openDb(path).then((db) async {
      await db.delete(deleteRawQuery);
    });
  }

  Future<void> closeDatabase(String path) async {
    await openDb(path).then((db) async {
      await db.close();
    });
  }
}
