import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:plantify/storage/preferences.dart';
import 'package:plantify/theme/colors.dart';
import 'package:plantify/util/container.dart';
import 'package:plantify/util/form.dart';
import 'package:plantify/util/image.dart';
import 'package:plantify/util/layout.dart';
import 'package:plantify/util/string.dart';
import 'package:plantify/util/text.dart';

import '../../main.dart';
import '../../storage/plants.dart';
import '../../theme/fonts.dart';
import '../../util/navigation.dart';
import '../../util/refresh.dart';
import 'my_plant.dart';

class GardenScreen extends StatefulWidget {
  const GardenScreen({super.key});

  @override
  State<GardenScreen> createState() => _GardenScreenState();
}

class _GardenScreenState extends State<GardenScreen> {
  List<dynamic> gardenList = [];
  List<dynamic> _filteredList = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadGarden();
  }

  Future<void> _loadGarden() async {
    Map<String, dynamic> userData = await loadPreferencesOnMap('userData', {});
    final list = json.decode(userData['garden']);
    setState(() {
      gardenList = list;
      _filteredList = list;
    });
    debugPrint(gardenList.toString());
  }

  void _onSearchChanged(String value) {
    final str = value.trim().toLowerCase();
    setState(() {
      _searchQuery = str;
      _filteredList = str.isEmpty
          ? gardenList // ✅ restore full list when search is cleared
          : gardenList
                .where(
                  (g) =>
                      plants
                          .getPlantById(g['plant_id'])?['plant_name']
                          .toLowerCase()
                          .contains(str) ??
                      false,
                )
                .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return UtilRefresh(
      onRefresh: () async {
        Future.wait([_loadGarden()]);
      },
      child: UtilFlexBox(
        direction: Axis.vertical,
        children: [
          UtilFlexBox(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            width: double.infinity,
            direction: Axis.vertical,
            height: 80,
            gap: 12,
            children: [
              UtilInputBox(
                width: double.maxFinite,
                height: 50,
                border: Border.all(color: colorAccent.primaryText, width: 1.5),
                borderRadius: BorderRadius.circular(15),
                prefix: Icon(Icons.search, color: colorAccent.primaryText),
                hint: "Search your plants ...",
                fonts: Fonts.defaultFontExtraLight,
                textColor: colorAccent.primaryText,
                onChanged: _onSearchChanged, // ✅ use the fixed handler
              ),
            ],
          ),

          Expanded(
            child:
                _filteredList
                    .isNotEmpty // ✅ use _filteredList for display
                ? SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: UtilGridBox(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      columns: 2,
                      gapX: 12,
                      gapY: 12,
                      childAspectRatio: 0.8,
                      children: List.generate(
                        _filteredList.length,
                        (i) => FlowersList(gardenData: _filteredList[i]),
                      ),
                    ),
                  )
                : Center(
                    child: UtilText(
                      gardenList.isEmpty
                          ? "The Garden is Empty!" // no data at all
                          : "No plants found.", // search returned nothing
                      size: 20,
                      family: Fonts.defaultFontRegular,
                      color: colorAccent.secondaryText,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class FlowersList extends StatelessWidget {
  const FlowersList({super.key, required this.gardenData});

  final Map<String, dynamic> gardenData;

  @override
  Widget build(BuildContext context) {
    String pid = gardenData['plant_id'];
    Map<String, dynamic>? plant = plants.getPlantById(pid);
    int journals = gardenData['journal'].length;
    return UtilFlexBox(
      onTap: () => navigateTo(
        context,
        animationType: NavAnimation.slideUp,
        duration: preferredAnimations.getDuration(),
        page: MyPlantScreen(gardenData: gardenData),
      ),
      borderRadius: BorderRadius.circular(15),
      color: colorAccent.cardLight,
      gap: 5,
      children: [
        UtilFitImage(
          plant?['image_url'],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          height: 140,
        ),
        UtilFlexBox(
          margin: EdgeInsets.symmetric(horizontal: 7),
          children: [
            UtilText(
              plant?['plant_name'],
              family: Fonts.defaultFontMedium,
              color: colorAccent.primaryText,
              size: 18,
            ),
            UtilText(
              "${journals == 0 ? "No" : journals} Journal${journals > 0 ? "s" : ""}",
              family: Fonts.defaultFontExtraLight,
              color: colorAccent.secondaryText,
              size: 13,
            ),
          ],
        ),
      ],
    );
  }
}
