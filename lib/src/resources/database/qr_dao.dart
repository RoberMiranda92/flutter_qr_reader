import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter_qr_reader/src/resources/database/qr_database.dart';
import 'package:flutter_qr_reader/src/resources/models/scan_model.dart';

class QRDao {
  QRDataBase _db;

  QRDao._(QRDataBase db) {
    this._db = db;
  }
  factory QRDao() {
    return QRDao._(QRDataBase.instance);
  }

  Future<int> insert(ScanModel scanModel) {
    return _db.insert(
        type: EnumToString.parse(scanModel.type), value: scanModel.value);
  }

  Future<int> delete(ScanModel scanModel) {
    return _db.deleteById(id: scanModel.id);
  }

  Future<int> deleteAll(ScanType scanType) {
    return _db.deleteAll(EnumToString.parse(scanType));
  }

  Future<List<Map<String, dynamic>>> getAllScans() {
    return _db.getScans();
  }

  Future<List<Map<String, dynamic>>> getAllScanMaps() {
    return _db.getScanByType(EnumToString.parse(ScanType.GEO));
  }

  Future<List<Map<String, dynamic>>> getAllScanDirections() {
    return _db.getScanByType(EnumToString.parse(ScanType.LINK));
  }
}
