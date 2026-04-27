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
      "label_name": "sunflower",

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
      "label_name": "rose",

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
      "label_name": "basil",

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
      "label_name": "raflessia",

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
      "label_name": "hostas",

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
      "label_name": "santan",

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
      "label_name": "zinniaflower",

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
      "label_name": "coconut",

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
      "label_name": "mango",

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
      "label_name": "hibiscus",

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
    {
      "id": "plant_M7nQ2xLpT6cA9V1kR5sD3H8EwYbFj",
      "plant_name": "Musical Note Bush",
      "genus": "Mussaenda",
      "family": "Rubiaceae",
      "scientific_name": "Mussaenda philippica 'Auring'",
      "image_url": "assets/images/plants/musicalnote.jpg",
      "label_name": "musicalnotebush",
      "description": {
        "general":
            "A tropical ornamental shrub native to the Philippines, admired for its uniquely shaped bracts that resemble musical notes, with creamy white or yellow flowers surrounded by large decorative sepals.",
        "plant_type": "Shrub",
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
        "temperature_range": "22-35°C",
        "sunlight": "Full sun",
        "soil_type": "Loamy",
        "soil_ph": "5.5-6.5",
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
        "propagation": ["Cuttings", "Air layering"],
        "repotting": "Every 2 years",
        "humidity": "High",
      },
      "pests_diseases": {
        "pests": ["Aphids", "Scale insects"],
        "diseases": ["Powdery mildew", "Root rot"],
        "treatment":
            "Use neem oil or insecticidal soap; improve drainage for root rot",
      },
      "uses": ["Ornamental", "Landscaping"],
      "features": [
        "Unique bract shape",
        "Continuous blooming",
        "Attracts butterflies",
      ],
    },
    {
      "id": "plant_R3dM8xQpT2cB7V4kN6sL1H5EwYjFz",
      "plant_name": "Red Mussaenda Queen",
      "genus": "Mussaenda",
      "family": "Rubiaceae",
      "scientific_name": "Mussaenda erythrophylla",
      "image_url": "assets/images/plants/redmussaendaqueen.jpg",
      "label_name": "redmussaendaqueen",
      "description": {
        "general":
            "A striking tropical shrub with brilliant red enlarged sepals surrounding small yellow flowers. Widely grown as an ornamental in tropical gardens for its vivid crimson display.",
        "plant_type": "Shrub",
      },
      "distribution": {
        "asia": "Cultivated",
        "africa": "Native",
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
        "soil_ph": "5.5-6.5",
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
        "fertilizing": "Biweekly",
        "propagation": ["Cuttings", "Air layering"],
        "repotting": "Every 2 years",
        "humidity": "High",
      },
      "pests_diseases": {
        "pests": ["Aphids", "Mealybugs"],
        "diseases": ["Leaf spot", "Powdery mildew"],
        "treatment": "Apply neem oil spray; remove infected leaves promptly",
      },
      "uses": ["Ornamental", "Landscaping"],
      "features": [
        "Brilliant red bracts",
        "Long blooming season",
        "Attracts hummingbirds",
      ],
    },
    {
      "id": "plant_P4kH9xNqT7cB2V5mR8sL3G6EwYdFa",
      "plant_name": "Pink Hoya",
      "genus": "Hoya",
      "family": "Apocynaceae",
      "scientific_name": "Hoya carnosa",
      "image_url": "assets/images/plants/pinkhoya.jpg",
      "label_name": "pinkhoya",
      "description": {
        "general":
            "A popular trailing tropical succulent vine known for its clusters of waxy, star-shaped pink flowers with a sweet fragrance. Thrives indoors and is prized for its low-maintenance nature and long lifespan.",
        "plant_type": "Vine",
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
        "temperature_range": "15-30°C",
        "sunlight": "Partial shade to bright indirect light",
        "soil_type": "Sandy loam",
        "soil_ph": "6.0-7.0",
        "drainage": "Well-drained",
        "growth_rate": "Slow to moderate",
      },
      "toxicity": {
        "level": "Non-toxic",
        "toxic_to": "None",
        "toxic_parts": "None",
      },
      "care_guide": {
        "watering": "Infrequent",
        "fertilizing": "Monthly during growing season",
        "propagation": ["Stem cuttings", "Layering"],
        "repotting": "Every 2-3 years",
        "humidity": "Moderate to high",
      },
      "pests_diseases": {
        "pests": ["Mealybugs", "Spider mites", "Scale insects"],
        "diseases": ["Root rot", "Botrytis blight"],
        "treatment":
            "Wipe leaves with alcohol-soaked cotton; avoid overwatering",
      },
      "uses": ["Ornamental", "Indoor plant"],
      "features": [
        "Waxy star-shaped flowers",
        "Fragrant blooms",
        "Long-lived houseplant",
      ],
    },
    {
      "id": "plant_O2kP7xLqT4cB9V3mR6sN1H8EwYcFb",
      "plant_name": "Okra Plant",
      "genus": "Abelmoschus",
      "family": "Malvaceae",
      "scientific_name": "Abelmoschus esculentus",
      "image_url": "assets/images/plants/okra.jpg",
      "label_name": "okra",
      "description": {
        "general":
            "A warm-season vegetable crop cultivated widely in tropical and subtropical regions for its edible green seed pods. Known for its high mucilage content and nutritional value, it also bears attractive yellow hibiscus-like flowers.",
        "plant_type": "Annual herb",
      },
      "distribution": {
        "asia": "Cultivated",
        "africa": "Native",
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
        "soil_ph": "6.0-6.8",
        "drainage": "Well-drained",
        "growth_rate": "Fast",
      },
      "toxicity": {
        "level": "Non-toxic",
        "toxic_to": "None",
        "toxic_parts": "None",
      },
      "care_guide": {
        "watering": "Regular",
        "fertilizing": "Every 3-4 weeks",
        "propagation": ["Seeds"],
        "repotting": "Not applicable",
        "humidity": "Moderate",
      },
      "pests_diseases": {
        "pests": ["Aphids", "Whiteflies", "Corn earworm"],
        "diseases": ["Fusarium wilt", "Powdery mildew", "Root rot"],
        "treatment":
            "Use insecticidal soap for pests; practice crop rotation for fungal diseases",
      },
      "uses": ["Culinary", "Medicinal", "Industrial (fiber)"],
      "features": [
        "Edible pods",
        "Hibiscus-like flowers",
        "High nutritional value",
      ],
    },
    {
      "id": "plant_F5sP1xLqT9cA7V2mR4kN8H3EwYbGc",
      "plant_name": "Passion Flower",
      "genus": "Passiflora",
      "family": "Passifloraceae",
      "scientific_name": "Passiflora incarnata",
      "image_url": "assets/images/plants/passionflower.jpeg",
      "label_name": "passionflower",
      "description": {
        "general":
            "A vigorous climbing vine renowned for its intricate, exotic-looking flowers with a crown of blue and white filaments. Produces edible fruits and is also used medicinally for its calming properties.",
        "plant_type": "Vine",
      },
      "distribution": {
        "asia": "Cultivated",
        "africa": "Cultivated",
        "north_america": "Native",
        "south_america": "Native",
        "antarctica": "Unreported",
        "europe": "Cultivated",
        "australia": "Exotic",
      },
      "growing_conditions": {
        "temperature_range": "10-30°C",
        "sunlight": "Full sun to partial shade",
        "soil_type": "Loamy",
        "soil_ph": "6.0-7.5",
        "drainage": "Well-drained",
        "growth_rate": "Fast",
      },
      "toxicity": {
        "level": "Mildly toxic",
        "toxic_to": "Pets, Humans (in large quantities)",
        "toxic_parts": "Leaves, unripe fruit",
      },
      "care_guide": {
        "watering": "Regular",
        "fertilizing": "Monthly",
        "propagation": ["Seeds", "Cuttings"],
        "repotting": "Every 1-2 years",
        "humidity": "Moderate",
      },
      "pests_diseases": {
        "pests": ["Spider mites", "Aphids", "Whiteflies"],
        "diseases": ["Fusarium wilt", "Alternaria spot"],
        "treatment": "Use neem oil; ensure good air circulation",
      },
      "uses": ["Ornamental", "Medicinal", "Culinary"],
      "features": [
        "Exotic intricate flowers",
        "Edible fruit",
        "Fast-growing climber",
      ],
    },
    {
      "id": "plant_B6nA3xPqT8cM5V1kR9sL2H7EwYdFe",
      "plant_name": "Banana",
      "genus": "Musa",
      "family": "Musaceae",
      "scientific_name": "Musa acuminata",
      "image_url": "assets/images/plants/banana.jpg",
      "label_name": "banana",
      "description": {
        "general":
            "A large herbaceous plant producing one of the world's most popular fruits. Characterized by its massive paddle-shaped leaves and a terminal inflorescence that develops into a bunch of curved yellow fruits.",
        "plant_type": "Herbaceous plant",
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
        "soil_ph": "5.5-7.0",
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
        "fertilizing": "Every 3-4 weeks",
        "propagation": ["Suckers", "Corms"],
        "repotting": "Not applicable",
        "humidity": "High",
      },
      "pests_diseases": {
        "pests": ["Banana weevil", "Aphids", "Nematodes"],
        "diseases": ["Panama disease", "Black Sigatoka", "Bunchy top virus"],
        "treatment":
            "Remove infected plants; use disease-resistant cultivars; apply fungicides as needed",
      },
      "uses": ["Culinary", "Medicinal", "Fiber production", "Ornamental"],
      "features": [
        "Large paddle leaves",
        "Rapid growth",
        "Edible fruit and flower",
      ],
    },
    {
      "id": "plant_C9sR4xLqT1cA6V8mP2kN5H7EwYbFf",
      "plant_name": "Rice",
      "genus": "Oryza",
      "family": "Poaceae",
      "scientific_name": "Oryza sativa",
      "image_url": "assets/images/plants/rice.jpg",
      "label_name": "rice",
      "description": {
        "general":
            "The world's most important staple grain crop, cultivated in flooded paddies across tropical and subtropical Asia. A semi-aquatic annual grass that forms the dietary foundation for billions of people worldwide.",
        "plant_type": "Annual grass",
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
        "temperature_range": "20-37°C",
        "sunlight": "Full sun",
        "soil_type": "Clay to loamy",
        "soil_ph": "5.5-6.5",
        "drainage": "Flooded or waterlogged",
        "growth_rate": "Moderate",
      },
      "toxicity": {
        "level": "Non-toxic",
        "toxic_to": "None",
        "toxic_parts": "None",
      },
      "care_guide": {
        "watering": "Frequent (flooded paddies)",
        "fertilizing": "At planting and mid-season",
        "propagation": ["Seeds"],
        "repotting": "Not applicable",
        "humidity": "High",
      },
      "pests_diseases": {
        "pests": ["Brown planthopper", "Stem borer", "Rice bug"],
        "diseases": ["Blast disease", "Bacterial blight", "Sheath rot"],
        "treatment":
            "Use resistant varieties; apply recommended pesticides; maintain proper water management",
      },
      "uses": ["Culinary", "Industrial (starch, paper)", "Animal feed"],
      "features": [
        "Primary world food crop",
        "Grows in flooded fields",
        "Highly adaptable cultivars",
      ],
    },
    {
      "id": "plant_A1yP6xQqT3cB8V5mR2kN9H4EwYcFg",
      "plant_name": "Papaya",
      "genus": "Carica",
      "family": "Caricaceae",
      "scientific_name": "Carica papaya",
      "image_url": "assets/images/plants/papaya.jpg",
      "label_name": "papaya",
      "description": {
        "general":
            "A fast-growing tropical tree with a soft, hollow trunk topped by a crown of large palmate leaves. Produces large, sweet orange-fleshed fruits and contains papain, a digestive enzyme used medicinally and commercially.",
        "plant_type": "Tree (soft-wooded)",
      },
      "distribution": {
        "asia": "Cultivated",
        "africa": "Cultivated",
        "north_america": "Native",
        "south_america": "Native",
        "antarctica": "Unreported",
        "europe": "Cultivated",
        "australia": "Cultivated",
      },
      "growing_conditions": {
        "temperature_range": "21-33°C",
        "sunlight": "Full sun",
        "soil_type": "Sandy loam",
        "soil_ph": "6.0-6.5",
        "drainage": "Well-drained",
        "growth_rate": "Fast",
      },
      "toxicity": {
        "level": "Mildly toxic",
        "toxic_to": "Pets (latex and unripe fruit)",
        "toxic_parts": "Unripe fruit, latex, seeds (in large amounts)",
      },
      "care_guide": {
        "watering": "Regular",
        "fertilizing": "Every 2 weeks",
        "propagation": ["Seeds"],
        "repotting": "Not applicable",
        "humidity": "Moderate to high",
      },
      "pests_diseases": {
        "pests": ["Papaya mealybug", "Fruit fly", "Spider mites"],
        "diseases": [
          "Papaya ringspot virus",
          "Anthracnose",
          "Phytophthora rot",
        ],
        "treatment":
            "Use virus-resistant varieties; apply copper fungicide; remove infected fruit promptly",
      },
      "uses": ["Culinary", "Medicinal", "Industrial (papain enzyme)"],
      "features": [
        "Fast fruiting",
        "Edible leaves and fruit",
        "Papain enzyme content",
      ],
    },
    {
      "id": "plant_G8nB5xMqT2cP7V4kR1sL6H3EwYdFh",
      "plant_name": "Bougainvillea",
      "genus": "Bougainvillea",
      "family": "Nyctaginaceae",
      "scientific_name": "Bougainvillea spectabilis",
      "image_url": "assets/images/plants/bougainvillea.png",
      "label_name": "bougainvillea",
      "description": {
        "general":
            "A vigorous tropical climbing shrub celebrated for its brilliant papery bracts in shades of magenta, red, orange, white, and purple. Widely used in tropical landscaping and thrives in hot, dry conditions.",
        "plant_type": "Climbing shrub",
      },
      "distribution": {
        "asia": "Cultivated",
        "africa": "Cultivated",
        "north_america": "Cultivated",
        "south_america": "Native",
        "antarctica": "Unreported",
        "europe": "Cultivated",
        "australia": "Cultivated",
      },
      "growing_conditions": {
        "temperature_range": "18-35°C",
        "sunlight": "Full sun",
        "soil_type": "Loamy to sandy",
        "soil_ph": "5.5-6.0",
        "drainage": "Well-drained",
        "growth_rate": "Fast",
      },
      "toxicity": {
        "level": "Mildly toxic",
        "toxic_to": "Pets, Humans",
        "toxic_parts": "Thorns, sap (skin irritant)",
      },
      "care_guide": {
        "watering": "Infrequent",
        "fertilizing": "Monthly",
        "propagation": ["Cuttings"],
        "repotting": "Every 2-3 years",
        "humidity": "Low to moderate",
      },
      "pests_diseases": {
        "pests": ["Aphids", "Caterpillars", "Mealybugs"],
        "diseases": ["Leaf spot", "Root rot"],
        "treatment":
            "Use insecticidal soap; avoid overwatering to prevent root rot",
      },
      "uses": ["Ornamental", "Landscaping", "Erosion control"],
      "features": [
        "Vivid papery bracts",
        "Drought tolerant",
        "Prolific bloomer",
      ],
    },
    {
      "id": "plant_D3kN7xPqT5cA1V9mR8sB4H2EwYjFi",
      "plant_name": "Orchid",
      "genus": "Phalaenopsis",
      "family": "Orchidaceae",
      "scientific_name": "Phalaenopsis amabilis",
      "image_url": "assets/images/plants/orchid.webp",
      "label_name": "orchid",
      "description": {
        "general":
            "One of the most popular ornamental flowering plants worldwide, the moth orchid produces elegant arching sprays of long-lasting white to pink blooms. A tropical epiphyte native to Southeast Asia and widely cultivated as a houseplant.",
        "plant_type": "Epiphytic herb",
      },
      "distribution": {
        "asia": "Native",
        "africa": "Cultivated",
        "north_america": "Cultivated",
        "south_america": "Cultivated",
        "antarctica": "Unreported",
        "europe": "Cultivated",
        "australia": "Native",
      },
      "growing_conditions": {
        "temperature_range": "18-30°C",
        "sunlight": "Bright indirect light",
        "soil_type": "Bark-based orchid mix",
        "soil_ph": "5.5-6.5",
        "drainage": "Excellent (epiphytic)",
        "growth_rate": "Slow",
      },
      "toxicity": {
        "level": "Non-toxic",
        "toxic_to": "None",
        "toxic_parts": "None",
      },
      "care_guide": {
        "watering": "Weekly (allow to dry between watering)",
        "fertilizing": "Biweekly with orchid fertilizer",
        "propagation": ["Keiki offsets", "Division"],
        "repotting": "Every 1-2 years",
        "humidity": "High",
      },
      "pests_diseases": {
        "pests": ["Scale insects", "Mealybugs", "Spider mites"],
        "diseases": ["Root rot", "Crown rot", "Botrytis blight"],
        "treatment":
            "Remove pests manually or with rubbing alcohol; avoid crown watering",
      },
      "uses": ["Ornamental", "Cut flowers", "Perfumery"],
      "features": [
        "Long-lasting blooms",
        "Elegant arching sprays",
        "Wide color variety",
      ],
    },
    {
      "id": "plant_S9mJ1xLqT6cA4V7kR3nB8H5EwYcFk",
      "plant_name": "Sampaguita",
      "genus": "Jasminum",
      "family": "Oleaceae",
      "scientific_name": "Jasminum sambac",
      "image_url": "assets/images/plants/sampaguita.jpg",
      "label_name": "sampaguita",
      "description": {
        "general":
            "The national flower of the Philippines, sampaguita is a small tropical shrub or climbing plant bearing intensely fragrant white star-shaped flowers. Highly revered culturally and used in garlands, religious offerings, and perfumery.",
        "plant_type": "Shrub / Climber",
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
        "temperature_range": "18-35°C",
        "sunlight": "Full sun",
        "soil_type": "Loamy",
        "soil_ph": "6.0-7.0",
        "drainage": "Well-drained",
        "growth_rate": "Moderate to fast",
      },
      "toxicity": {
        "level": "Non-toxic",
        "toxic_to": "None",
        "toxic_parts": "None",
      },
      "care_guide": {
        "watering": "Regular",
        "fertilizing": "Monthly",
        "propagation": ["Cuttings", "Layering"],
        "repotting": "Every 2 years",
        "humidity": "Moderate to high",
      },
      "pests_diseases": {
        "pests": ["Aphids", "Spider mites", "Mealybugs"],
        "diseases": ["Leaf blight", "Root rot"],
        "treatment": "Spray with neem oil; ensure proper soil drainage",
      },
      "uses": ["Ornamental", "Cultural/Religious", "Perfumery", "Medicinal"],
      "features": [
        "Intense fragrance",
        "National flower of the Philippines",
        "Continuous blooming",
      ],
    },
    {
      "id": "plant_K2nC8xPqT4cB6V3mR7sL9H1EwYaFl",
      "plant_name": "Caladium",
      "genus": "Caladium",
      "family": "Araceae",
      "scientific_name": "Caladium bicolor",
      "image_url": "assets/images/plants/caladium.webp",
      "label_name": "caladium",
      "description": {
        "general":
            "A tropical tuberous plant prized for its spectacular heart-shaped leaves in vivid combinations of red, pink, white, and green. Grown as an ornamental foliage plant in gardens and indoors, it goes dormant in cooler months.",
        "plant_type": "Tuberous herb",
      },
      "distribution": {
        "asia": "Cultivated",
        "africa": "Cultivated",
        "north_america": "Cultivated",
        "south_america": "Native",
        "antarctica": "Unreported",
        "europe": "Cultivated",
        "australia": "Cultivated",
      },
      "growing_conditions": {
        "temperature_range": "21-32°C",
        "sunlight": "Partial shade to bright indirect light",
        "soil_type": "Loamy",
        "soil_ph": "5.5-6.5",
        "drainage": "Well-drained",
        "growth_rate": "Moderate",
      },
      "toxicity": {
        "level": "Toxic",
        "toxic_to": "Pets, Humans",
        "toxic_parts": "All parts (contains calcium oxalate crystals)",
      },
      "care_guide": {
        "watering": "Regular",
        "fertilizing": "Every 2-3 weeks during growing season",
        "propagation": ["Tuber division"],
        "repotting": "Annually",
        "humidity": "High",
      },
      "pests_diseases": {
        "pests": ["Aphids", "Thrips", "Spider mites"],
        "diseases": ["Tuber rot", "Fusarium wilt"],
        "treatment":
            "Apply insecticidal soap; allow soil to partially dry to prevent tuber rot",
      },
      "uses": ["Ornamental", "Indoor plant", "Garden beds"],
      "features": [
        "Spectacular patterned foliage",
        "Wide color variety",
        "Goes dormant in winter",
      ],
    },
    {
      "id": "plant_N4rT6xLqB9cA2V8mP5kH1E3wYjFdm",
      "plant_name": "Narra",
      "genus": "Pterocarpus",
      "family": "Fabaceae",
      "scientific_name": "Pterocarpus indicus",
      "image_url": "assets/images/plants/narra.jpg",
      "label_name": "narra",
      "description": {
        "general":
            "The national tree of the Philippines, narra is a large tropical hardwood tree producing fragrant yellow flowers and prized reddish timber. It is revered for its cultural significance and valuable wood used in fine furniture.",
        "plant_type": "Tree",
      },
      "distribution": {
        "asia": "Native",
        "africa": "Unreported",
        "north_america": "Cultivated",
        "south_america": "Unreported",
        "antarctica": "Unreported",
        "europe": "Cultivated",
        "australia": "Cultivated",
      },
      "growing_conditions": {
        "temperature_range": "20-35°C",
        "sunlight": "Full sun",
        "soil_type": "Loamy to clay",
        "soil_ph": "5.5-7.0",
        "drainage": "Well-drained",
        "growth_rate": "Moderate to slow",
      },
      "toxicity": {
        "level": "Non-toxic",
        "toxic_to": "None",
        "toxic_parts": "None",
      },
      "care_guide": {
        "watering": "Regular when young; drought tolerant when established",
        "fertilizing": "Annually",
        "propagation": ["Seeds", "Cuttings"],
        "repotting": "Not applicable",
        "humidity": "Moderate to high",
      },
      "pests_diseases": {
        "pests": ["Bark borers", "Termites"],
        "diseases": ["Dieback", "Root rot"],
        "treatment":
            "Apply appropriate insecticides for borers; remove infected wood promptly",
      },
      "uses": ["Timber", "Ornamental", "Medicinal", "Shade tree"],
      "features": [
        "National tree of the Philippines",
        "Fragrant yellow flowers",
        "Prized hardwood timber",
      ],
    },
    {
      "id": "plant_T7sA2xMqP5cB8V1kR4nL9H6EwYcFn",
      "plant_name": "Acacia",
      "genus": "Samanea",
      "family": "Fabaceae",
      "scientific_name": "Samanea saman",
      "image_url": "assets/images/plants/acacia.jpg",
      "label_name": "acacia",
      "description": {
        "general":
            "Commonly called Rain Tree or Monkey Pod, this large spreading tropical tree is famous for its vast canopy that closes at night and before rain. A fast-growing shade tree widely planted along Philippine roads and parks.",
        "plant_type": "Tree",
      },
      "distribution": {
        "asia": "Cultivated",
        "africa": "Cultivated",
        "north_america": "Native",
        "south_america": "Native",
        "antarctica": "Unreported",
        "europe": "Cultivated",
        "australia": "Cultivated",
      },
      "growing_conditions": {
        "temperature_range": "20-38°C",
        "sunlight": "Full sun",
        "soil_type": "Loamy",
        "soil_ph": "5.0-7.5",
        "drainage": "Well-drained",
        "growth_rate": "Fast",
      },
      "toxicity": {
        "level": "Non-toxic",
        "toxic_to": "None",
        "toxic_parts": "None",
      },
      "care_guide": {
        "watering": "Regular when young; drought tolerant when established",
        "fertilizing": "Annually when young",
        "propagation": ["Seeds", "Cuttings"],
        "repotting": "Not applicable",
        "humidity": "Moderate",
      },
      "pests_diseases": {
        "pests": ["Caterpillars", "Bark beetles"],
        "diseases": ["Anthracnose", "Root rot"],
        "treatment":
            "Apply insecticides during larval stages; prune diseased branches",
      },
      "uses": ["Shade tree", "Timber", "Ornamental", "Fodder"],
      "features": [
        "Wide spreading canopy",
        "Leaf-folding behavior",
        "Nitrogen-fixing roots",
      ],
    },
    {
      "id": "plant_H5nB3xLqT7cA9V4mR2kP6E1wYdFdo",
      "plant_name": "Mahogany",
      "genus": "Swietenia",
      "family": "Meliaceae",
      "scientific_name": "Swietenia macrophylla",
      "image_url": "assets/images/plants/mahogany.jpg",
      "label_name": "mahogany",
      "description": {
        "general":
            "A highly prized tropical hardwood tree native to Central and South America, widely cultivated in Southeast Asia. Renowned for its rich reddish-brown timber used in fine furniture, musical instruments, and cabinetry.",
        "plant_type": "Tree",
      },
      "distribution": {
        "asia": "Cultivated",
        "africa": "Cultivated",
        "north_america": "Native",
        "south_america": "Native",
        "antarctica": "Unreported",
        "europe": "Cultivated",
        "australia": "Cultivated",
      },
      "growing_conditions": {
        "temperature_range": "20-35°C",
        "sunlight": "Full sun",
        "soil_type": "Loamy to clay",
        "soil_ph": "5.5-7.0",
        "drainage": "Well-drained",
        "growth_rate": "Moderate",
      },
      "toxicity": {
        "level": "Non-toxic",
        "toxic_to": "None",
        "toxic_parts": "None",
      },
      "care_guide": {
        "watering": "Regular when young",
        "fertilizing": "Annually",
        "propagation": ["Seeds"],
        "repotting": "Not applicable",
        "humidity": "Moderate to high",
      },
      "pests_diseases": {
        "pests": ["Mahogany shoot borer", "Bark beetles"],
        "diseases": ["Anthracnose", "Dieback"],
        "treatment":
            "Monitor for shoot borer; apply targeted insecticides; prune affected growth",
      },
      "uses": ["Timber", "Shade tree", "Ornamental"],
      "features": [
        "Prized red-brown timber",
        "Large compound leaves",
        "Winged seeds",
      ],
    },
    {
      "id": "plant_Z8mQ4xNqT1cA7V6kR3sB2H9EwYbFp",
      "plant_name": "Bamboo",
      "genus": "Bambusa",
      "family": "Poaceae",
      "scientific_name": "Bambusa vulgaris",
      "image_url": "assets/images/plants/bamboo.jpg",
      "label_name": "bamboo",
      "description": {
        "general":
            "One of the fastest-growing plants on Earth, bamboo is a giant woody grass with hollow segmented culms. Widely used for construction, crafts, food, and erosion control. A vital ecological and economic resource in tropical Asia.",
        "plant_type": "Giant grass",
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
        "temperature_range": "15-35°C",
        "sunlight": "Full sun to partial shade",
        "soil_type": "Loamy",
        "soil_ph": "5.5-7.0",
        "drainage": "Well-drained",
        "growth_rate": "Very fast",
      },
      "toxicity": {
        "level": "Non-toxic",
        "toxic_to": "None",
        "toxic_parts": "None",
      },
      "care_guide": {
        "watering": "Regular",
        "fertilizing": "Every 2-3 months",
        "propagation": ["Rhizome division", "Culm cuttings"],
        "repotting": "Every 3-5 years if containerized",
        "humidity": "Moderate to high",
      },
      "pests_diseases": {
        "pests": ["Bamboo mites", "Mealybugs", "Aphids"],
        "diseases": ["Bamboo smut", "Root rot"],
        "treatment":
            "Apply miticides for mites; ensure good drainage to prevent root rot",
      },
      "uses": [
        "Construction",
        "Culinary (bamboo shoots)",
        "Crafts",
        "Erosion control",
        "Paper production",
      ],
      "features": [
        "World's fastest growing plant",
        "Carbon sequestration",
        "Multipurpose material",
      ],
    },
    {
      "id": "plant_I6kL9xPqT3cB5V8mR1nA4H7EwYcFq",
      "plant_name": "Ipil-ipil",
      "genus": "Leucaena",
      "family": "Fabaceae",
      "scientific_name": "Leucaena leucocephala",
      "image_url": "assets/images/plants/ipilipil",
      "label_name": "ipilipil",
      "description": {
        "general":
            "A fast-growing tropical legume tree widely used for reforestation, fodder, fuel, and soil improvement. Known for nitrogen fixation and prolific seed production, but listed as invasive in many regions outside its native range.",
        "plant_type": "Tree / Shrub",
      },
      "distribution": {
        "asia": "Invasive",
        "africa": "Invasive",
        "north_america": "Native",
        "south_america": "Native",
        "antarctica": "Unreported",
        "europe": "Exotic",
        "australia": "Invasive",
      },
      "growing_conditions": {
        "temperature_range": "20-35°C",
        "sunlight": "Full sun",
        "soil_type": "Well-drained loamy to rocky",
        "soil_ph": "5.0-8.0",
        "drainage": "Well-drained",
        "growth_rate": "Very fast",
      },
      "toxicity": {
        "level": "Toxic",
        "toxic_to": "Non-ruminant animals",
        "toxic_parts": "Seeds and leaves (contain mimosine)",
      },
      "care_guide": {
        "watering": "Drought tolerant; minimal watering needed",
        "fertilizing": "Rarely needed (nitrogen-fixing)",
        "propagation": ["Seeds"],
        "repotting": "Not applicable",
        "humidity": "Low to moderate",
      },
      "pests_diseases": {
        "pests": ["Psyllids", "Seed beetles"],
        "diseases": ["Root rot (rare)"],
        "treatment":
            "Biological control for psyllids; minimal intervention needed",
      },
      "uses": [
        "Reforestation",
        "Fodder",
        "Fuel wood",
        "Soil improvement",
        "Paper production",
      ],
      "features": [
        "Nitrogen-fixing",
        "Drought tolerant",
        "Rapid growth for biomass",
      ],
    },
    {
      "id": "plant_Y2sG7xLqT9cM4V1kR6pB3H8EwNdFr",
      "plant_name": "Cogon Grass",
      "genus": "Imperata",
      "family": "Poaceae",
      "scientific_name": "Imperata cylindrica",
      "image_url": "assets/images/plants/cogongrass.jpeg",
      "label_name": "cogongrass",
      "description": {
        "general":
            "One of the world's most aggressive invasive grasses, cogon grass forms dense stands that crowd out native vegetation. It is highly flammable and tolerant of poor soils, but is traditionally used in the Philippines for thatching.",
        "plant_type": "Perennial grass",
      },
      "distribution": {
        "asia": "Native",
        "africa": "Native",
        "north_america": "Invasive",
        "south_america": "Invasive",
        "antarctica": "Unreported",
        "europe": "Exotic",
        "australia": "Invasive",
      },
      "growing_conditions": {
        "temperature_range": "15-40°C",
        "sunlight": "Full sun",
        "soil_type": "Sandy to clay (poor soils tolerated)",
        "soil_ph": "4.0-8.0",
        "drainage": "Variable",
        "growth_rate": "Very fast",
      },
      "toxicity": {
        "level": "Non-toxic",
        "toxic_to": "None",
        "toxic_parts": "None",
      },
      "care_guide": {
        "watering": "Drought tolerant; no supplemental watering needed",
        "fertilizing": "Not needed",
        "propagation": ["Rhizomes", "Seeds"],
        "repotting": "Not applicable",
        "humidity": "Low to high",
      },
      "pests_diseases": {
        "pests": ["Minimal due to invasive nature"],
        "diseases": ["Rust (occasional)"],
        "treatment":
            "Control with herbicides (glyphosate); repeated treatment required for eradication",
      },
      "uses": ["Thatching", "Erosion control (traditional)", "Mulching"],
      "features": [
        "Highly invasive",
        "Fire-adapted",
        "Extremely drought tolerant",
      ],
    },
    {
      "id": "plant_W3nT5xMqP8cA1V9kR4sL7H2EwYbFs",
      "plant_name": "Talahib",
      "genus": "Saccharum",
      "family": "Poaceae",
      "scientific_name": "Saccharum spontaneum",
      "image_url": "assets/images/plants/talahib.jpg",
      "label_name": "talahib",
      "description": {
        "general":
            "A tall, wild sugarcane-related grass native to tropical Asia, known for its silvery feathery plumes. Widely found in open fields, riverbanks, and disturbed lands in the Philippines; used traditionally for thatching and broom-making.",
        "plant_type": "Perennial grass",
      },
      "distribution": {
        "asia": "Native",
        "africa": "Native",
        "north_america": "Potentially Invasive",
        "south_america": "Exotic",
        "antarctica": "Unreported",
        "europe": "Unreported",
        "australia": "Potentially Invasive",
      },
      "growing_conditions": {
        "temperature_range": "18-38°C",
        "sunlight": "Full sun",
        "soil_type": "Sandy to loamy",
        "soil_ph": "5.0-8.0",
        "drainage": "Variable",
        "growth_rate": "Fast",
      },
      "toxicity": {
        "level": "Non-toxic",
        "toxic_to": "None",
        "toxic_parts": "None",
      },
      "care_guide": {
        "watering": "Drought tolerant",
        "fertilizing": "Not needed",
        "propagation": ["Rhizomes", "Seeds"],
        "repotting": "Not applicable",
        "humidity": "Moderate",
      },
      "pests_diseases": {
        "pests": ["Sugarcane borer (occasional)"],
        "diseases": ["Smut", "Leaf rust"],
        "treatment":
            "Burn or cut back to control spread; minimal intervention in native habitat",
      },
      "uses": [
        "Thatching",
        "Broom-making",
        "Erosion control",
        "Biofuel research",
      ],
      "features": [
        "Silvery plume inflorescence",
        "Pioneer species",
        "Aggressive colonizer of disturbed lands",
      ],
    },
    {
      "id": "plant_V9kA6xNqT2cB4V7mR1sL3H8EwYcFt",
      "plant_name": "Anahaw",
      "genus": "Livistona",
      "family": "Arecaceae",
      "scientific_name": "Livistona rotundifolia",
      "image_url": "assets/images/plants/anahaw.jpg",
      "label_name": "anahaw",
      "description": {
        "general":
            "The national leaf symbol of the Philippines, anahaw is a stately fan palm with large circular pleated leaves. Found in lowland tropical forests, it is used traditionally for thatching, weaving, and ceremonial purposes.",
        "plant_type": "Palm tree",
      },
      "distribution": {
        "asia": "Native",
        "africa": "Unreported",
        "north_america": "Cultivated",
        "south_america": "Unreported",
        "antarctica": "Unreported",
        "europe": "Cultivated",
        "australia": "Cultivated",
      },
      "growing_conditions": {
        "temperature_range": "20-35°C",
        "sunlight": "Full sun to partial shade",
        "soil_type": "Loamy",
        "soil_ph": "5.5-7.0",
        "drainage": "Well-drained",
        "growth_rate": "Slow to moderate",
      },
      "toxicity": {
        "level": "Non-toxic",
        "toxic_to": "None",
        "toxic_parts": "None",
      },
      "care_guide": {
        "watering": "Regular",
        "fertilizing": "Biannually",
        "propagation": ["Seeds"],
        "repotting": "Every 3-4 years when young",
        "humidity": "High",
      },
      "pests_diseases": {
        "pests": ["Palm weevil", "Scale insects"],
        "diseases": ["Ganoderma butt rot", "Leaf blight"],
        "treatment":
            "Inspect regularly for weevils; remove infected basal tissue for Ganoderma",
      },
      "uses": ["Thatching", "Weaving", "Ornamental", "Cultural/Ceremonial"],
      "features": [
        "Fan-shaped circular leaves",
        "National leaf symbol of the Philippines",
        "Drought tolerant when established",
      ],
    },
    {
      "id": "plant_E1mR8xQqT6cB3V5kN9sA4H7EwYdFu",
      "plant_name": "Rattan",
      "genus": "Calamus",
      "family": "Arecaceae",
      "scientific_name": "Calamus rotang",
      "image_url": "assets/images/plants/rattan.jpg",
      "label_name": "rattan",
      "description": {
        "general":
            "A climbing palm producing flexible, durable canes widely used in furniture, basketry, and handicrafts. Rattan is a major economic forest product in Southeast Asia, thriving in tropical rainforest understories.",
        "plant_type": "Climbing palm",
      },
      "distribution": {
        "asia": "Native",
        "africa": "Cultivated",
        "north_america": "Unreported",
        "south_america": "Unreported",
        "antarctica": "Unreported",
        "europe": "Unreported",
        "australia": "Cultivated",
      },
      "growing_conditions": {
        "temperature_range": "20-35°C",
        "sunlight": "Partial shade",
        "soil_type": "Loamy",
        "soil_ph": "5.0-6.5",
        "drainage": "Well-drained",
        "growth_rate": "Moderate to slow",
      },
      "toxicity": {
        "level": "Non-toxic",
        "toxic_to": "None",
        "toxic_parts": "None",
      },
      "care_guide": {
        "watering": "Regular",
        "fertilizing": "Biannually",
        "propagation": ["Seeds", "Suckers"],
        "repotting": "Not applicable",
        "humidity": "High",
      },
      "pests_diseases": {
        "pests": ["Scale insects", "Mealybugs"],
        "diseases": ["Leaf blight", "Root rot"],
        "treatment": "Apply neem oil; maintain good forest floor drainage",
      },
      "uses": ["Furniture", "Basketry", "Handicrafts", "Construction"],
      "features": [
        "Flexible strong canes",
        "Thorny climbing stems",
        "Major export commodity in Southeast Asia",
      ],
    },
    {
      "id": "plant_X4pL2xTqM9cA6V1kR8nB5H3EwYjFv",
      "plant_name": "Welwitschia",
      "genus": "Welwitschia",
      "family": "Welwitschiaceae",
      "scientific_name": "Welwitschia mirabilis",
      "image_url": "assets/images/plants/welwitschia.jpg",
      "label_name": "welwitschia",
      "description": {
        "general":
            "One of the world's most ancient and bizarre plants, welwitschia produces only two permanent strap-like leaves that grow continuously and become tattered over centuries. Endemic to the Namib Desert, individual plants can live over 1,000 years.",
        "plant_type": "Gymnosperm (unique)",
      },
      "distribution": {
        "asia": "Unreported",
        "africa": "Native",
        "north_america": "Unreported",
        "south_america": "Unreported",
        "antarctica": "Unreported",
        "europe": "Unreported",
        "australia": "Unreported",
      },
      "growing_conditions": {
        "temperature_range": "10-45°C",
        "sunlight": "Full sun",
        "soil_type": "Sandy gravel (desert substrate)",
        "soil_ph": "7.0-8.5",
        "drainage": "Excellent (xeric)",
        "growth_rate": "Extremely slow",
      },
      "toxicity": {
        "level": "Non-toxic",
        "toxic_to": "None",
        "toxic_parts": "None",
      },
      "care_guide": {
        "watering": "Very infrequent (fog moisture adapted)",
        "fertilizing": "Not required",
        "propagation": ["Seeds"],
        "repotting": "Not applicable (taproot system)",
        "humidity": "Very low",
      },
      "pests_diseases": {
        "pests": ["Welwitschia bug (Probergrothius sexpunctatus)"],
        "diseases": ["Root rot if overwatered"],
        "treatment": "Avoid overwatering; minimal intervention needed",
      },
      "uses": ["Scientific research", "Conservation symbol", "Ecotourism"],
      "features": [
        "Only two leaves for entire lifespan",
        "Can live over 1000 years",
        "Endemic to Namib Desert",
      ],
    },
    {
      "id": "plant_Q7kN3xPqT5cA8V2mR9sB1H6EwYdFw",
      "plant_name": "Lithops",
      "genus": "Lithops",
      "family": "Aizoaceae",
      "scientific_name": "Lithops salicola",
      "image_url": "assets/images/plants/lithops.jpg",
      "label_name": "lithops",
      "description": {
        "general":
            "Known as living stones, lithops are remarkable desert succulents that have evolved to mimic the appearance of pebbles as camouflage from herbivores. Each plant consists of two fused succulent leaves with a fissure from which a daisy-like flower emerges.",
        "plant_type": "Succulent",
      },
      "distribution": {
        "asia": "Unreported",
        "africa": "Native",
        "north_america": "Cultivated",
        "south_america": "Cultivated",
        "antarctica": "Unreported",
        "europe": "Cultivated",
        "australia": "Cultivated",
      },
      "growing_conditions": {
        "temperature_range": "10-35°C",
        "sunlight": "Full sun to bright indirect light",
        "soil_type": "Sandy, gritty",
        "soil_ph": "6.5-7.5",
        "drainage": "Excellent",
        "growth_rate": "Very slow",
      },
      "toxicity": {
        "level": "Non-toxic",
        "toxic_to": "None",
        "toxic_parts": "None",
      },
      "care_guide": {
        "watering": "Very infrequent (only during growing season)",
        "fertilizing": "Rarely (diluted cactus fertilizer annually)",
        "propagation": ["Seeds", "Division"],
        "repotting": "Every 3-5 years",
        "humidity": "Very low",
      },
      "pests_diseases": {
        "pests": ["Mealybugs", "Fungus gnats"],
        "diseases": ["Root rot from overwatering"],
        "treatment":
            "Never water during dormancy; treat mealybugs with isopropyl alcohol",
      },
      "uses": ["Ornamental", "Indoor succulent collections"],
      "features": [
        "Stone-mimicking camouflage",
        "Daisy-like flowers",
        "Extremely drought tolerant",
      ],
    },
    {
      "id": "plant_U5rM1xLqT4cA9V7kR2nP8H6EwYbFx",
      "plant_name": "Hydnora",
      "genus": "Hydnora",
      "family": "Hydnoraceae",
      "scientific_name": "Hydnora africana",
      "image_url": "assets/images/plants/hydnora.jpeg",
      "label_name": "hydnora",
      "description": {
        "general":
            "One of the world's most unusual parasitic plants, hydnora has no leaves, stems, or chlorophyll and lives entirely underground as a parasite on Euphorbia roots. Its bizarre fleshy orange flowers emerge from the soil emitting a foul odor to attract dung beetle pollinators.",
        "plant_type": "Holoparasitic plant",
      },
      "distribution": {
        "asia": "Unreported",
        "africa": "Native",
        "north_america": "Unreported",
        "south_america": "Unreported",
        "antarctica": "Unreported",
        "europe": "Unreported",
        "australia": "Unreported",
      },
      "growing_conditions": {
        "temperature_range": "15-40°C",
        "sunlight": "None (subterranean)",
        "soil_type": "Sandy desert soil",
        "soil_ph": "7.0-8.5",
        "drainage": "Excellent",
        "growth_rate": "Extremely slow",
      },
      "toxicity": {
        "level": "Non-toxic",
        "toxic_to": "None",
        "toxic_parts": "None",
      },
      "care_guide": {
        "watering": "Not applicable (parasitic)",
        "fertilizing": "Not applicable",
        "propagation": ["Seeds (requires host plant)"],
        "repotting": "Not applicable",
        "humidity": "Very low",
      },
      "pests_diseases": {
        "pests": ["None significant"],
        "diseases": ["None documented"],
        "treatment": "No intervention needed or possible",
      },
      "uses": ["Traditional medicine (fruit edible)", "Scientific research"],
      "features": [
        "Fully subterranean body",
        "Foul-smelling dung beetle trap flowers",
        "No chlorophyll or leaves",
      ],
    },
    {
      "id": "plant_J3nK9xQqT6cB1V4mR7sA2H8EwYcFy",
      "plant_name": "Amorphophallus titanum",
      "genus": "Amorphophallus",
      "family": "Araceae",
      "scientific_name": "Amorphophallus titanum",
      "image_url": "assets/images/plants/amorphophallus.jpg",
      "label_name": "amorphophallus",
      "description": {
        "general":
            "Known as the Corpse Flower, this extraordinary plant produces the world's largest unbranched inflorescence, which can reach over 3 meters tall. Famous for its overwhelming stench of rotting flesh during its rare bloom, used to attract carrion beetle and fly pollinators. A rare endangered species from Sumatra.",
        "plant_type": "Tuberous herb",
      },
      "distribution": {
        "asia": "Native",
        "africa": "Unreported",
        "north_america": "Cultivated",
        "south_america": "Unreported",
        "antarctica": "Unreported",
        "europe": "Cultivated",
        "australia": "Cultivated",
      },
      "growing_conditions": {
        "temperature_range": "20-35°C",
        "sunlight": "Partial shade to bright indirect light",
        "soil_type": "Rich loamy",
        "soil_ph": "6.0-7.0",
        "drainage": "Well-drained",
        "growth_rate": "Slow (blooms once every 7-10 years)",
      },
      "toxicity": {
        "level": "Toxic",
        "toxic_to": "Humans, Pets",
        "toxic_parts":
            "All parts (calcium oxalate crystals and irritant compounds)",
      },
      "care_guide": {
        "watering": "Regular during growing phase; minimal during dormancy",
        "fertilizing": "Monthly during active growth",
        "propagation": ["Corm offsets", "Seeds"],
        "repotting": "Every 2-3 years or when corm outgrows container",
        "humidity": "High",
      },
      "pests_diseases": {
        "pests": ["Mealybugs", "Root mealybugs"],
        "diseases": ["Corm rot", "Fungal infections"],
        "treatment":
            "Apply systemic insecticide for mealybugs; ensure excellent drainage to prevent corm rot",
      },
      "uses": [
        "Scientific research",
        "Botanical garden attraction",
        "Conservation",
      ],
      "features": [
        "World's largest unbranched inflorescence",
        "Corpse-like odor during bloom",
        "Blooms rarely (every 7-10 years)",
        "Endangered species",
      ],
    },
  ];

  List<Widget> fromExplorePlants() {
    return List.generate(
      plants.length,
      (i) => ExplorePlants(plantId: plants[i]['id'] ?? ""),
    );
  }

  Map<String, dynamic>? getPlantById(String id) {
    return plants.where((item) => item['id'] == id).isNotEmpty
        ? plants.firstWhere((item) => item['id'] == id)
        : null;
  }

  Map<String, dynamic>? getPlantByLabelName(String labelName) {
    return plants.where((item) => item['label_name'] == labelName).isNotEmpty
        ? plants.firstWhere((item) => item['label_name'] == labelName)
        : null;
  }
}

Plants plants = Plants();
