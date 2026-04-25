import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plantify/storage/preferences.dart';
import 'package:plantify/theme/colors.dart';
import 'package:plantify/util/container.dart';
import 'package:plantify/util/layout.dart';
import 'package:plantify/util/text.dart';

import '../../theme/fonts.dart';
import '../../util/image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic> _userData = {};

  @override
  void initState() {
    super.initState();
    setState(() {
      _loadUserData();
    });
  }

  Future<void> _loadUserData() async {
    final user = await loadPreferencesOnMap('userData', {});
    setState(() {
      _userData = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String username  = _userData['username'] as String? ?? '';
    final String email = _userData['email'] as String? ?? '';
    final int age = _userData['age'] as int? ?? 0;

    return SingleChildScrollView(
      child: UtilFlexBox(
        gap: 5,
        children: [
          //header
          UtilFlexBox(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            gap: 5,
            children: [
              UtilText(
                "Hi $username",
                size: 38,
                family: Fonts.defaultFontSemiBold,
                color: colorAccent.primaryText,
              ),
              UtilText(
                "Let's keep your plants healthy today!",
                size: 18,
                family: Fonts.defaultFontThin,
                color: colorAccent.secondaryText,
              ),
            ],
          ),

          //weather
          UtilFlexBox(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            gap: 10,
            children: [
              UtilText(
                "Weather Today",
                color: colorAccent.primaryText,
                family: Fonts.defaultFontMedium,
                size: 20,
              ),
              UtilFlexBox(
                onTap: () {

                },
                main: MainAxisAlignment.center,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                direction: Axis.horizontal,
                width: double.infinity,
                height: 130,
                color: colorAccent.cardLight,
                borderRadius: BorderRadius.circular(10.0),
                children: [
                  Expanded(
                    child: UtilFlexBox(
                      direction: Axis.vertical,
                      children: [
                        UtilText(
                          "Ipil, Philippines",
                          size: 16,
                          prefix: Icon(Icons.location_on, color: colorAccent.primaryText),
                          family: Fonts.defaultFontExtraLight,
                          color: colorAccent.primaryText,
                        ),
                        UtilText(
                          "67 °C",
                          size: 40,
                          family: Fonts.defaultFontMedium,
                          color: colorAccent.primaryText,
                        ),
                        UtilText(
                          "Humidity 67%",
                          size: 15,
                          family: Fonts.defaultFontExtraLight,
                          color: colorAccent.primaryText,
                        ),
                      ],
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/images/icons/svg/sunny.svg',
                    colorFilter: ColorFilter.mode(colorAccent.secondary, BlendMode.srcIn)
                  )
                ],
              ),
            ],
          ),

          //article
          UtilFlexBox(
            direction: Axis.vertical,
            margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            gap: 5,
            children: [
              UtilFlexBox(
                direction: Axis.horizontal,
                cross: CrossAxisAlignment.end,
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                children: [
                  Expanded(
                    child: UtilText(
                      "Popular Articles",
                      family: Fonts.defaultFontMedium,
                      size: 20,
                      color: colorAccent.primaryText,
                    ),
                  ),
                  UtilFlexBox(
                    onTap: () => debugPrint("more"),
                    borderRadius: BorderRadius.circular(100),
                    cross: CrossAxisAlignment.center,
                    direction: Axis.horizontal,
                    gap: 5,
                    children: [
                      UtilText(
                        "View All",
                        size: 18,
                        family: Fonts.defaultFontExtraLight,
                        color: colorAccent.secondary,
                      ),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 18,
                        color: colorAccent.secondary,
                      ),
                    ],
                  ),
                ],
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: UtilFlexBox(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  height: 220,
                  direction: Axis.horizontal,
                  gap: 15,
                  children: List.generate(
                    10,
                    (ind) => UtilFlexBox(
                      onTap: () => {debugPrint("art ${ind + 1}")},
                      borderRadius: BorderRadius.circular(15),
                      gap: 8,
                      direction: Axis.vertical,
                      width: 220,
                      height: double.maxFinite,
                      children: [
                        UtilFitImage(
                          'assets/images/util/article_image_sample.jpg',
                          height: 150,
                          borderRadius: BorderRadius.circular(15),
                          width: double.maxFinite,
                          fit: BoxFit.cover,
                        ),
                        UtilFlexBox(
                          direction: Axis.horizontal,
                          children: [
                            Expanded(
                              child: UtilText(
                                "Sample Article ${ind + 1} Sample Article ${ind + 1}",
                                family: Fonts.defaultFontExtraLight,
                                size: 16,
                                color: colorAccent.secondaryText,
                              ),
                            ),
                            UtilContainer(
                              height: 45,
                              width: 30,
                              borderRadius: BorderRadius.circular(100),
                              onTap: () => debugPrint("artset ${ind + 1}"),
                              child: Icon(
                                Icons.more_vert,
                                color: colorAccent.primaryText,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          //planty
          UtilFlexBox(
            onTap: () => {debugPrint("planty")},
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            padding: EdgeInsets.all(5),
            width: double.maxFinite,
            borderRadius: BorderRadius.circular(10),
            direction: Axis.horizontal,
            height: 150,
            color: colorAccent.cardLight,
            children: [
              Image.asset('assets/images/misc/planty.png'),
              Expanded(
                child: UtilFlexBox(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  direction: Axis.vertical,
                  gap: 10,
                  children: [
                    UtilText(
                      "Ask Planty",
                      size: 25,
                      family: Fonts.defaultFontMedium,
                      color: colorAccent.primaryText,
                    ),
                    UtilText(
                      "Our Planty is ready to help with your plant related problems and more!",
                      size: 15,
                      family: Fonts.defaultFontThin,
                      color: colorAccent.secondaryText,
                    ),
                  ],
                ),
              ),
            ],
          ),

          //explore plants
          UtilFlexBox(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            direction: Axis.vertical,
            gap: 12,
            children: [
              UtilText(
                "Explore Plants",
                size: 20,
                family: Fonts.defaultFontMedium,
                color: colorAccent.primaryText,
              ),
              UtilGridBox(
                childAspectRatio: 1.13,
                columns: 2,
                gapX: 10,
                gapY: 10,
                children: [
                  ExplorePlants(
                    image: 'assets/images/misc/foilage.jpg',
                    name: 'Foliage Plants'
                  ),
                  ExplorePlants(
                    image: 'assets/images/misc/succulents.webp',
                    name: 'Succulents and Cacti'
                  ),
                  ExplorePlants(
                    image: 'assets/images/misc/flowering.jpg',
                    name: 'Flowering Plants'
                  ),
                  ExplorePlants(
                    image: 'assets/images/misc/epiphytes.jpg',
                    name: 'Epiphytes'
                  ),
                  ExplorePlants(
                    image: 'assets/images/misc/herbs.webp',
                    name: 'Culinary Herbs'
                  ),
                  ExplorePlants(
                    image: 'assets/images/misc/ferns.webp',
                    name: 'Ferns'
                  ),
                  ExplorePlants(
                    image: 'assets/images/misc/aquatic.webp',
                    name: 'Aquatic Plants'
                  ),
                  ExplorePlants(
                    image: 'assets/images/misc/carnivorous.jpg',
                    name: 'Carnivorous Plants'
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//WIDGET SHORTCUT
class ExplorePlants extends StatelessWidget {
  const ExplorePlants({
    super.key,
    required this.image,
    required this.name
  });

  final String image;
  final String name;

  @override
  Widget build(BuildContext context) {
    return UtilFitImage(
      image,
      onTap: ()=>debugPrint("more $name"),
      borderRadius: BorderRadius.circular(15),
      width: double.maxFinite,
      fit: BoxFit.cover,
      child: UtilContainer(
        borderRadius: BorderRadius.circular(15),
        padding: EdgeInsets.all(5),
        gradient: LinearGradient(
          begin: Alignment(0, -2.5),
          end: Alignment(0, 0.4),
          colors: [
            Color.fromRGBO(0, 0, 0, 0.8),
            Color.fromRGBO(0, 0, 0, 0),
          ],
        ),
        width: double.maxFinite,
        height: double.maxFinite,
        child: UtilText(
          name,
          family: Fonts.defaultFontRegular,
          color: colorAccent.white,
          size: 18,
        ),
      ),
    );
  }
}