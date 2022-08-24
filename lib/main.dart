import 'package:flutter/material.dart';
import 'package:test_sqlite/sqlite_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void _init() {
    SqLiteHelper sqLiteHelper = SqLiteHelper();
    const String dbName = 'demo.db';
    const String creatTableQuery = 'CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)';
    const String insertValueQuery = 'INSERT INTO Test(name, value, num) VALUES("some name", 1234, 456.789)';
    const String getValueQuery = 'SELECT * FROM Test';

    Future.delayed(Duration.zero, () async {
      // insert data
      try {
        await sqLiteHelper.createTable(dbName, creatTableQuery).then((db) async {
          await sqLiteHelper.insertRecord(db, insertValueQuery);
        });
      } catch (e) {
        print(e);
      }

      // get data

      try {
        String path = await sqLiteHelper.getPath(dbName);

        await sqLiteHelper.openDb(path).then((db) async {
          await sqLiteHelper.getRecord(db, getValueQuery).then((value) {
            print(value);
            sqLiteHelper.closeDatabase(db);
          });
        });
      } catch (e) {
        print(e);
      }
    });
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: Container()));
  }
}
