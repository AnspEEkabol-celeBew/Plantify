import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plantify/backend/weather/weather_service.dart';
import 'package:plantify/screen/home/plant_info.dart';
import 'package:plantify/storage/preferences.dart';
import 'package:plantify/theme/colors.dart';
import 'package:plantify/util/container.dart';
import 'package:plantify/util/layout.dart';
import 'package:plantify/util/navigation.dart';
import 'package:plantify/util/text.dart';
import 'package:share_plus/share_plus.dart';

import '../../backend/weather/weather_preferences.dart';
import '../../backend/weather/weather_screen.dart';
import '../../main.dart';
import '../../storage/plants.dart';
import '../../theme/fonts.dart';
import '../../util/image.dart';
import '../article/article.dart';
import '../article/article_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic> _userData = {};
  WeatherData? _weatherData;
  bool _weatherLoading = true;
  List<ArticleData> _articles = [];

  @override
  void initState() {
    super.initState();
    _loadWeather();
    _loadUserData();
    _loadWeather();
    _loadArticles();
    setState(() {
      _loadUserData();
    });
  }

  Future<void> _loadWeather() async {
    try {
      final loc = await loadWeatherLocation();
      final data = await WeatherService.instance.getWeather(
        latitude: loc.latitude,
        longitude: loc.longitude,
        locationName: loc.name,
      );
      setState(() {
        _weatherData = data;
        _weatherLoading = false;
      });
    } catch (_) {
      setState(() => _weatherLoading = false);
    }
  }

  Future<void> _loadArticles() async {
    final articles = await ArticleService.getArticles();
    setState(() {
      _articles = articles;
    });
  }

  Future<void> _loadUserData() async {
    final user = await loadPreferencesOnMap('userData', {});
    setState(() {
      _userData = user;
    });
  }

  void _showArticleOptions(BuildContext context, ArticleData article) {
    showModalBottomSheet(
      context: context,
      backgroundColor: colorAccent.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.bookmark_border_rounded, color: colorAccent.primaryText),
              title: UtilText('Save Article', family: Fonts.defaultFontRegular, color: colorAccent.primaryText),
              onTap: () {
                Navigator.pop(context);
                debugPrint('save ${article.id}');
              },
            ),
            ListTile(
              leading: Icon(Icons.share_rounded, color: colorAccent.primaryText),
              title: UtilText('Share', family: Fonts.defaultFontRegular, color: colorAccent.primaryText),
              onTap: () {
                Navigator.pop(context);
                Share.share('${article.title}\n\n${article.sourceUrl}');
              },
            ),
          ],
        ),
      ),
    );
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
          // UtilFlexBox(
          //   margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          //   gap: 10,
          //   children: [
          //     UtilText(
          //       "Weather Today",
          //       color: colorAccent.primaryText,
          //       family: Fonts.defaultFontMedium,
          //       size: 20,
          //     ),
          //     UtilFlexBox(
          //       main: MainAxisAlignment.center,
          //       padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          //       direction: Axis.horizontal,
          //       width: double.infinity,
          //       height: 130,
          //       color: colorAccent.cardLight,
          //       borderRadius: BorderRadius.circular(10.0),
          //       children: [
          //         Expanded(
          //           child: UtilFlexBox(
          //             direction: Axis.vertical,
          //             children: [
          //               UtilText(
          //                 "Ipil, Philippines",
          //                 size: 16,
          //                 prefix: Icon(Icons.location_on, color: colorAccent.primaryText),
          //                 family: Fonts.defaultFontExtraLight,
          //                 color: colorAccent.primaryText,
          //               ),
          //               UtilText(
          //                 "67 °C",
          //                 size: 40,
          //                 family: Fonts.defaultFontMedium,
          //                 color: colorAccent.primaryText,
          //               ),
          //               UtilText(
          //                 "Humidity 67%",
          //                 size: 15,
          //                 family: Fonts.defaultFontExtraLight,
          //                 color: colorAccent.primaryText,
          //               ),
          //             ],
          //           ),
          //         ),
          //         SvgPicture.asset(
          //           'assets/images/icons/svg/sunny.svg',
          //           colorFilter: ColorFilter.mode(colorAccent.secondary, BlendMode.srcIn)
          //         )
          //       ],
          //     ),
          //   ],
          // ),
          HomeWeatherCard(
            weatherData: _weatherData,
            loading: _weatherLoading,
          ),

          //article
          // UtilFlexBox(
          //   direction: Axis.vertical,
          //   margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          //   gap: 5,
          //   children: [
          //     UtilFlexBox(
          //       direction: Axis.horizontal,
          //       cross: CrossAxisAlignment.end,
          //       margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          //       children: [
          //         Expanded(
          //           child: UtilText(
          //             "Popular Articles",
          //             family: Fonts.defaultFontMedium,
          //             size: 20,
          //             color: colorAccent.primaryText,
          //           ),
          //         ),
          //         UtilFlexBox(
          //           onTap: () => debugPrint("more"),
          //           borderRadius: BorderRadius.circular(100),
          //           cross: CrossAxisAlignment.center,
          //           direction: Axis.horizontal,
          //           gap: 5,
          //           children: [
          //             UtilText(
          //               "View All",
          //               size: 18,
          //               family: Fonts.defaultFontExtraLight,
          //               color: colorAccent.secondary,
          //             ),
          //             Icon(
          //               Icons.arrow_forward_rounded,
          //               size: 18,
          //               color: colorAccent.secondary,
          //             ),
          //           ],
          //         ),
          //       ],
          //     ),
          //     SingleChildScrollView(
          //       scrollDirection: Axis.horizontal,
          //       child: UtilFlexBox(
          //         margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          //         height: 220,
          //         direction: Axis.horizontal,
          //         gap: 15,
          //         children: List.generate(
          //           10,
          //           (ind) => UtilFlexBox(
          //             onTap: () => {debugPrint("art ${ind + 1}")},
          //             borderRadius: BorderRadius.circular(15),
          //             gap: 8,
          //             direction: Axis.vertical,
          //             width: 220,
          //             height: double.maxFinite,
          //             children: [
          //               UtilFitImage(
          //                 'assets/images/util/article_image_sample.jpg',
          //                 height: 150,
          //                 borderRadius: BorderRadius.circular(15),
          //                 width: double.maxFinite,
          //                 fit: BoxFit.cover,
          //               ),
          //               UtilFlexBox(
          //                 direction: Axis.horizontal,
          //                 children: [
          //                   Expanded(
          //                     child: UtilText(
          //                       "Sample Article ${ind + 1} Sample Article ${ind + 1}",
          //                       family: Fonts.defaultFontExtraLight,
          //                       size: 16,
          //                       color: colorAccent.secondaryText,
          //                     ),
          //                   ),
          //                   UtilContainer(
          //                     height: 45,
          //                     width: 30,
          //                     borderRadius: BorderRadius.circular(100),
          //                     onTap: () => debugPrint("artset ${ind + 1}"),
          //                     child: Icon(
          //                       Icons.more_vert,
          //                       color: colorAccent.primaryText,
          //                       size: 24,
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),

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
                  )
                ],
              ),
              if (_articles.isEmpty)
                // Loading shimmer / placeholder
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: UtilFlexBox(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    height: 220,
                    direction: Axis.horizontal,
                    gap: 15,
                    children: List.generate(
                      3,
                      (_) => Container(
                        width: 220,
                        decoration: BoxDecoration(
                          color: colorAccent.cardLight,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                )
              else
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: UtilFlexBox(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    height: 220,
                    direction: Axis.horizontal,
                    gap: 15,
                    children: _articles.map((article) {
                      return UtilFlexBox(
                        onTap: () => navigateTo(
                          context,
                          animationType: NavAnimation.slideUp,
                          duration: preferredAnimations.getDuration(),
                          page: ArticleScreen(article: article),
                        ),
                        borderRadius: BorderRadius.circular(15),
                        gap: 8,
                        direction: Axis.vertical,
                        width: 220,
                        height: double.maxFinite,
                        children: [
                          UtilFitImage(
                            article.imageUrl,
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
                                  article.title,
                                  family: Fonts.defaultFontExtraLight,
                                  size: 14,
                                  color: colorAccent.secondaryText,
                                ),
                              ),
                              UtilContainer(
                                height: 45,
                                width: 30,
                                borderRadius: BorderRadius.circular(100),
                                onTap: () => _showArticleOptions(context, article),
                                child: Icon(
                                  Icons.more_vert,
                                  color: colorAccent.primaryText,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),

          //planty
          // UtilFlexBox(
          //   onTap: () => {debugPrint("planty")},
          //   margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          //   padding: EdgeInsets.all(5),
          //   width: double.maxFinite,
          //   borderRadius: BorderRadius.circular(10),
          //   direction: Axis.horizontal,
          //   height: 150,
          //   color: colorAccent.cardLight,
          //   children: [
          //     Image.asset('assets/images/misc/planty.png'),
          //     Expanded(
          //       child: UtilFlexBox(
          //         padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          //         direction: Axis.vertical,
          //         gap: 10,
          //         children: [
          //           UtilText(
          //             "Ask Planty",
          //             size: 25,
          //             family: Fonts.defaultFontMedium,
          //             color: colorAccent.primaryText,
          //           ),
          //           UtilText(
          //             "Our Planty is ready to help with your plant related problems and more!",
          //             size: 15,
          //             family: Fonts.defaultFontThin,
          //             color: colorAccent.secondaryText,
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),

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
                children: plants.fromExplorePlants(),
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
    required this.plantId
  });

  final String plantId;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? plantGet = plants.getPlantById(plantId);

    return UtilFitImage(
      plantGet?["image_url"],
      onTap: () {
        navigateTo(context, animationType: NavAnimation.slideUp, duration: preferredAnimations.getDuration(), page: PlantInfoScreen(plantData: plantGet?? {}));
      },
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
          plantGet?["plant_name"]?? "null",
          family: Fonts.defaultFontRegular,
          color: colorAccent.white,
          size: 18,
        ),
      ),
    );
  }
}

class HomeWeatherCard extends StatelessWidget {
  final WeatherData? weatherData;
  final bool loading;

  const HomeWeatherCard({
    super.key,
    required this.weatherData,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return UtilFlexBox(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      gap: 10,
      children: [
        UtilText(
          "Weather Today",
          color: colorAccent.primaryText,
          family: Fonts.defaultFontMedium,
          size: 20,
        ),
        UtilFlexBox(
          onTap: loading || weatherData == null
              ? null
              : () => navigateTo(
                    context,
                    animationType: NavAnimation.slideUp,
                    duration: preferredAnimations.getDuration(),
                    page: const WeatherScreen(),
                  ),
          main: MainAxisAlignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          direction: Axis.horizontal,
          width: double.infinity,
          height: 130,
          color: colorAccent.cardLight,
          borderRadius: BorderRadius.circular(10.0),
          children: [
            Expanded(
              child: loading
                  ? UtilFlexBox(
                      gap: 8,
                      children: [
                        _shimmer(width: 120, height: 14),
                        _shimmer(width: 80, height: 36),
                        _shimmer(width: 100, height: 12),
                      ],
                    )
                  : weatherData == null
                      ? UtilText(
                          "Weather unavailable",
                          size: 14,
                          family: Fonts.defaultFontExtraLight,
                          color: colorAccent.secondaryText,
                        )
                      : UtilFlexBox(
                          direction: Axis.vertical,
                          gap: 2,
                          children: [
                            UtilText(
                              weatherData!.locationName,
                              size: 16,
                              prefix: Icon(Icons.location_on,
                                  color: colorAccent.primaryText, size: 18),
                              family: Fonts.defaultFontExtraLight,
                              color: colorAccent.primaryText,
                            ),
                            UtilText(
                              "${weatherData!.today.tempC.round()} °C",
                              size: 40,
                              family: Fonts.defaultFontMedium,
                              color: colorAccent.primaryText,
                            ),
                            UtilText(
                              "Humidity ${weatherData!.today.humidity}%",
                              size: 15,
                              family: Fonts.defaultFontExtraLight,
                              color: colorAccent.primaryText,
                            ),
                          ],
                        ),
            ),
            if (!loading && weatherData != null)
              SvgPicture.asset(
                weatherData!.today.condition.svgAsset,
                width: 75,
                height: 75,
                colorFilter: ColorFilter.mode(
                    colorAccent.secondary, BlendMode.srcIn),
              )
            else if (loading)
              _shimmerCircle(size: 75),
          ],
        ),
      ],
    );
  }

  // Tiny shimmer placeholders while loading
  Widget _shimmer({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  Widget _shimmerCircle({required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
    );
  }
}