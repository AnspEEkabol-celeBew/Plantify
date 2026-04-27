import 'dart:math';

import 'package:flutter/material.dart';

import '../theme/colors.dart';

class ComingSoon extends StatelessWidget {
  const ComingSoon({super.key, this.additionalMessage});

  final String? additionalMessage;

  @override
  Widget build(BuildContext context) {
    return Text("Coming Soon! '$additionalMessage'");
  }
}

class ReactiveBuilder extends StatelessWidget {
  final Widget Function() builder;

  const ReactiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: darkMode,
      builder: (_, __, ___) => builder(),
    );
  }
}

int randomInt(int min, int max) {
  return (min + Random().nextInt((max + 1) - min)).floor();
}

String generateUsername() {
  List<String> first = [
    "Green",
    "Blooming",
    "Wild",
    "Lush",
    "Persistent",
    "Rooted",
    "Evergreen",
    "Thriving",
    "Verdant",
    "Floral",
    "Leafy",
    "Sun-kissed",
    "Earthy",
    "Fertile",
    "Native",
    "Grafted",
    "Pruned",
    "Hardy",
    "Organic",
    "Dewy",
    "Fragrant",
    "Sprouting",
    "Tangled",
    "Sunny",
    "Overgrown",
    "Silent",
    "Peaceful",
    "Perennial",
    "Ancient",
    "Young",
    "Golden",
    "Shady",
    "Humble",
    "Majestic",
    "Vibrant",
    "Natural",
    "Nurturing",
    "Wandering",
    "Climbing",
    "Cottage",
    "Rustic",
    "Bright",
    "Flowering",
    "Deep",
    "Budding",
    "Fresh",
    "Velvet",
    "Mossy",
    "Patient",
    "Radiant",
  ];
  List<String> second = [
    "Planter",
    "Naturer",
    "Gardener",
    "Sprout",
    "Seedling",
    "Botanist",
    "Harvester",
    "Cultivator",
    "Florist",
    "Bloom",
    "Root",
    "Branch",
    "Leaf",
    "Petal",
    "Sapling",
    "Orchardist",
    "Forest",
    "Meadow",
    "Wildflower",
    "Keeper",
    "Grower",
    "Tender",
    "Earth",
    "Stem",
    "Thicket",
    "Vine",
    "Willow",
    "Fern",
    "Moss",
    "Clover",
    "Sower",
    "Bramble",
    "Shrub",
    "Woods",
    "Haven",
    "Patio",
    "Landscape",
    "Grounds",
    "Greenery",
    "Flora",
    "Grove",
    "Blossom",
    "Meadow",
    "Field",
    "Terrain",
    "Bush",
    "Tree",
    "Cactus",
    "Sage",
    "Cedar",
  ];
  return "${first[randomInt(0, first.length-1)]} ${second[randomInt(0, second.length-1)]}";
}

String removeIdFromLabel(String label) {//1 name
  return label.substring(label.indexOf(" ")+1,label.length);
}