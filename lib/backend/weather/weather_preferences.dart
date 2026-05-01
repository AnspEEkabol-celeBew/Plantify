import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:plantify/backend/firestore/firestore.dart';
import 'package:plantify/storage/preferences.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Model
// ─────────────────────────────────────────────────────────────────────────────

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

  static const defaultLocation = WeatherLocation(
    name: 'Ipil, Philippines',
    latitude: 7.7851,
    longitude: 122.5893,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Read
// ─────────────────────────────────────────────────────────────────────────────

/// Reads `preferredWeather` from inside userData in SharedPreferences.
/// Falls back to [WeatherLocation.defaultLocation] if missing or corrupt.
Future<WeatherLocation> loadWeatherLocation() async {
  try {
    final Map<String, dynamic> userData =
        await loadPreferencesOnMap('userData', {});

    final raw = userData['preferredWeather'];
    if (raw == null || (raw as String).isEmpty) {
      return WeatherLocation.defaultLocation;
    }

    return WeatherLocation.fromJson(
        jsonDecode(raw) as Map<String, dynamic>);
  } catch (e) {
    debugPrint('[WeatherPreferences] loadWeatherLocation error: $e');
    return WeatherLocation.defaultLocation;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Write  (mirrors the addPlantToGarden pattern exactly)
// ─────────────────────────────────────────────────────────────────────────────

/// Saves `preferredWeather` inside userData, persists to SharedPreferences,
/// then syncs the whole userData document to Firestore — same flow as
/// addPlantToGarden() in PlantInfoScreen.
Future<void> saveWeatherLocation(WeatherLocation location) async {
  try {
    // 1. Load full userData (so we never lose other fields)
    final Map<String, dynamic> userData =
        await loadPreferencesOnMap('userData', {});

    // 2. Patch only the preferredWeather field
    userData['preferredWeather'] = jsonEncode(location.toJson());

    // 3. Persist locally
    await savePreferencesOnMap('userData', userData);

    // 4. Sync to Firestore
    _syncToFirestore(userData);
  } catch (e) {
    debugPrint('[WeatherPreferences] saveWeatherLocation error: $e');
  }
}

void _syncToFirestore(Map<String, dynamic> userData) {
  try {
    final FirestoreService firestoreService = FirestoreService();
    firestoreService.updateWhere(
      collection: 'users',
      field: 'uuid',
      isEqualTo: userData['uuid'],
      newData: userData,
    );
  } catch (e) {
    debugPrint('[WeatherPreferences] Firestore sync error: $e');
  }
}