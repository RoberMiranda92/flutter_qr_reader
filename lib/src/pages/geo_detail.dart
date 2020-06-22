import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_qr_reader/src/resources/models/scan_model.dart';
import 'package:flutter_qr_reader/src/utils/scan_utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeoDetailPage extends StatefulWidget {
  static const String SCAN_ARG = "arg_scan";

  @override
  State<GeoDetailPage> createState() => GeoDetailPageState();
}

class GeoDetailPageState extends State<GeoDetailPage> {
  Completer<GoogleMapController> _controller = Completer();
  MapType _initialMap;
  IconData _initialIcon;
  @override
  void initState() {
    _initialMap = MapType.hybrid;
    _initialIcon = Icons.layers;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ScanModel scan = (ModalRoute.of(context).settings.arguments
        as Map<String, dynamic>)[GeoDetailPage.SCAN_ARG];


    final CameraPosition _kGooglePlex = CameraPosition(
      target: stringToCoordinates(scan.value),
      zoom: 14.4746,
    );
    return new Scaffold(
      appBar: AppBar(
        title: Text("QR Coordinates"),
      ),
      body: GoogleMap(
        markers: Set.from([
          Marker(
              markerId: MarkerId(scan.value),
              position: stringToCoordinates(scan.value),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueViolet))
        ]),
        mapType: _initialMap,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _toogleMap();
          {}
        },
        child: Icon(_initialIcon),
      ),
    );
  }

  void _toogleMap() {
    return setState(() {
          switch (_initialMap) {
            case MapType.normal:
              _initialMap = MapType.satellite;
              _initialIcon = Icons.satellite;
              break;
            case MapType.satellite:
              _initialMap = MapType.terrain;
              _initialIcon = Icons.landscape;
              break;
            case MapType.terrain:
              _initialMap = MapType.hybrid;
              _initialIcon = Icons.layers;
              break;
            case MapType.hybrid:
              _initialMap = MapType.normal;
              _initialIcon = Icons.map;
              break;
          }
        });
  }
}
