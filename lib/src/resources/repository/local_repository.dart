import 'package:flutter_qr_reader/src/resources/database/qr_dao.dart';
import 'package:flutter_qr_reader/src/resources/models/scan_model.dart';

class LocalRepository {
  QRDao _dao;

  LocalRepository._(QRDao dao) {
    this._dao = dao;
  }

  factory LocalRepository.newInstance() => LocalRepository._(QRDao());

  Future<int> insert(ScanModel scanModel) {
    return _dao.insert(scanModel);
  }

  Future<int> delete(ScanModel scanModel) {
    return _dao.delete(scanModel);
  }

  Future<int> deleteAll(ScanType scanType) {
    return _dao.deleteAll(scanType);
  }

  Future<List<Map<String, dynamic>>> getScansDirections() {
    return _dao.getAllScanDirections();
  }

  Future<List<Map<String, dynamic>>> getScanMaps() {
    return _dao.getAllScanMaps();
  }
}
