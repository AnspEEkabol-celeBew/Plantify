import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plantify/theme/colors.dart';
import 'package:plantify/theme/fonts.dart';
import 'package:plantify/util/container.dart';
import 'package:plantify/util/layout.dart';
import 'package:plantify/util/text.dart';

import '../../util/appbar.dart';
import 'weather_service.dart';
import 'weather_preferences.dart';

// ─────────────────────────────────────────────────────────────────────────────
// WeatherScreen
// ─────────────────────────────────────────────────────────────────────────────

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  WeatherData? _weatherData;
  bool _loading = true;
  String? _error;
  WeatherLocation _location = WeatherLocation.defaultLocation;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool forceRefresh = false}) async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      _location = await loadWeatherLocation();
      final data = await WeatherService.instance.getWeather(
        latitude: _location.latitude,
        longitude: _location.longitude,
        locationName: _location.name,
        forceRefresh: forceRefresh,
      );
      setState(() {
        _weatherData = data;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Could not load weather. Check your connection.';
        _loading = false;
      });
    }
  }

  // ── Settings sheet ──────────────────────────────────────────────────────────

  void _openSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _LocationSettingsSheet(
        current: _location,
        onSave: (loc) async {
          await saveWeatherLocation(loc);
          await WeatherService.instance.clearCache();
          await _load(forceRefresh: true);
        },
      ),
    );
  }

  // ── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorAccent.background,
      appBar: subAppbar(
        title: 'Weather',
        addonChildren: [
          UtilContainer(
            onTap: _openSettings,
            borderRadius: BorderRadius.circular(100),
            width: 40,
            height: 40,
            child: Icon(
              Icons.settings_outlined,
              color: colorAccent.primaryText,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Location ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: UtilText(
                _location.name,
                size: 24,
                family: Fonts.defaultFontSemiBold,
                color: colorAccent.primaryText,
                prefix: Icon(
                  Icons.location_on,
                  color: colorAccent.secondary,
                  size: 22,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Content ──
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                  ? _ErrorView(
                      message: _error!,
                      onRetry: () => _load(forceRefresh: true),
                    )
                  : _WeatherContent(data: _weatherData!),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Weather content (today + forecast list)
// ─────────────────────────────────────────────────────────────────────────────

class _WeatherContent extends StatelessWidget {
  final WeatherData data;

  const _WeatherContent({required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Today card ──
          _TodayCard(day: data.today),

          const SizedBox(height: 24),

          // ── 5-day forecast ──
          ...data.forecast.map((day) => _ForecastRow(day: day)),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Today card (large)
// ─────────────────────────────────────────────────────────────────────────────

class _TodayCard extends StatelessWidget {
  final WeatherDay day;

  const _TodayCard({required this.day});

  @override
  Widget build(BuildContext context) {
    final dateStr = _formatDate(day.date, showDay: false);

    return UtilContainer(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      borderRadius: BorderRadius.circular(16),
      color: colorAccent.cardLight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: text info
          Expanded(
            child: UtilFlexBox(
              gap: 4,
              children: [
                UtilText(
                  'Today - $dateStr',
                  size: 15,
                  family: Fonts.defaultFontExtraLight,
                  color: colorAccent.secondaryText,
                ),
                UtilText(
                  '${day.tempC.round()} °C',
                  size: 48,
                  family: Fonts.defaultFontSemiBold,
                  color: colorAccent.primaryText,
                ),
                UtilText(
                  'Condition: ${day.condition.label}',
                  size: 15,
                  family: Fonts.defaultFontExtraLight,
                  color: colorAccent.secondaryText,
                ),
                UtilText(
                  'Humidity: ${day.humidity}%',
                  size: 15,
                  family: Fonts.defaultFontExtraLight,
                  color: colorAccent.secondaryText,
                ),
              ],
            ),
          ),
          // Right: weather icon
          SvgPicture.asset(
            day.condition.svgAsset,
            width: 90,
            height: 90,
            colorFilter: ColorFilter.mode(
              colorAccent.secondary,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Forecast row (5 days)
// ─────────────────────────────────────────────────────────────────────────────

class _ForecastRow extends StatelessWidget {
  final WeatherDay day;

  const _ForecastRow({required this.day});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Day + date + humidity
          Expanded(
            child: UtilFlexBox(
              gap: 2,
              children: [
                UtilText(
                  _dayName(day.date),
                  size: 18,
                  family: Fonts.defaultFontSemiBold,
                  color: colorAccent.primaryText,
                ),
                UtilText(
                  _formatDate(day.date, showDay: false),
                  size: 14,
                  family: Fonts.defaultFontExtraLight,
                  color: colorAccent.secondaryText,
                ),
                UtilText(
                  'Humidity: ${day.humidity}%',
                  size: 14,
                  family: Fonts.defaultFontExtraLight,
                  color: colorAccent.secondaryText,
                ),
              ],
            ),
          ),
          // Temp
          UtilText(
            '${day.tempC.round()} °C',
            size: 28,
            family: Fonts.defaultFontSemiBold,
            color: colorAccent.primaryText,
          ),
          const SizedBox(width: 16),
          // Icon
          SvgPicture.asset(
            day.condition.svgAsset,
            width: 55,
            height: 55,
            colorFilter: ColorFilter.mode(
              colorAccent.secondary,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Location Settings Bottom Sheet
// ─────────────────────────────────────────────────────────────────────────────

class _LocationSettingsSheet extends StatefulWidget {
  final WeatherLocation current;
  final Future<void> Function(WeatherLocation) onSave;

  const _LocationSettingsSheet({required this.current, required this.onSave});

  @override
  State<_LocationSettingsSheet> createState() => _LocationSettingsSheetState();
}

class _LocationSettingsSheetState extends State<_LocationSettingsSheet> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _latCtrl;
  late final TextEditingController _lngCtrl;
  bool _saving = false;
  String? _validationError;

  // Preset locations (Philippines-focused, expandable)
  static const _presets = [
    WeatherLocation(
      name: 'Ipil, Philippines',
      latitude: 7.7851,
      longitude: 122.5893,
    ),
    WeatherLocation(
      name: 'Manila, Philippines',
      latitude: 14.5995,
      longitude: 120.9842,
    ),
    WeatherLocation(
      name: 'Cebu City, Philippines',
      latitude: 10.3157,
      longitude: 123.8854,
    ),
    WeatherLocation(
      name: 'Davao City, Philippines',
      latitude: 7.1907,
      longitude: 125.4553,
    ),
    WeatherLocation(
      name: 'Cagayan de Oro, Philippines',
      latitude: 8.4542,
      longitude: 124.6319,
    ),
    WeatherLocation(
      name: 'Zamboanga City, Philippines',
      latitude: 6.9214,
      longitude: 122.0790,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.current.name);
    _latCtrl = TextEditingController(text: widget.current.latitude.toString());
    _lngCtrl = TextEditingController(text: widget.current.longitude.toString());
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _latCtrl.dispose();
    _lngCtrl.dispose();
    super.dispose();
  }

  void _applyPreset(WeatherLocation loc) {
    setState(() {
      _nameCtrl.text = loc.name;
      _latCtrl.text = loc.latitude.toString();
      _lngCtrl.text = loc.longitude.toString();
      _validationError = null;
    });
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    final lat = double.tryParse(_latCtrl.text.trim());
    final lng = double.tryParse(_lngCtrl.text.trim());

    if (name.isEmpty || lat == null || lng == null) {
      setState(() {
        _validationError = 'Please fill in all fields correctly.';
      });
      return;
    }

    if (lat < -90 || lat > 90 || lng < -180 || lng > 180) {
      setState(() {
        _validationError = 'Invalid coordinates range.';
      });
      return;
    }

    setState(() {
      _saving = true;
      _validationError = null;
    });

    await widget.onSave(
      WeatherLocation(name: name, latitude: lat, longitude: lng),
    );

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colorAccent.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorAccent.secondaryText,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
            const SizedBox(height: 16),

            UtilText(
              'Change Location',
              size: 20,
              family: Fonts.defaultFontSemiBold,
              color: colorAccent.primaryText,
            ),
            const SizedBox(height: 16),

            // ── Preset chips ──
            UtilText(
              'Quick select',
              size: 14,
              family: Fonts.defaultFontExtraLight,
              color: colorAccent.secondaryText,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _presets
                  .map(
                    (p) => GestureDetector(
                      onTap: () => _applyPreset(p),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: colorAccent.cardLight,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: colorAccent.secondary,
                          ),
                        ),
                        child: UtilText(
                          p.name,
                          size: 13,
                          family: Fonts.defaultFontExtraLight,
                          color: colorAccent.primaryText,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 20),

            // ── Manual entry ──
            UtilText(
              'Or enter manually',
              size: 14,
              family: Fonts.defaultFontExtraLight,
              color: colorAccent.secondaryText,
            ),
            const SizedBox(height: 10),

            _buildField(
              'Location Name',
              _nameCtrl,
              hint: 'e.g. Ipil, Philippines',
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildField(
                    'Latitude',
                    _latCtrl,
                    hint: '7.7851',
                    keyboard: TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildField(
                    'Longitude',
                    _lngCtrl,
                    hint: '122.5893',
                    keyboard: TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                  ),
                ),
              ],
            ),

            if (_validationError != null) ...[
              const SizedBox(height: 8),
              UtilText(
                _validationError!,
                size: 13,
                color: Colors.redAccent,
                family: Fonts.defaultFontExtraLight,
              ),
            ],

            const SizedBox(height: 20),

            // ── Save button ──
            UtilContainer(
              onTap: _saving ? null : _save,
              width: double.infinity,
              height: 50,
              borderRadius: BorderRadius.circular(12),
              color: colorAccent.secondary,
              alignment: Alignment.center,
              child: _saving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : UtilText(
                      'Save Location',
                      size: 16,
                      family: Fonts.defaultFontMedium,
                      color: Colors.white,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController ctrl, {
    String? hint,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UtilText(
          label,
          size: 13,
          family: Fonts.defaultFontExtraLight,
          color: colorAccent.secondaryText,
        ),
        const SizedBox(height: 4),
        TextField(
          controller: ctrl,
          keyboardType: keyboard,
          style: TextStyle(
            color: colorAccent.primaryText,
            fontFamily: Fonts.defaultFontRegular.fontFamily,
            fontSize: 15,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: colorAccent.secondaryText,
              fontFamily: Fonts.defaultFontExtraLight.fontFamily,
              fontSize: 14,
            ),
            filled: true,
            fillColor: colorAccent.cardLight,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Error view
// ─────────────────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: UtilFlexBox(
        main: MainAxisAlignment.center,
        cross: CrossAxisAlignment.center,
        gap: 16,
        padding: const EdgeInsets.all(32),
        children: [
          Icon(
            Icons.cloud_off_outlined,
            size: 52,
            color: colorAccent.secondaryText,
          ),
          UtilText(
            message,
            align: TextAlign.center,
            size: 15,
            family: Fonts.defaultFontExtraLight,
            color: colorAccent.secondaryText,
          ),
          UtilContainer(
            onTap: onRetry,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            borderRadius: BorderRadius.circular(100),
            color: colorAccent.secondary,
            child: UtilText(
              'Retry',
              size: 15,
              color: Colors.white,
              family: Fonts.defaultFontMedium,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────

const _months = [
  '',
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

const _days = [
  '',
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

String _formatDate(DateTime dt, {bool showDay = true}) {
  final m = _months[dt.month];
  final d = dt.day;
  final y = dt.year;
  return '$m $d, $y';
}

String _dayName(DateTime dt) => _days[dt.weekday];
