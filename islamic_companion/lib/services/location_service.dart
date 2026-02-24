// ============================================================
// location_service.dart
// Wraps Geolocator to get device coordinates.
// Falls back gracefully when permissions are denied.
// ============================================================

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:islamic_companion/core/constants/app_constants.dart';

class LocationService {
  /// Returns current device position.
  /// Throws [LocationException] on failure.
  Future<Position?> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null; // GPS off – caller handles fallback
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }
    if (permission == LocationPermission.deniedForever) return null;

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium, // saves battery on low-end devices
        timeLimit: Duration(seconds: 10),
      ),
    );
  }

  /// Performs reverse geocoding to find city name from coordinates.
  Future<String?> getCityFromCoordinates(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return place.locality ?? place.subAdministrativeArea ?? place.administrativeArea;
      }
    } catch (_) {
      // Ignore geocoding errors
    }
    return null;
  }

  /// Returns the default city coordinates (Karachi) as fallback.
  Map<String, dynamic> getDefaultCity() {
    return AppConstants.pakistaniCities.first; // Karachi
  }

  /// Find a city by name from the static list.
  Map<String, dynamic>? findCity(String cityName) {
    try {
      return AppConstants.pakistaniCities.firstWhere(
        (c) => c['name'].toString().toLowerCase() == cityName.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }
}
