import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void navigateToWeb(String url, Function onError) async {
  if (isValidURL(url) && await canLaunch(url)) {
    await launch(url);
  } else {
    onError.call();
  }
}

bool isValidURL(String url) => url.contains("http") && Uri.parse(url).isAbsolute;

bool areValidCoordinates(String coordinates) =>
    stringToCoordinates(coordinates) != null;

/**
 * Format a string like geo:lat,long into a LatLong Value.
 * 
 * **/
LatLng stringToCoordinates(String coordinates) {
  try {
    List<double> split = coordinates
        .split(":")[1]
        .split(",")
        .map((e) => double.parse(e))
        .toList();
    return LatLng(split[0], split[1]);
  } catch (error, stacktrace) {
    return null;
  }
}
