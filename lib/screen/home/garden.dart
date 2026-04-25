import 'package:flutter/material.dart';
import 'package:plantify/theme/colors.dart';
import 'package:plantify/util/container.dart';
import 'package:plantify/util/form.dart';
import 'package:plantify/util/image.dart';
import 'package:plantify/util/layout.dart';
import 'package:plantify/util/text.dart';

import '../../theme/fonts.dart';

class GardenScreen extends StatefulWidget {
  const GardenScreen({super.key});

  @override
  State<GardenScreen> createState() => _GardenScreenState();
}

class _GardenScreenState extends State<GardenScreen> {
  FlowerCondition flowerCondition = FlowerCondition();

  @override
  Widget build(BuildContext context) {
    return UtilFlexBox(
      direction: Axis.vertical,
      children: [
        //header - searchbox, filter
        UtilFlexBox(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          width: double.infinity,
          direction: Axis.vertical,
          height: 140,
          gap: 12,
          children: [

            //searchbox
            UtilInputBox(
              width: double.maxFinite,
              height: 50,
              border: Border.all(color: colorAccent.primaryText, width: 1.5),
              borderRadius: BorderRadius.circular(15),
              prefix: Icon(Icons.search, color: colorAccent.primaryText),
              hint: "Search your plants ...",
              fonts: Fonts.defaultFontExtraLight,
              textColor: colorAccent.primaryText,
            ),

            //filter
            UtilFlexBox(
              direction: Axis.horizontal,
              width: double.maxFinite,
              height: 50,
              borderRadius: BorderRadius.circular(15),
              color: colorAccent.cardDark,
              children: [
                Expanded(
                  child: UtilContainer(
                    alignment: Alignment.center,
                    color: colorAccent.secondary,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
                    child: UtilText(
                      "All",
                      family: Fonts.defaultFontThin,
                      color: colorAccent.primaryText,
                      size: 15,
                    ),
                  ),
                ),
                Expanded(
                  child: UtilContainer(
                    alignment: Alignment.center,
                    color: Colors.transparent,
                    child: UtilText(
                      "Healthy",
                      family: Fonts.defaultFontThin,
                      color: colorAccent.primaryText,
                      size: 15,
                    ),
                  ),
                ),
                Expanded(
                  child: UtilContainer(
                    alignment: Alignment.center,
                    color: Colors.transparent,
                    child: UtilText(
                      "Needs Water",
                      family: Fonts.defaultFontThin,
                      color: colorAccent.primaryText,
                      size: 15,
                    ),
                  ),
                ),
                Expanded(
                  child: UtilContainer(
                    alignment: Alignment.center,
                    color: Colors.transparent,
                    child: UtilText(
                      "Overdue",
                      family: Fonts.defaultFontThin,
                      color: colorAccent.primaryText,
                      size: 15,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),

        //garden
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: UtilGridBox(
              margin: EdgeInsets.symmetric(horizontal: 20),
              columns: 2,
              gapX: 12,
              gapY: 12,
              childAspectRatio: 0.8,
              children: [
                FlowersList(
                  name: "Hibiscus",
                  image: 'assets/images/misc/hibiscus.jpg',
                  nextWatering: 'March 28',
                  condition: flowerCondition.needsWater
                ),
                FlowersList(
                  name: "Cycads",
                  image: 'assets/images/misc/cycad.jpg',
                  nextWatering: 'March 8',
                  condition: flowerCondition.healthy
                ),
                FlowersList(
                  name: "Juniper",
                  image: 'assets/images/misc/juniper.jpg',
                  nextWatering: 'April 22',
                  condition: flowerCondition.healthy
                ),
                FlowersList(
                  name: "Peace Plant",
                  image: 'assets/images/misc/peace_plant.jpg',
                  nextWatering: 'March 12',
                  condition: flowerCondition.overdue
                ),
                FlowersList(
                  name: "Sunflower",
                  image: 'assets/images/misc/sunflower.jpg',
                  nextWatering: 'April 1',
                  condition: flowerCondition.healthy
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class FlowerCondition {
  Map<String, Color> healthy = {"Healthy": colorAccent.colorHealthy};
  Map<String, Color> needsWater = {"Needs Water": colorAccent.colorNeedsWater};
  Map<String, Color> overdue = {"Overdue": colorAccent.colorOverdue};
}

class FlowersList extends StatelessWidget {
  const FlowersList({
    super.key,
    required this.name,
    required this.image,
    required this.nextWatering,
    required this.condition,
  });

  final String name;
  final String image;
  final String nextWatering;
  final Map<String, Color> condition;

  @override
  Widget build(BuildContext context) {
    return UtilFlexBox(
      borderRadius: BorderRadius.circular(15),
      color: colorAccent.cardLight,
      gap: 5,
      children: [
        UtilFitImage(
          image,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          height: 140,
        ),
        UtilFlexBox(
          margin: EdgeInsets.symmetric(horizontal: 7),
          children: [
            UtilText(
              name,
              family: Fonts.defaultFontMedium,
              color: colorAccent.primaryText,
              size: 18,
            ),
            UtilText(
              "Next Watering: $nextWatering",
              family: Fonts.defaultFontExtraLight,
              color: colorAccent.secondaryText,
              size: 13,
            ),
            UtilFlexBox(
              direction: Axis.horizontal,
              children: [
                UtilText(
                  "Condition: ",
                  family: Fonts.defaultFontExtraLight,
                  color: colorAccent.secondaryText,
                  size: 13,
                ),
                UtilText(
                  condition.keys.first,
                  family: Fonts.defaultFontExtraLight,
                  color: condition.values.first,
                  size: 13,
                ),
              ],
            )
          ],
        )
      ],
    );
  }
}