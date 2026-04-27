import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import '../../backend/firestore/firestore.dart';
import '../../storage/plants.dart';
import '../../storage/preferences.dart';
import '../../theme/colors.dart';
import '../../theme/fonts.dart';
import '../../util/appbar.dart';
import '../../util/container.dart';
import '../../util/image.dart';
import '../../util/layout.dart';
import '../../util/miscellaneous.dart';
import '../../util/snackbar.dart';
import '../../util/text.dart';
import '../home/plant_info.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({
    super.key,
    required this.imagePath,
    required this.results,
  });
  final String imagePath;
  final Map<String, dynamic> results;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late final String plantLabelName = removeIdFromLabel(widget.results['name']);
  late final Map<String, dynamic>? plant = plants.getPlantByLabelName(
    plantLabelName,
  );
  late final double conf = widget.results['confidence'];
  late final String confInString = "${(conf * 100).toStringAsFixed(2)}%";

  bool isInGarden(List<dynamic> gardenList, String plantId) {
    for (int l = 0; l < gardenList.length; l++) {
      if (gardenList[l]['plant_id'] == plantId) {
        return true;
      }
    }
    return false;
  }

  void addPlantToGarden() async {
    Map<String, dynamic> userDataTemp = await loadPreferencesOnMap(
      'userData',
      {},
    );
    List<dynamic> plantList = json.decode(userDataTemp['garden']);

    debugPrint(plant?['id']);

    if (isInGarden(plantList, plant?['id'])) {
      showSnackBar("You already have this Plant!");
      return;
    }

    plantList.add({'plant_id': plant?['id'], 'journal': []});

    userDataTemp['garden'] = json.encode(plantList);
    savePreferencesOnMap('userData', userDataTemp);
    updateToFirestore(userDataTemp);
    showSnackBar("Plant added to Garden!");
  }

  void updateToFirestore(Map<String, dynamic> userData) {
    FirestoreService firestoreService = FirestoreService();
    firestoreService.updateWhere(
      collection: 'users',
      field: 'uuid',
      isEqualTo: userData['uuid'],
      newData: userData,
    );
  }

  void showSnackBar(String message) {
    showUtilSnackBar(
      context,
      duration: 2000,
      animationDuration: 200,
      color: colorAccent.cardDark,
      boxShadow: [
        BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.3), blurRadius: 5),
      ],
      width: 300,
      content: UtilText(
        message,
        align: TextAlign.center,
        family: Fonts.defaultFontRegular,
        color: colorAccent.primaryText,
        size: 15,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorAccent.background,
      appBar: subAppbarModifyLeading(
        title: "Plant Result",
        leading: UtilContainer(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: conf < 0.5
          ? Center(
              child: UtilFlexBox(
                margin: EdgeInsets.all(40.0),
                cross: CrossAxisAlignment.center,
                main: MainAxisAlignment.center,
                direction: Axis.vertical,
                gap: 25,
                children: [
                  UtilFitImage(
                    'assets/images/icons/img/plantify_icon.png',
                    width: 200,
                  ),
                  UtilText(
                    "Sorry about that!",
                    align: TextAlign.center,
                    family: Fonts.defaultFontSemiBold,
                    color: colorAccent.primaryText,
                    size: 30,
                  ),
                  UtilText(
                    "We can't found the plant that match. Try again in a different angle.",
                    align: TextAlign.center,
                    family: Fonts.defaultFontRegular,
                    color: colorAccent.secondaryText,
                    size: 18,
                  ),
                  UtilContainer(
                    onTap: () => Navigator.pop(context),
                    height: 60,
                    width: double.maxFinite,
                    borderRadius: BorderRadius.circular(100),
                    color: colorAccent.tertiary,
                    alignment: Alignment.center,
                    child: UtilText(
                      "Try Again",
                      family: Fonts.defaultFontThin,
                      size: 18,
                      color: colorAccent.white,
                    ),
                  ),
                  SizedBox(height: 50.0),
                ],
              ),
            )
          : SingleChildScrollView(
              child: UtilFlexBox(
                direction: Axis.vertical,
                gap: 15,
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                children: [
                  UtilFlexBox(
                    direction: Axis.horizontal,
                    gap: 10,
                    children: [
                      UtilFitImageFile(
                        File(widget.imagePath),
                        width: 150,
                        height: 150,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      UtilFlexBox(
                        direction: Axis.vertical,
                        main: MainAxisAlignment.spaceEvenly,
                        gap: 5,
                        children: [
                          UtilText(
                            "Plant Detected!",
                            family: Fonts.defaultFontSemiBold,
                            size: 23,
                            color: colorAccent.primaryText,
                          ),
                          UtilText(
                            "Confidentiality: $confInString",
                            family: Fonts.defaultFontSemiBold,
                            size: 18,
                            color: colorAccent.secondaryText,
                          ),
                        ],
                      ),
                    ],
                  ),
                  UtilFitImage(
                    plant?['image_url'],
                    width: double.maxFinite,
                    height: 220,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  PlantInfoHead(plant: plant ?? {}),
                  PlantInfoSub(plant: plant ?? {}),
                  UtilContainer(
                    onTap: () => addPlantToGarden(),
                    height: 60,
                    width: double.maxFinite,
                    borderRadius: BorderRadius.circular(100),
                    color: colorAccent.secondary,
                    alignment: Alignment.center,
                    child: UtilText(
                      "Add to My Garden",
                      family: Fonts.defaultFontThin,
                      size: 18,
                      color: colorAccent.white,
                    ),
                  ),
                  SizedBox(height: 80.0),
                ],
              ),
            ),
    );
  }
}
