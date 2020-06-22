import 'dart:async';

import 'package:flutter_qr_reader/src/resources/models/scan_model.dart';
import 'package:flutter_qr_reader/src/resources/repository/local_repository.dart';

import 'event.dart';

class ScanBloc {
  static ScanBloc _instance;
  LocalRepository _repository;

  List<ScanModel> _cache = List<ScanModel>();

  ScanBloc._(LocalRepository repository) {
    this._repository = repository;
  }

  static ScanBloc getInstance() {
    if (_instance == null) {
      _instance = ScanBloc._(LocalRepository.newInstance());
    }

    return _instance;
  }

  final StreamController<List<ScanModel>> _scanListMapsBroadcast =
      StreamController<List<ScanModel>>.broadcast();
  final StreamController<Event> _scanEventBroadcast =
      StreamController<Event>.broadcast();

  Stream<List<ScanModel>> get scanListMapsStream =>
      _scanListMapsBroadcast.stream;

  StreamSink<List<ScanModel>> get scanListMapsSink =>
      _scanListMapsBroadcast.sink;

  Stream<Event> get scanEventStream => _scanEventBroadcast.stream;

  void diposeStreams() {
    _scanListMapsBroadcast?.close();
    _scanEventBroadcast?.close();
  }

  void getMapList(scanType) async {
    try {
      List<Map<String, dynamic>> scans;
      _cache.clear();
      switch (scanType) {
        case ScanType.GEO:
          scans = await _repository.getScanMaps();
          break;
        case ScanType.LINK:
          scans = await _repository.getScansDirections();
      }
      _cache.addAll(scans.map((e) => ScanModel.fromJson(e)).toList());
      _scanListMapsBroadcast.sink.add(_cache);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      _scanListMapsBroadcast.addError(error);
      _scanEventBroadcast.sink.add(Event.error());
    }
  }

  void insert(ScanModel scanModel, ScanType currentType) async {
    try {
      int id = await _repository.insert(scanModel);
      scanModel.id = id;
      if (scanModel.type == currentType) {
        _scanListMapsBroadcast.sink.add(_cache..add(scanModel));
      }
      _scanEventBroadcast.add(Event.add());
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      _scanEventBroadcast.sink.add(Event.error());
    }
  }

  void delete(ScanModel scanModel) async {
    try {
      int id = await _repository.delete(scanModel);
      _cache.remove(scanModel);
      _scanListMapsBroadcast.sink.add(_cache);
      _scanEventBroadcast.sink.add(Event.delete());
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      _scanEventBroadcast.sink.add(Event.error());
    }
  }

  void deleteAll(ScanType scanType) async {
    try {
      int id = await _repository.deleteAll(scanType);
      _cache.clear();
      _scanListMapsBroadcast.sink.add(_cache);
      _scanEventBroadcast.sink.add(Event.delete());
    } catch (error, stacktrace) {
      _scanEventBroadcast.sink.add(Event.error());
    }
  }
}
