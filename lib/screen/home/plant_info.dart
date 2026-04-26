import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

import '../../theme/colors.dart';
import '../../theme/fonts.dart';
import '../../util/appbar.dart';
import '../../util/container.dart';
import '../../util/image.dart';
import '../../util/layout.dart';
import '../../util/text.dart';
import '../../util/worldmap.dart';

class PlantInfoScreen extends StatefulWidget {
  const PlantInfoScreen({super.key, required this.plantData});

  final Map<String, dynamic> plantData;

  @override
  State<PlantInfoScreen> createState() => _PlantInfoScreenState();
}

class _PlantInfoScreenState extends State<PlantInfoScreen> {
  late final Map<String, dynamic> plant = widget.plantData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorAccent.background,
      appBar: subAppbarModifyLeading(
        title: "Plant",
        leading: UtilContainer(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: UtilFlexBox(
          direction: Axis.vertical,
          gap: 15,
          margin: EdgeInsets.symmetric(horizontal: 20.0),
          children: [
            UtilFitImage(
              plant['image_url'],
              width: double.maxFinite,
              height: 220,
              borderRadius: BorderRadius.circular(20.0),
            ),
            PlantInfoHead(plant: plant),
            PlantInfoSub(plant: plant),
            SizedBox(height: 80.0)
          ],
        ),
      ),
    );
  }
}

class PlantInfoSub extends StatelessWidget {
  const PlantInfoSub({super.key, required this.plant});

  final Map<String, dynamic> plant;

