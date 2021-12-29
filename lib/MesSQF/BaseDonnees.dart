import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqfliteDatabaseHelper {

  SqfliteDatabaseHelper.internal();
  static final SqfliteDatabaseHelper instance = new SqfliteDatabaseHelper.internal();
  factory SqfliteDatabaseHelper() => instance;

  static final TableItem = 'TableItem';
  static final TableClient = 'TableClient';
  static final _version =1;

  static Database _db;

  Future<Database> get db async {
    if (_db !=null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  Future<Database> initDb()async{
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path,'syncdatabase.db');
    print(dbPath);
    var openDb = await openDatabase(dbPath,version:_version,
        onCreate: (Database db,int version)async{
          await db.execute("""
          CREATE TABLE $TableItem(
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        id_b6 INTEGER, 
        id_b12 INTEGER, 
        Qtiteb6 INTEGER, 
        Qtiteb12 INTEGER, 
        user_id INTEGER, 
        contact_id INTEGER, 
        amount INTEGER, 
        final_total INTEGER)""");

          await db.execute("""
          CREATE TABLE $TableClient(
        id INTEGER,
        name TEXT,
        mobile TEXT)""");
        },
        onUpgrade: (Database db, int oldversion,int newversion)async{
          if (oldversion<newversion) {
            print("Version Upgrade");
          }
        }
    );
    print('db initialize');
    return openDb;
  }

  Future<int> deleteData(int id) async {
    var dbclient = await instance.db;
     return await dbclient.delete(TableItem, where: '$id=?',whereArgs: [id]);
  }
  Future<int> deleteClient(int id) async {
    var dbclients = await instance.db;
     return await dbclients.delete(TableClient, where: '$id=?',whereArgs: [id]);
  }




}