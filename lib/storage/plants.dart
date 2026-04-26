import 'package:flutter/material.dart';
import 'package:plantify/screen/home/home.dart';

class Plants {
  List<Map<String, dynamic>> plants = [
    {
      "id": "plant_Kr39zy4CgvCFtYmHnLVEmrlGaIR9rx",
      "plant_name": "Sunflower",
      "genus": "Helianthus",
      "family": "Asteraceae",
      "scientific_name": "Helianthus annuus",
      "image_url": "assets/images/plants/sunflower.jpg",

      "description": {
        "general":
        "A tall annual plant known for its large bright yellow flower head that follows the sun during early growth stages.",
        "plant_type": "Herb",
      },

      "distribution": {
        "asia": "Cultivated",
        "africa": "Cultivated",
        "north_america": "Native",
        "south_america": "Cultivated",
        "antarctica": "Unreported",
        "europe": "Cultivated",
        "australia": "Cultivated",
      },

      "growing_conditions": {
        "temperature_range": "18-33°C",
        "sunlight": "Full sun",
        "soil_type": "Loamy",
        "soil_ph": "6.0-7.5",
        "drainage": "Well-drained",
        "growth_rate": "Fast",
      },

      "toxicity": {
        "level": "Non-toxic",
        "toxic_to": "None",
        "toxic_parts": "None",
      },

      "care_guide": {
        "watering": "Moderate",
        "fertilizing": "Monthly",
        "propagation": ["Seeds"],
        "repotting": "Not required",
        "humidity": "Low-Medium",
      },

      "pests_diseases": {
        "pests": ["Aphids"],
        "diseases": ["Powdery mildew"],
        "treatment": "Use neem oil and ensure good air circulation",
      },

      "uses": ["Ornamental", "Culinary", "Industrial"],
      "features": ["Sun-tracking", "Fast-growing"],
    },

    {
      "id": "plant_uSRLtpnROLiwtwEPj8BRcIip2SgnL8",
      "plant_name": "Rose",
      "genus": "Rosa",
      "family": "Rosaceae",
      "scientific_name": "Rosa spp.",
      "image_url": "assets/images/plants/rose.webp",

      "description": {
        "general":
        "Woody perennial shrub known for its fragrant flowers and thorny stems.",
        "plant_type": "Shrub",
      },

      "distribution": {
        "asia": "Native",
        "africa": "Cultivated",
        "north_america": "Native",
        "south_america": "Cultivated",
        "antarctica": "Unreported",
        "europe": "Native",
        "australia": "Cultivated",
      },

      "growing_conditions": {
        "temperature_range": "15-28°C",
        "sunlight": "Full sun",
        "soil_type": "Loamy",
        "soil_ph": "6.0-6.5",
        "drainage": "Well-drained",
        "growth_rate": "Moderate",
      },

      "toxicity": {
        "level": "Non-toxic",
        "toxic_to": "None",
        "toxic_parts": "None",
      },

      "care_guide": {
        "watering": "Regular",
        "fertilizing": "Monthly",
        "propagation": ["Cuttings", "Grafting"],
        "repotting": "Every 2-3 years",
        "humidity": "Medium",
      },

      "pests_diseases": {
        "pests": ["Aphids"],
        "diseases": ["Black spot"],
        "treatment": "Prune infected leaves and apply fungicide",
      },

      "uses": ["Ornamental", "Perfume", "Medicinal"],
      "features": ["Fragrant", "Thorny stems"],
    },

    {
      "id": "plant_H3KegveI1wPzF8DdvpS5AJwKXAq81s",
      "plant_name": "Basil",
      "genus": "Ocimum",
      "family": "Lamiaceae",
      "scientific_name": "Ocimum basilicum",
      "image_url": "assets/images/plants/basil.jpg",

      "description": {
        "general":
        "Aromatic herb widely used in cooking and traditional medicine.",
        "plant_type": "Herb",
      },

      "distribution": {
        "asia": "Native",
        "africa": "Cultivated",
        "north_america": "Cultivated",
        "south_america": "Cultivated",
        "antarctica": "Unreported",
        "europe": "Cultivated",
        "australia": "Cultivated",
      },

      "growing_conditions": {
        "temperature_range": "20-30°C",
        "sunlight": "Full sun",
        "soil_type": "Loamy",
        "soil_ph": "6.0-7.0",
        "drainage": "Well-drained",
        "growth_rate": "Fast",
      },

      "toxicity": {
        "level": "Non-toxic",
        "toxic_to": "None",
        "toxic_parts": "None",
      },

      "care_guide": {
        "watering": "Frequent",
        "fertilizing": "Biweekly",
        "propagation": ["Seeds", "Cuttings"],
        "repotting": "As needed",
        "humidity": "Medium",
      },

      "pests_diseases": {
        "pests": ["Whiteflies"],
        "diseases": ["Downy mildew"],
        "treatment": "Avoid overhead watering",
      },

      "uses": ["Culinary", "Medicinal"],
      "features": ["Fragrant", "Fast-growing"],
    },

    {
      "id": "plant_CuckBVDGSoF53FLLdKfSQjCqoA6L69",
      "plant_name": "Rafflesia",
      "genus": "Rafflesia",
      "family": "Rafflesiaceae",
      "scientific_name": "Rafflesia arnoldii",
      "image_url": "assets/images/plants/rafflesia.jpg",

      "description": {
        "general":
        "A parasitic plant producing the world's largest individual flower, emitting a strong odor of decaying flesh.",
        "plant_type": "Parasitic",
      },

      "distribution": {
        "asia": "Native",
        "africa": "Unreported",
        "north_america": "Unreported",
        "south_america": "Unreported",
        "antarctica": "Unreported",
        "europe": "Unreported",
        "australia": "Unreported",
      },

      "growing_conditions": {
        "temperature_range": "25-35°C",
        "sunlight": "Filtered shade",
        "soil_type": "Host-dependent",
        "soil_ph": "Variable",
        "drainage": "Moist",
        "growth_rate": "Very slow",
      },

      "toxicity": {
        "level": "Unknown",
        "toxic_to": "Unknown",
        "toxic_parts": "Unknown",
      },

      "care_guide": {
        "watering": "Not applicable",
        "fertilizing": "Not applicable",
        "propagation": ["Parasitic reproduction"],
        "repotting": "Not possible",
        "humidity": "High",
      },

      "pests_diseases": {
        "pests": [],
        "diseases": [],
        "treatment": "Not applicable",
      },

      "uses": ["Scientific"],
      "features": ["Largest flower", "Foul odor"],
    },
    {
      "id": "plant_A8fK29LmN3xPqR7tY2vB4cD8eF1gH5",
      "plant_name": "Hosta",
      "genus": "Hosta",
      "family": "Asparagaceae",
      "scientific_name": "Hosta spp.",
      "image_url": "assets/images/plants/hostas.webp",

      "description": {
        "general":
        "Shade-loving perennial known for its broad decorative foliage and occasional lavender or white flowers.",
        "plant_type": "Herb",
      },

      "distribution": {
        "asia": "Native",
        "africa": "Unreported",
        "north_america": "Cultivated",
        "south_america": "Cultivated",
        "antarctica": "Unreported",
        "europe": "Cultivated",
        "australia": "Cultivated",
      },

      "growing_conditions": {
        "temperature_range": "10-30°C",
        "sunlight": "Partial to full shade",
        "soil_type": "Loamy",
        "soil_ph": "6.0-7.5",
        "drainage": "Moist",
        "growth_rate": "Moderate",
      },

      "toxicity": {
        "level": "Mildly toxic",
        "toxic_to": "Pets",
        "toxic_parts": "Leaves",
      },

      "care_guide": {
        "watering": "Regular",
        "fertilizing": "Monthly",
        "propagation": ["Division"],
        "repotting": "Every 2-3 years",
        "humidity": "Medium",
      },

      "pests_diseases": {
        "pests": ["Slugs"],
        "diseases": ["Leaf spot"],
        "treatment": "Use slug control and remove infected leaves",
      },

      "uses": ["Ornamental"],
      "features": ["Shade-tolerant", "Decorative foliage"],
    },

    {
      "id": "plant_R9mT2xQaL7cV4pE1sYd8B6hN5kW3uZ",
      "plant_name": "Santan",
      "genus": "Ixora",
      "family": "Rubiaceae",
      "scientific_name": "Ixora coccinea",
      "image_url": "assets/images/plants/santan.jpeg",

      "description": {
        "general":
        "Tropical shrub producing dense clusters of bright red, orange, or yellow flowers.",
        "plant_type": "Shrub",
      },

      "distribution": {
        "asia": "Native",
        "africa": "Cultivated",
        "north_america": "Cultivated",
        "south_america": "Cultivated",
        "antarctica": "Unreported",
        "europe": "Cultivated",
        "australia": "Cultivated",
      },

      "growing_conditions": {
        "temperature_range": "20-35°C",
        "sunlight": "Full sun",
        "soil_type": "Sandy loam",
        "soil_ph": "5.0-6.5",
        "drainage": "Well-drained",
        "growth_rate": "Moderate",
      },

      "toxicity": {
        "level": "Non-toxic",
        "toxic_to": "None",
        "toxic_parts": "None",
      },

      "care_guide": {
        "watering": "Frequent",
        "fertilizing": "Monthly",
        "propagation": ["Cuttings"],
        "repotting": "Every 2 years",
        "humidity": "High",
      },

      "pests_diseases": {
        "pests": ["Aphids"],
        "diseases": ["Leaf spot"],
        "treatment": "Use insecticidal soap",
      },

      "uses": ["Ornamental"],
      "features": ["Tropical flowering", "Evergreen"],
    },

    {
      "id": "plant_Zx7Qp4Lm8cN1VaD5sH2Yk3E6R9TgFb",
      "plant_name": "Zinnia",
      "genus": "Zinnia",
      "family": "Asteraceae",
      "scientific_name": "Zinnia elegans",
      "image_url": "assets/images/plants/zinnia.jpg",

      "description": {
        "general":
        "Bright flowering annual plant with a wide range of colors, popular in gardens.",
        "plant_type": "Herb",
      },

      "distribution": {
        "asia": "Cultivated",
        "africa": "Cultivated",
        "north_america": "Native",
        "south_america": "Cultivated",
        "antarctica": "Unreported",
        "europe": "Cultivated",
        "australia": "Cultivated",
      },

      "growing_conditions": {
        "temperature_range": "18-30°C",
        "sunlight": "Full sun",
        "soil_type": "Loamy",
        "soil_ph": "5.5-7.5",
        "drainage": "Well-drained",
        "growth_rate": "Fast",
      },

      "toxicity": {
        "level": "Non-toxic",
        "toxic_to": "None",
        "toxic_parts": "None",
      },

      "care_guide": {
        "watering": "Moderate",
        "fertilizing": "Monthly",
        "propagation": ["Seeds"],
        "repotting": "Not required",
        "humidity": "Low",
      },

      "pests_diseases": {
        "pests": ["Aphids"],
        "diseases": ["Powdery mildew"],
        "treatment": "Ensure proper spacing",
      },

      "uses": ["Ornamental"],
      "features": ["Colorful blooms", "Easy to grow"],
    },

    {
      "id": "plant_U2kP8LmD4Vx9cA1Zs7QeR5yT3nH6Fb",
      "plant_name": "Coconut",
      "genus": "Cocos",
      "family": "Arecaceae",
      "scientific_name": "Cocos nucifera",
      "image_url": "assets/images/plants/coconut.webp",

      "description": {
        "general":
        "Tall palm tree producing coconuts used for food, oil, and materials.",
        "plant_type": "Tree",
      },

      "distribution": {
        "asia": "Native",
        "africa": "Native",
        "north_america": "Cultivated",
        "south_america": "Native",
        "antarctica": "Unreported",
        "europe": "Unreported",
        "australia": "Native",
      },

      "growing_conditions": {
        "temperature_range": "25-35°C",
        "sunlight": "Full sun",
        "soil_type": "Sandy",
        "soil_ph": "5.0-8.0",
        "drainage": "Well-drained",
        "growth_rate": "Moderate",
      },

      "toxicity": {
        "level": "Non-toxic",
        "toxic_to": "None",
        "toxic_parts": "None",
      },

      "care_guide": {
        "watering": "Frequent",
        "fertilizing": "Quarterly",
        "propagation": ["Seed (nut)"],
        "repotting": "Not applicable",
        "humidity": "High",
      },

      "pests_diseases": {
        "pests": ["Coconut beetle"],
        "diseases": ["Leaf blight"],
        "treatment": "Maintain tree health",
      },

      "uses": ["Culinary", "Industrial"],
      "features": ["Salt-tolerant", "Tropical"],
    },

    {
      "id": "plant_H7sD2kL9PqX4cM8V1A5Tn6ZyR3EwFb",
      "plant_name": "Mango",
      "genus": "Mangifera",
      "family": "Anacardiaceae",
      "scientific_name": "Mangifera indica",
      "image_url": "assets/images/plants/mango.jpg",

      "description": {
        "general": "Tropical fruit tree producing sweet edible mango fruits.",
        "plant_type": "Tree",
      },

      "distribution": {
        "asia": "Native",
        "africa": "Cultivated",
        "north_america": "Cultivated",
        "south_america": "Cultivated",
        "antarctica": "Unreported",
        "europe": "Cultivated",
        "australia": "Cultivated",
      },

      "growing_conditions": {
        "temperature_range": "24-35°C",
        "sunlight": "Full sun",
        "soil_type": "Loamy",
        "soil_ph": "5.5-7.5",
        "drainage": "Well-drained",
        "growth_rate": "Moderate",
      },

      "toxicity": {
        "level": "Mildly toxic",
        "toxic_to": "Humans",
        "toxic_parts": "Sap",
      },

      "care_guide": {
        "watering": "Moderate",
        "fertilizing": "Seasonal",
        "propagation": ["Grafting", "Seeds"],
        "repotting": "Not applicable",
        "humidity": "Medium",
      },

      "pests_diseases": {
        "pests": ["Fruit flies"],
        "diseases": ["Anthracnose"],
        "treatment": "Use fungicides",
      },

      "uses": ["Culinary"],
      "features": ["Fruit-bearing", "Long-lived"],
    },

    {
      "id": "plant_P9Q2LmT6xZ4cA8V1kR5sD7H3EwYbFn",
      "plant_name": "Hibiscus",
      "genus": "Hibiscus",
      "family": "Malvaceae",
      "scientific_name": "Hibiscus rosa-sinensis",
      "image_url": "assets/images/plants/hibiscus.webp",

      "description": {
        "general":
        "Flowering tropical shrub known for its large colorful blooms.",
        "plant_type": "Shrub",
      },

      "distribution": {
        "asia": "Native",
        "africa": "Cultivated",
        "north_america": "Cultivated",
        "south_america": "Cultivated",
        "antarctica": "Unreported",
        "europe": "Cultivated",
        "australia": "Cultivated",
      },

      "growing_conditions": {
        "temperature_range": "20-35°C",
        "sunlight": "Full sun",
        "soil_type": "Loamy",
        "soil_ph": "6.0-7.0",
        "drainage": "Well-drained",
        "growth_rate": "Moderate",
      },

      "toxicity": {
        "level": "Non-toxic",
        "toxic_to": "Pets",
        "toxic_parts": "None",
      },

      "care_guide": {
        "watering": "Frequent",
        "fertilizing": "Biweekly",
        "propagation": ["Cuttings"],
        "repotting": "Every 2-3 years",
        "humidity": "High",
      },

      "pests_diseases": {
        "pests": ["Whiteflies"],
        "diseases": ["Leaf spot"],
        "treatment": "Use insecticidal soap",
      },

      "uses": ["Ornamental", "Medicinal"],
      "features": ["Large flowers", "Continuous blooming"],
    },
  ];

  List<Widget> fromExplorePlants() {
    return List.generate(
      plants.length,
          (i) =>
          ExplorePlants(
            plantId: plants[i]['id'] ?? ""
          ),
    );
  }

  Map<String, dynamic>? getPlantById(String id) {
    return plants.where((item) => item['id'] == id).isNotEmpty
      ? plants.firstWhere((item) => item['id'] == id)
      : null;
  }
}

Plants plants = Plants();