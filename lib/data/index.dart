import 'dart:io' if (dart.library.html) 'dart:html';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sembast_web/sembast_web.dart';
import 'package:simple_app/model/note.dart';
import 'package:sembast/sembast.dart';
// import 'package:sembast/sembast_io.dart'
//     if (dart.library.html) 'package:sembast_web/sembast_web.dart';
import 'package:sembast/sembast_io.dart';

// if (dart.library.html) 'package:sembast_web/sembast_web.dart';
class DBProvider {
  static final DBProvider _singleton = DBProvider._internal();

  factory DBProvider() {
    return _singleton;
  }

  DBProvider._internal();

  Database? _dbInstance;
  final _store = intMapStoreFactory.store('NoteList');

  // 获取db 实例对象 操作数据库
  Future<Database> get db async {
    if (_dbInstance != null) {
      return _dbInstance!;
    }
    _dbInstance = await _initDB();
    return _dbInstance!;
  }

  // 初始化数据库
  Future<Database> _initDB() async {
    DatabaseFactory dbFactory;
    String dbPath;
    if (!kIsWeb) {
      var dir = await getApplicationDocumentsDirectory();
      await dir.create(recursive: true);
      dbPath = p.join(dir.path, 'NoteList.db');
      dbFactory = databaseFactoryIo;
    } else {
      dbPath = 'NoteList.db';
      dbFactory = databaseFactoryWeb;
    }
    return await dbFactory.openDatabase(dbPath);
  }

  // 保存储存数据
  Future<int> saveData(Note note) async {
    final db = await this.db;
    return await _store.add(db, note.toJson());
  }

  // 查询所有数据
  Future<List<Note>> findAll() async {
    final db = await this.db;
    final records = await _store.find(db);
    return records.map((record) {
      return Note.fromJson(record.value, record.key);
    }).toList();
  }

  // 根据id 查询数据
  Future<Note?> findNoteById(int id) async {
    final db = await this.db;
    final record = await _store.record(id).get(db);
    if (record != null) {
      return Note.fromJson(record, id);
    }
    return null;
  }

  // 根据 note id 更新数据
  Future<int> update(Note note) async {
    final db = await this.db;
    final finder = Finder(filter: Filter.byKey(note.id));
    return await _store.update(db, note.toJson(), finder: finder);
  }

  // 根据 note id 删除数据
  Future<int> deleteData(int id) async {
    final db = await this.db;
    final finder = Finder(filter: Filter.byKey(id));
    return await _store.delete(db, finder: finder);
  }

  // 根据 note id 批量删除数据
  Future<int> deleteByIds(List<int> ids) async {
    final db = await this.db;
    final finder = Finder(filter: Filter.inList('id', ids));
    return await _store.delete(db, finder: finder);
  }

  // 根据标题 模糊查询
  Future<List<Note>> findTitleNoteList(String title) async {
    final db = await this.db;
    final finder = Finder(
      filter: Filter.or([
        Filter.matches('title', title),
        Filter.matches('content', title),
      ]),
    );
    final records = await _store.find(db, finder: finder);
    return records.map((record) {
      return Note.fromJson(record.value, record.key);
    }).toList();
  }
}