  @override
  Widget build(BuildContext context) {
    return UtilFlexBox(
      direction: Axis.vertical,
      gap: 15,
      children: [
        UtilFlexBox(
          direction: Axis.vertical,
          gap: 7,
          children: [
            UtilText(
              "Description",
              size: 28,
              family: Fonts.defaultFontSemiBold,
              color: colorAccent.primaryText,
            ),
            UtilText(
              plant['description']['general'],
              size: 18,
              family: Fonts.defaultFontRegular,
              color: colorAccent.secondaryText,
            ),
            UtilText(
              "Plant Type: ${plant['description']['plant_type']}",
              size: 18,
              family: Fonts.defaultFontRegular,
              color: colorAccent.secondaryText,
            ),
          ],
        ),

        UtilFlexBox(
          direction: Axis.vertical,
          gap: 7,
          children: [
            UtilText(
              "Distribution",
              size: 28,
              family: Fonts.defaultFontSemiBold,
              color: colorAccent.primaryText,
            ),
            UtilContainer(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: DistributionMapChart(distributionData: plant['distribution']),
            ),
            DistributionLegend(),
          ],
        ),

        UtilFlexBox(
          direction: Axis.vertical,
          gap: 7,
          children: [
            UtilText(
              "Conditions",
              size: 28,
              family: Fonts.defaultFontSemiBold,
              color: colorAccent.primaryText,
            ),
            UtilText(
              "Temperature: ${plant["growing_conditions"]['temperature_range']}",
              size: 18,
              family: Fonts.defaultFontRegular,
              color: colorAccent.secondaryText,
            ),
            UtilText(
              "Sunlight: ${plant["growing_conditions"]['sunlight']}",
              size: 18,
              family: Fonts.defaultFontRegular,
              color: colorAccent.secondaryText,
            ),
            UtilText(
              "Soil Type: ${plant["growing_conditions"]['soil_type']}",
              size: 18,
              family: Fonts.defaultFontRegular,
              color: colorAccent.secondaryText,
            ),
            UtilText(
              "Soil pH: ${plant["growing_conditions"]['soil_ph']}",
              size: 18,
              family: Fonts.defaultFontRegular,
              color: colorAccent.secondaryText,
            ),
            UtilText(
              "Drainage: ${plant["growing_conditions"]['drainage']}",
              size: 18,
              family: Fonts.defaultFontRegular,
              color: colorAccent.secondaryText,
            ),
            UtilText(
              "Grown Rate: ${plant["growing_conditions"]['growth_rate']}",
              size: 18,
              family: Fonts.defaultFontRegular,
              color: colorAccent.secondaryText,
            ),
          ],
        ),

        UtilFlexBox(
          direction: Axis.vertical,
          gap: 7,
          children: [
            UtilText(
              "Toxicity",
              size: 28,
              family: Fonts.defaultFontSemiBold,
              color: colorAccent.primaryText,
            ),
            UtilText(
              "Intensity: ${plant["toxicity"]['level']}",
              size: 18,
              family: Fonts.defaultFontRegular,
              color: colorAccent.secondaryText,
            ),
            UtilText(
              "Intensity: ${plant["toxicity"]['toxic_to']}",
              size: 18,
              family: Fonts.defaultFontRegular,
              color: colorAccent.secondaryText,
            ),
            UtilText(
              "Intensity: ${plant["toxicity"]['toxic_parts']}",
              size: 18,
              family: Fonts.defaultFontRegular,
              color: colorAccent.secondaryText,
            ),
          ],
        ),

        UtilFlexBox(
          direction: Axis.vertical,
          gap: 7,
          children: [
            UtilText(
              "How to Care?",
              size: 28,
              family: Fonts.defaultFontSemiBold,
              color: colorAccent.primaryText,
            ),
            UtilText(
              "Watering: ${plant["care_guide"]['watering']}",
              size: 18,
              family: Fonts.defaultFontRegular,
              color: colorAccent.secondaryText,
            ),
            UtilText(
              "Fertilizing: ${plant["care_guide"]['fertilizing']}",
              size: 18,
              family: Fonts.defaultFontRegular,
              color: colorAccent.secondaryText,
            ),
            UtilText(
              "Propagation: ${plant["care_guide"]['propagation'].join(", ")}",
              size: 18,
              family: Fonts.defaultFontRegular,
              color: colorAccent.secondaryText,
            ),
            UtilText(
              "Repotting: ${plant["care_guide"]['repotting']}",
              size: 18,
              family: Fonts.defaultFontRegular,
              color: colorAccent.secondaryText,
            ),
            UtilText(
              "Humidity: ${plant["care_guide"]['humidity']}",
              size: 18,
              family: Fonts.defaultFontRegular,
              color: colorAccent.secondaryText,
            ),
          ],
        ),

        UtilFlexBox(
          direction: Axis.vertical,
          gap: 7,
          children: [
            UtilText(
              "Common Pests and Diseases",
              size: 28,
              family: Fonts.defaultFontSemiBold,
              color: colorAccent.primaryText,
            ),
            UtilText(
              "Pests: ${plant["pests_diseases"]['pests'].join(", ")}",
              size: 18,
              family: Fonts.defaultFontRegular,
              color: colorAccent.secondaryText,
            ),
            UtilText(
              "Diseases: ${plant["pests_diseases"]['diseases'].join(", ")}",
              size: 18,
              family: Fonts.defaultFontRegular,
              color: colorAccent.secondaryText,
            ),
            UtilText(
              "Treatment: ${plant["pests_diseases"]['treatment']}",
              size: 18,
              family: Fonts.defaultFontRegular,
              color: colorAccent.secondaryText,
            ),
          ],
        ),

        UtilFlexBox(
          direction: Axis.vertical,
          gap: 7,
          children:
              [
                UtilText(
                  "Common Uses",
                  size: 28,
                  family: Fonts.defaultFontSemiBold,
                  color: colorAccent.primaryText,
                ),
              ] +
              List.generate(
                plant["uses"].length,
                (i) => UtilText(
                  " - ${plant["uses"][i]}",
                  size: 18,
                  family: Fonts.defaultFontRegular,
                  color: colorAccent.secondaryText,
                ),
              ),
        ),

        UtilFlexBox(
          direction: Axis.vertical,
          gap: 7,
          children:
              [
                UtilText(
                  "Features",
                  size: 28,
                  family: Fonts.defaultFontSemiBold,
                  color: colorAccent.primaryText,
                ),
              ] +
              List.generate(
                plant["features"].length,
                (i) => UtilText(
                  " - ${plant["features"][i]}",
                  size: 18,
                  family: Fonts.defaultFontRegular,
                  color: colorAccent.secondaryText,
                ),
              ),
        ),
      ],
    );
  }
}

class PlantInfoHead extends StatelessWidget {
  const PlantInfoHead({super.key, required this.plant});

  final Map<String, dynamic> plant;

  @override
  Widget build(BuildContext context) {
    return UtilFlexBox(
      direction: Axis.vertical,
      gap: 15,
      children: [
        UtilFlexBox(
          direction: Axis.vertical,
          gap: 7,
          children: [
            UtilText(
              plant["plant_name"],
              size: 28,
              family: Fonts.defaultFontSemiBold,
              color: colorAccent.primaryText,
            ),
            UtilText(
              "Genus: ${plant["genus"]}",
              size: 18,
              family: Fonts.defaultFontRegular,
              color: colorAccent.secondaryText,
            ),
            UtilText(
              "Family: ${plant["family"]}",
              size: 18,
              family: Fonts.defaultFontRegular,
              color: colorAccent.secondaryText,
            ),
            UtilText(
              "Scientific Name: ${plant["scientific_name"]}",
              size: 18,
              family: Fonts.defaultFontRegular,
              color: colorAccent.secondaryText,
            ),
          ],
        ),
      ],
    );
  }
}
