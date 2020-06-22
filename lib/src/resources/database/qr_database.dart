import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_qr_reader/src/resources/models/scan_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class QRDataBase {
  static const String DATA_BASE_FILE = "qr_scan.db";
  static const int DATA_BASE_VERSION = 1;
  final String SCAN_TABLE_NAME = "scans";

  Database db;
  static final QRDataBase _instance = QRDataBase._();

  QRDataBase._() {
    _initDB();
  }

  static QRDataBase get instance => _instance;

  _initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    String dbPath = join(documentsDirectory.path, DATA_BASE_FILE);

    db = await openDatabase(
      dbPath,
      version: DATA_BASE_VERSION,
      onCreate: (db, version) => {_createDataBase(db, version)},
    );
    print("Init DB ${db.toString()}");
  }

  void _createDataBase(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $SCAN_TABLE_NAME ( id INTEGER PRIMARY KEY AUTOINCREMENT, type TEXT NOT NULL, value TEXT NOT NULL )");
  }

  Future<int> insert({@required String type, @required String value}) async {
    if (!_isDbOpen()) {
      await _initDB();
    }

    return db.rawInsert(
        "INSERT INTO $SCAN_TABLE_NAME (type, value) VALUES (?, ?)",
        [type, value]);
  }

  Future<int> update(
      {@required int id, @required String type, @required String value}) async {
    if (!_isDbOpen()) {
      await _initDB();
    }
    return db.rawUpdate(
        "UPDATE $SCAN_TABLE_NAME SET (id =?, type= ?, value= ? WHERE id =?",
        [id, type, value, id]);
  }

  Future<List<Map<String, dynamic>>> getScans() async {
    if (!_isDbOpen()) {
      await _initDB();
    }
    return db.rawQuery("SELECT * FROM $SCAN_TABLE_NAME");
  }

  Future<List<Map<String, dynamic>>> getScanByType(String type) async {
    if (!_isDbOpen()) {
      await _initDB();
    }
    return db.rawQuery("SELECT * FROM $SCAN_TABLE_NAME WHERE type = ?", [type]);
  }

  Future<List<Map<String, dynamic>>> getScanById({@required int id}) async {
    if (!_isDbOpen()) {
      await _initDB();
    }
    return db.rawQuery("SELECT * FROM $SCAN_TABLE_NAME WHERE id =  ?", [id]);
  }

  Future<int> deleteById({@required int id}) async {
    if (!_isDbOpen()) {
      await _initDB();
    }
    return db.rawDelete("DELETE FROM $SCAN_TABLE_NAME WHERE id = ?", [id]);
  }

  Future<int> deleteAll(String scanType) async {
    if (!_isDbOpen()) {
      await _initDB();
    }
    return db.rawDelete("DELETE FROM $SCAN_TABLE_NAME WHERE type = ?", [scanType]);
  }

  bool _isDbOpen() => db != null && db.isOpen;
}
