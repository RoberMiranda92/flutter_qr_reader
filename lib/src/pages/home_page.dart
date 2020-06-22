import 'package:barcode_scan/barcode_scan.dart';
import 'package:barcode_scan/platform_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qr_reader/src/bloc/event.dart';
import 'package:flutter_qr_reader/src/bloc/scans_bloc.dart';
import 'package:flutter_qr_reader/src/pages/geo_detail.dart';
import 'package:flutter_qr_reader/src/resources/models/scan_model.dart';
import 'package:flutter_qr_reader/src/resources/repository/local_repository.dart';
import 'package:flutter_qr_reader/src/ui/scan_list.dart';
import 'package:flutter_qr_reader/src/utils/ui_utils.dart';
import 'package:flutter_qr_reader/src/utils/scan_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Pages _currentIndex;
  LocalRepository _repository = LocalRepository.newInstance();
  BuildContext scaffoldContext;

  @override
  void initState() {
    _currentIndex = Pages.MAPS;
    super.initState();
  }

  @override
  void dispose() {
    ScanBloc.getInstance().diposeStreams();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _subscribeToEvents();
    return Scaffold(
      appBar: _createAppBar(),
      body: Builder(builder: (BuildContext context) {
        scaffoldContext = context;
        return _tooglePage(_currentIndex);
      }),
      bottomNavigationBar: _createNavigationBar(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _createActionButton(context),
    );
  }

  Widget _tooglePage(Pages index) {
    switch (index) {
      case Pages.MAPS:
        ScanBloc.getInstance().getMapList(ScanType.GEO);
        break;
      case Pages.DIRECTIONS:
        ScanBloc.getInstance().getMapList(ScanType.LINK);
        break;
      default:
    }

    return StreamBuilder<List<ScanModel>>(
        stream: ScanBloc.getInstance().scanListMapsStream,
        builder:
            (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshop) {
          if (!snapshop.hasData && !snapshop.hasError) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshop.hasData) {
            var list = snapshop.data;

            return list.isEmpty
                ? Center(child: Text("Empty List"))
                : scanList(list);
          }

          if (snapshop.hasError) {
            return Text(snapshop.error.toString());
          }
        });
  }

  Widget scanList(List<ScanModel> list) {
    return ScanList(list, 
        (scan) => {_manageScanClick(scan, context)},
        (scan) => {ScanBloc.getInstance().delete(scan)}
        );
  }

  void _manageScanClick(ScanModel scan, BuildContext context) {
    switch (scan.type) {
      case ScanType.GEO:
        navigateToGeoDetail(scan, context);
        break;
      case ScanType.LINK:
        navigateToWeb(scan.value, () => {_onNavigateError(context)});
        break;
    }
  }

  Widget _createNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex.index,
      onTap: (index) => {
        setState(() => {_currentIndex = Pages.values[index]})
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.map), title: Text("Maps")),
        BottomNavigationBarItem(
            icon: Icon(Icons.directions), title: Text("Directions"))
      ],
    );
  }

  Widget _createActionButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.filter_center_focus),
      onPressed: () => {_scanQR()},
    );
  }

  Widget _createAppBar() {
    return AppBar(
      title: Text("QR Scanner"),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.delete_forever),
          onPressed: () => {
            ScanBloc.getInstance().deleteAll(
                _currentIndex == Pages.MAPS ? ScanType.GEO : ScanType.LINK)
          },
        ),
      ],
    );
  }

  void _scanQR() async {
    var result = await BarcodeScanner.scan();
    switch (result.type) {
      case ResultType.Barcode:
        if (isValidURL(result.rawContent)) {
          ScanBloc.getInstance().insert(
            ScanModel(type: ScanType.LINK, value: result.rawContent),
            _currentIndex == Pages.MAPS ? ScanType.GEO : ScanType.LINK,
          );
        } else if (areValidCoordinates(result.rawContent)) {
          ScanBloc.getInstance().insert(
              ScanModel(type: ScanType.GEO, value: result.rawContent),
              _currentIndex == Pages.MAPS ? ScanType.GEO : ScanType.LINK);
        } else {
          showError("Invalid QR", scaffoldContext);
        }
        break;
      case ResultType.Cancelled:
        showError("QR scanner cancelled", scaffoldContext);
        break;
      case ResultType.Error:
        showError("QR scanner error", scaffoldContext);
        break;
    }
  }

  void _subscribeToEvents() {
    ScanBloc.getInstance().scanEventStream.listen((event) {
      switch (event.type) {
        case EventType.ADD:
          showOK("QR Added", scaffoldContext);
          break;
        case EventType.DELETE:
          {
            showOK("QR Deleted", scaffoldContext);
          }
          break;
        case EventType.ERROR:
          {
            showError("Some Error", scaffoldContext);
          }
          break;
        default:
      }
    },
        onError: (error, stackTrace) =>
            {showError("Some Error", scaffoldContext)});
  }
}

void navigateToGeoDetail(ScanModel scan, BuildContext context) {
  Map<String, dynamic> arguments = {GeoDetailPage.SCAN_ARG: scan};
  Navigator.pushNamed(context, "detail", arguments: arguments);
}

void _onNavigateError(BuildContext context) {
  showError("Can't open url", context);
}

enum Pages { MAPS, DIRECTIONS }
