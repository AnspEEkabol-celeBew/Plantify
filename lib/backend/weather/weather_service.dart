import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ─── Models ───────────────────────────────────────────────────────────────────

enum WeatherCondition {
  sunny,
  cloudy,
  rainy,
  snowy,
  stormy,
  sunnyCloudy,
  windy,
}

extension WeatherConditionExt on WeatherCondition {
  /// Returns the SVG asset path matching your file naming convention.
  String get svgAsset {
    switch (this) {
      case WeatherCondition.sunny:
        return 'assets/images/icons/svg/sunny.svg';
      case WeatherCondition.cloudy:
        return 'assets/images/icons/svg/cloudy.svg';
      case WeatherCondition.rainy:
        return 'assets/images/icons/svg/rainy.svg';
      case WeatherCondition.snowy:
        return 'assets/images/icons/svg/snowy.svg';
      case WeatherCondition.stormy:
        return 'assets/images/icons/svg/stormy.svg';
      case WeatherCondition.sunnyCloudy:
        return 'assets/images/icons/svg/sunnycloudy.svg';
      case WeatherCondition.windy:
        return 'assets/images/icons/svg/windy.svg';
    }
  }

  String get label {
    switch (this) {
      case WeatherCondition.sunny:
        return 'Sunny';
      case WeatherCondition.cloudy:
        return 'Cloudy';
      case WeatherCondition.rainy:
        return 'Rainy';
      case WeatherCondition.snowy:
        return 'Snowy';
      case WeatherCondition.stormy:
        return 'Stormy';
      case WeatherCondition.sunnyCloudy:
        return 'Partly Cloudy';
      case WeatherCondition.windy:
        return 'Windy';
    }
  }
}

class WeatherDay {
  final DateTime date;
  final double tempC;
  final int humidity;
  final WeatherCondition condition;

  const WeatherDay({
    required this.date,
    required this.tempC,
    required this.humidity,
    required this.condition,
  });

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'tempC': tempC,
        'humidity': humidity,
        'condition': condition.index,
      };

  factory WeatherDay.fromJson(Map<String, dynamic> json) => WeatherDay(
        date: DateTime.parse(json['date'] as String),
        tempC: (json['tempC'] as num).toDouble(),
        humidity: json['humidity'] as int,
        condition: WeatherCondition.values[json['condition'] as int],
      );
}

class WeatherData {
  final String locationName;
  final double latitude;
  final double longitude;
  final WeatherDay today;
  final List<WeatherDay> forecast; // next 5 days
  final DateTime fetchedAt;

  const WeatherData({
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.today,
    required this.forecast,
    required this.fetchedAt,
  });

  Map<String, dynamic> toJson() => {
        'locationName': locationName,
        'latitude': latitude,
        'longitude': longitude,
        'today': today.toJson(),
        'forecast': forecast.map((d) => d.toJson()).toList(),
        'fetchedAt': fetchedAt.toIso8601String(),
      };

  factory WeatherData.fromJson(Map<String, dynamic> json) => WeatherData(
        locationName: json['locationName'] as String,
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        today: WeatherDay.fromJson(json['today'] as Map<String, dynamic>),
        forecast: (json['forecast'] as List)
            .map((e) => WeatherDay.fromJson(e as Map<String, dynamic>))
            .toList(),
        fetchedAt: DateTime.parse(json['fetchedAt'] as String),
      );
}

// ─── WMO Code → Condition Mapping ─────────────────────────────────────────────

WeatherCondition _wmoToCondition(int code, double windspeedKmh) {
  // Thunderstorm
  if (code >= 95) return WeatherCondition.stormy;
  // Snow
  if (code >= 71 && code <= 77) return WeatherCondition.snowy;
  // Rain / Drizzle / Showers
  if (code >= 51 && code <= 67) return WeatherCondition.rainy;
  if (code >= 80 && code <= 82) return WeatherCondition.rainy;
  // Fog / Rime
  if (code == 45 || code == 48) return WeatherCondition.cloudy;
  // Partly cloudy
  if (code == 1 || code == 2) return WeatherCondition.sunnyCloudy;
  // Overcast
  if (code == 3) return WeatherCondition.cloudy;
  // Clear / code == 0
  // If wind is strong (>40 km/h) → windy
  if (windspeedKmh >= 40) return WeatherCondition.windy;
  return WeatherCondition.sunny;
}

