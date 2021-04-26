import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationHandler {
  Future<String> getPincode() async {
    String postalCode;
    await _determinePosition().then((value) async {
      print("${value.latitude} ${value.longitude}");
      List<Placemark> place =
          await placemarkFromCoordinates(value.latitude, value.longitude);
      postalCode = place[0].postalCode;
      print(postalCode);
      return postalCode;
    }).catchError((e) {
      print("ERROR : ${e.toString()}");
      postalCode = e.toString();
      return "error";
    });
    return postalCode;
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    return await Geolocator.getCurrentPosition();
  }
}
