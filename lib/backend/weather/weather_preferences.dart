import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

const _locationKey = 'weather_location';

class WeatherLocation {
  final String name;
  final double latitude;
  final double longitude;

  const WeatherLocation({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'latitude': latitude,
        'longitude': longitude,
      };

  factory WeatherLocation.fromJson(Map<String, dynamic> json) =>
      WeatherLocation(
        name: json['name'] as String,
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
      );

  // Default location (Ipil, Philippines — matching your design)
  static const defaultLocation = WeatherLocation(
    name: 'Ipil, Philippines',
    latitude: 7.7851,
    longitude: 122.5893,
  );
}

Future<WeatherLocation> loadWeatherLocation() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_locationKey);
    if (raw == null) return WeatherLocation.defaultLocation;
    return WeatherLocation.fromJson(
        jsonDecode(raw) as Map<String, dynamic>);
  } catch (_) {
    return WeatherLocation.defaultLocation;
  }
}

Future<void> saveWeatherLocation(WeatherLocation location) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_locationKey, jsonEncode(location.toJson()));
}