// ─── Service ──────────────────────────────────────────────────────────────────

const _cacheKey = 'weather_cache';
const _cacheTtlMinutes = 30; // free-tier friendly: only 2 calls/hour max

class WeatherService {
  WeatherService._();
  static final WeatherService instance = WeatherService._();

  // ── Public API ──────────────────────────────────────────────────────────────

  /// Fetches weather for [latitude]/[longitude].
  /// Returns cached data if still fresh (< 30 min old).
  /// Pass [forceRefresh] = true to bypass cache.
  Future<WeatherData> getWeather({
    required double latitude,
    required double longitude,
    required String locationName,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final cached = await _loadCache();
      if (cached != null &&
          cached.latitude == latitude &&
          cached.longitude == longitude) {
        final age = DateTime.now().difference(cached.fetchedAt).inMinutes;
        if (age < _cacheTtlMinutes) return cached;
      }
    }

    final data = await _fetchFromApi(
      latitude: latitude,
      longitude: longitude,
      locationName: locationName,
    );

    await _saveCache(data);
    return data;
  }

  // ── Private helpers ─────────────────────────────────────────────────────────

  Future<WeatherData> _fetchFromApi({
    required double latitude,
    required double longitude,
    required String locationName,
  }) async {
    // Open-Meteo: free, no API key, CORS-friendly
    final uri = Uri.parse(
      'https://api.open-meteo.com/v1/forecast'
      '?latitude=$latitude'
      '&longitude=$longitude'
      '&current=temperature_2m,relative_humidity_2m,weathercode,windspeed_10m'
      '&daily=temperature_2m_max,relative_humidity_2m_mean,weathercode,windspeed_10m_max'
      '&timezone=auto'
      '&forecast_days=7',
    );

    final response = await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Weather API error: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final current = json['current'] as Map<String, dynamic>;
    final daily = json['daily'] as Map<String, dynamic>;

    final dates = (daily['time'] as List).cast<String>();
    final maxTemps = (daily['temperature_2m_max'] as List).cast<num>();
    final humidities = (daily['relative_humidity_2m_mean'] as List).cast<num>();
    final codes = (daily['weathercode'] as List).cast<int>();
    final winds = (daily['windspeed_10m_max'] as List).cast<num>();

    // Today
    final todayCondition = _wmoToCondition(
      current['weathercode'] as int,
      (current['windspeed_10m'] as num).toDouble(),
    );

    final today = WeatherDay(
      date: DateTime.now(),
      tempC: (current['temperature_2m'] as num).toDouble(),
      humidity: current['relative_humidity_2m'] as int,
      condition: todayCondition,
    );

    // Next 5 days (skip index 0 = today)
    final forecast = <WeatherDay>[];
    for (int i = 1; i <= 5 && i < dates.length; i++) {
      forecast.add(WeatherDay(
        date: DateTime.parse(dates[i]),
        tempC: maxTemps[i].toDouble(),
        humidity: humidities[i].toInt(),
        condition: _wmoToCondition(codes[i], winds[i].toDouble()),
      ));
    }

    return WeatherData(
      locationName: locationName,
      latitude: latitude,
      longitude: longitude,
      today: today,
      forecast: forecast,
      fetchedAt: DateTime.now(),
    );
  }

  Future<WeatherData?> _loadCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_cacheKey);
      if (raw == null) return null;
      return WeatherData.fromJson(
          jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveCache(WeatherData data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cacheKey, jsonEncode(data.toJson()));
    } catch (_) {}
  }

  /// Clears cached weather (useful when user changes location).
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
  }
}