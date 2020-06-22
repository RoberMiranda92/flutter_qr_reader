import 'package:flutter/material.dart';
import 'package:flutter_qr_reader/src/pages/geo_detail.dart';
import 'package:flutter_qr_reader/src/pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Reader',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(103, 58, 183, 1),
        primaryColorLight: Color.fromRGBO(209, 196, 233, 1),
        primaryColorDark: Color.fromRGBO(81, 45, 168, 1),
        accentColor: Color.fromRGBO(124, 77, 255, 1),
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: "home",
      routes: {
        "home": (BuildContext context) => HomePage(),
        "detail": (BuildContext context) => GeoDetailPage()
      },
    );
  }
}
