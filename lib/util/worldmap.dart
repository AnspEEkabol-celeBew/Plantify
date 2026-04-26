import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plantify/util/text.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

import '../theme/colors.dart';
import '../theme/fonts.dart';
import 'container.dart';
import 'layout.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Distribution status & colors
// ─────────────────────────────────────────────────────────────────────────────

enum DistributionStatus {
  native,
  cultivated,
  exotic,
  invasive,
  potentiallyInvasive,
  unreported,
}

abstract final class DistributionColors {
  static final Map<DistributionStatus, Color> palette = {
    DistributionStatus.native:              colorAccent.native,
    DistributionStatus.cultivated:          colorAccent.cultivated,
    DistributionStatus.exotic:              colorAccent.exotic,
    DistributionStatus.invasive:            colorAccent.invasive,
    DistributionStatus.potentiallyInvasive: colorAccent.potentiallyInvasive,
    DistributionStatus.unreported:          colorAccent.unreported,
  };

  static Color forStatus(DistributionStatus status) => palette[status]!;
}

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────

// Maps your distributionData keys → exact GeoJSON continent strings.
const Map<String, String> _keyToContinent = {
  'asia':          'Asia',
  'africa':        'Africa',
  'europe':        'Europe',
  'north_america': 'North America',
  'south_america': 'South America',
  'australia':     'Oceania',
  'oceania':       'Oceania',
  'antarctica':    'Antarctica',
};

DistributionStatus _parseStatus(String raw) {
  switch (raw.trim().toLowerCase().replaceAll(' ', '_')) {
    case 'native':               return DistributionStatus.native;
    case 'cultivated':           return DistributionStatus.cultivated;
    case 'exotic':               return DistributionStatus.exotic;
    case 'invasive':             return DistributionStatus.invasive;
    case 'potentially_invasive':
    case 'potentiallyinvasive':  return DistributionStatus.potentiallyInvasive;
    default:                     return DistributionStatus.unreported;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Internal model
// ─────────────────────────────────────────────────────────────────────────────

class _CountryEntry {
  const _CountryEntry({required this.name, required this.continent});
  final String name;
  final String continent;
}

// ─────────────────────────────────────────────────────────────────────────────
// DistributionMapChart
// ─────────────────────────────────────────────────────────────────────────────

class DistributionMapChart extends StatefulWidget {
  const DistributionMapChart({
    super.key,
    required this.distributionData,
    this.strokeColor = const Color(0xFFFFFFFF),
    this.strokeWidth = 0.5,
    this.unreportedColor = const Color(0xFFBDBDBD),
  });

  /// e.g. `{ 'asia': 'Native', 'africa': 'Cultivated', ... }`
  final Map<String, String> distributionData;
  final Color strokeColor;
  final double strokeWidth;
  final Color unreportedColor;

  @override
  State<DistributionMapChart> createState() => _DistributionMapChartState();
}

class _DistributionMapChartState extends State<DistributionMapChart> {
  MapShapeSource? _source;

  @override
  void initState() {
    super.initState();
    _loadSource();
  }

  @override
  void didUpdateWidget(DistributionMapChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.distributionData != widget.distributionData) {
      _loadSource();
    }
  }

  // Resolves a GeoJSON continent string to a color from distributionData.
  Color _colorForContinent(String geoJsonContinent) {
    for (final entry in widget.distributionData.entries) {
      final mapped = _keyToContinent[entry.key.toLowerCase()];
      if (mapped == geoJsonContinent) {
        return DistributionColors.forStatus(_parseStatus(entry.value));
      }
    }
    return widget.unreportedColor;
  }

  Future<void> _loadSource() async {
    final raw = await rootBundle.loadString('assets/misc/world_map.json');
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final features = decoded['features'] as List<dynamic>;

    // Build a flat list of every country with its continent.
    final entries = <_CountryEntry>[];
    for (final f in features) {
      final props = (f as Map<String, dynamic>)['properties'] as Map<String, dynamic>;
      final name = (props['name'] as String?) ?? '';
      if (name.isEmpty) continue;
      entries.add(_CountryEntry(
        name: name,
        continent: (props['continent'] as String?) ?? '',
      ));
    }

    // Collect distinct continent values for MapColorMapper.
    final seenContinents = <String>{};
    final colorMappers = <MapColorMapper>[];
    for (final e in entries) {
      if (seenContinents.add(e.continent)) {
        colorMappers.add(MapColorMapper(
          value: e.continent,
          color: e.continent == 'Seven seas (open ocean)'
              ? Colors.transparent
              : _colorForContinent(e.continent),
        ));
      }
    }

    // All three (dataCount, primaryValueMapper, shapeColorValueMapper) are
    // required by Syncfusion whenever shapeColorMappers is provided.
    final source = MapShapeSource.asset(
      'assets/misc/world_map.json',
      shapeDataField: 'name',
      dataCount: entries.length,
      primaryValueMapper: (i) => entries[i].name,
      shapeColorValueMapper: (i) => entries[i].continent,
      shapeColorMappers: colorMappers,
    );

    if (mounted) setState(() => _source = source);
  }

  @override
  Widget build(BuildContext context) {
    // Render nothing until the asset is ready — avoids any layout jump.
    if (_source == null) return const SizedBox.shrink();

    return SfMaps(
      layers: [
        MapShapeLayer(
          source: _source!,
          strokeColor: widget.strokeColor,
          strokeWidth: widget.strokeWidth,
        ),
      ],
    );
  }
}

class DistributionLegend extends StatelessWidget {
  const DistributionLegend({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return UtilFlexBox(
      children: [
        UtilFlexBox(
          direction: Axis.horizontal,
          main: MainAxisAlignment.spaceEvenly,
          children: [
            UtilText(
              "Native",
              family: Fonts.defaultFontThin,
              color: colorAccent.secondaryText,
              size: 15,
              prefix: UtilContainer(
                width: 10,
                height: 10,
                color: colorAccent.native,
              ),
            ),
            UtilText(
              "Cultivated",
              family: Fonts.defaultFontThin,
              color: colorAccent.secondaryText,
              size: 15,
              prefix: UtilContainer(
                width: 10,
                height: 10,
                color: colorAccent.cultivated,
              ),
            ),
            UtilText(
              "Exotic",
              family: Fonts.defaultFontThin,
              color: colorAccent.secondaryText,
              size: 15,
              prefix: UtilContainer(
                width: 10,
                height: 10,
                color: colorAccent.exotic,
              ),
            ),
          ],
        ),
        UtilFlexBox(
          direction: Axis.horizontal,
          main: MainAxisAlignment.spaceEvenly,
          children: [
            UtilText(
              "Invasive",
              family: Fonts.defaultFontThin,
              color: colorAccent.secondaryText,
              size: 15,
              prefix: UtilContainer(
                width: 10,
                height: 10,
                color: colorAccent.invasive,
              ),
            ),
            UtilText(
              "Potentially Invasive",
              family: Fonts.defaultFontThin,
              color: colorAccent.secondaryText,
              size: 15,
              prefix: UtilContainer(
                width: 10,
                height: 10,
                color: colorAccent.potentiallyInvasive,
              ),
            ),
            UtilText(
              "Unreported",
              family: Fonts.defaultFontThin,
              color: colorAccent.secondaryText,
              size: 15,
              prefix: UtilContainer(
                width: 10,
                height: 10,
                color: colorAccent.unreported,
              ),
            ),
          ],
        ),
      ],
    );
  }
}