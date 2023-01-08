import 'package:flutter/cupertino.dart';
import 'package:flutter_latlong/flutter_latlong.dart';
import 'package:google_geocoding/google_geocoding.dart' as geocoding;
import 'package:uia_app/utils/logger.dart';
import 'package:uia_app/utils/permission_helper.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uia_app/models/location.dart' as custom;
import 'package:url_launcher/url_launcher.dart';

class LocationHelper {
  static final LocationHelper _singleton = LocationHelper._internal();
  bool isPermissionRequested = false;
  factory LocationHelper() {
    return _singleton;
  }
  final log = getLogger('location_handler');
  LocationHelper._internal();

  static Future<custom.Location?> getLocation(BuildContext context) async {
    await PermissionHelper().verifyPermission(Permission.location, context);
    Location location = Location();

    bool _serviceEnabled;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _locationData = await location.getLocation();
    return custom.Location(
        latitude: _locationData.latitude, longitude: _locationData.longitude);
  }

  // getReadableLocation(double? lat, double? long) async {//free
  //   double latitude = lat!;
  //   double longitude = long!;
  //   List<geocoding.Placemark> placemarks =
  //       await geocoding.placemarkFromCoordinates(latitude, longitude);
  //   log.d(placemarks.first.locality);
  //   return placemarks.first.thoroughfare != null
  //       ? placemarks.first.thoroughfare! + ", " + placemarks.first.locality!
  //       : placemarks.first.subLocality! + ", " + placemarks.first.locality!;
  // }

  getReadableLocation(double? lat, double? long) async {
    double latitude = lat!;
    double longitude = long!;
    log.d("getting readable location");
    var googleGeocoding =
        geocoding.GoogleGeocoding("AIzaSyBmb3JrEviMHM6f4QNquX2ifW7Ozvy1-GI");
    geocoding.GeocodingResponse? result = await googleGeocoding.geocoding
        .getReverse(geocoding.LatLon(lat, long), resultType: ["political"]
            // resultType: ["locality", "sublocality", "neighborhood"],
            );

    geocoding.GeocodingResult? firstResult = result?.results?.first;
    String? formatted = (firstResult?.addressComponents![0].longName ?? "") +
        ", " +
        (firstResult?.addressComponents![1].longName ?? "") +
        ", " +
        (firstResult?.addressComponents![2].longName ?? "");
    // +
    // ", " +
    // (firstResult?.addressComponents![3].longName ?? "");
    log.d(formatted);
    return formatted;
  }

  int? getDistance(custom.Location start, custom.Location end) {
    final Distance distance = new Distance();

    final num? km = distance.as(
        LengthUnit.Kilometer,
        LatLng(start.latitude!, start.longitude!),
        LatLng(end.latitude!, end.longitude!));
    return km?.toInt();
  }

  openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}
