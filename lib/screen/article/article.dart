import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class ArticleData {
  final String id;
  final String title;
  final String imageUrl;
  final String intro;
  final List<ArticleSection> sections;
  final String sourceUrl;
  final String sourceName;
  final String category;

  const ArticleData({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.intro,
    required this.sections,
    required this.sourceUrl,
    required this.sourceName,
    required this.category,
  });
}

class ArticleSection {
  final String heading;
  final String body;

  const ArticleSection({required this.heading, required this.body});
}

// ─── REAL PLANT ARTICLES ────────────────────────────────────────────────────

const List<ArticleData> _allArticles = [
  ArticleData(
    id: 'art_001',
    title: 'The Soil Science: How to Build the Perfect Foundation for Growth',
    imageUrl: 'assets/images/util/article_image_sample.jpg',
    intro:
        'Healthy plants begin with healthy soil. Soil is more than just dirt—it is a living environment that supports plant roots, stores nutrients, and regulates water and air. Understanding soil science helps gardeners create the ideal conditions for plant growth, whether they are growing houseplants, vegetables, or outdoor garden plants.',
    sections: [
      ArticleSection(
        heading: 'Know Your Soil Type',
        body:
            'Different plants require different soil conditions. Some thrive in loose, well-drained soil, while others prefer moisture-rich environments. The three main soil types are sandy, clay, and loam. Loamy soil—a balanced mix of sand, silt, and clay—is considered the gold standard for most plants. Test your soil with an inexpensive kit from a garden center to know where you stand.',
      ),
      ArticleSection(
        heading: 'The Role of pH',
        body:
            'Soil pH affects how well plants can absorb nutrients. Most vegetables and flowers prefer a slightly acidic to neutral pH between 6.0 and 7.0. Blueberries and azaleas love acidic soil (pH 4.5–5.5), while lavender thrives in alkaline conditions. You can lower pH by adding sulfur, or raise it by mixing in garden lime.',
      ),
      ArticleSection(
        heading: 'Feeding the Soil with Organic Matter',
        body:
            'Compost is the single best thing you can add to any soil. It improves drainage in clay soils, retains moisture in sandy soils, feeds beneficial microbes, and slowly releases nutrients as it breaks down. Aim to incorporate 2–4 inches of compost into your beds each season. Worm castings are another powerhouse amendment for container gardens.',
      ),
      ArticleSection(
        heading: 'Mulching to Maintain Moisture',
        body:
            'A 2–3 inch layer of organic mulch around your plants conserves moisture, regulates soil temperature, and suppresses weeds. Shredded bark, straw, and wood chips are popular choices. Keep mulch a few inches away from stems to prevent rot. As it decomposes, it also enriches your soil—a double benefit for minimal effort.',
      ),
    ],
    sourceUrl: 'https://www.gardenersworld.com/how-to/grow-plants/how-to-improve-your-soil/',
    sourceName: 'Gardeners\' World',
    category: 'Soil & Basics',
  ),

  ArticleData(
    id: 'art_002',
    title: '10 Easy-Care Houseplants That Thrive on Neglect',
    imageUrl: 'assets/images/util/article_image_sample.jpg',
    intro:
        'Not everyone has a green thumb—and that\'s perfectly okay. Some plants are remarkably forgiving and can survive in low light, irregular watering, and fluctuating temperatures. Here are ten houseplants that practically take care of themselves.',
    sections: [
      ArticleSection(
        heading: 'Pothos (Epipremnum aureum)',
        body:
            'Perhaps the most beginner-friendly plant on the planet. Pothos tolerates low light, irregular watering, and a wide range of humidity levels. Its trailing vines look stunning in hanging baskets or cascading from a shelf. Water when the top inch of soil feels dry, and it will reward you with lush, heart-shaped leaves.',
      ),
      ArticleSection(
        heading: 'Snake Plant (Sansevieria trifasciata)',
        body:
            'Snake plants are practically indestructible. They prefer indirect light but can survive in dim corners, and they only need water every 2–6 weeks depending on the season. Their upright, sword-like leaves also make them excellent air purifiers, filtering toxins like formaldehyde and benzene.',
      ),
      ArticleSection(
        heading: 'ZZ Plant (Zamioculcas zamiifolia)',
        body:
            'The ZZ plant stores water in its thick rhizomes, making it highly drought-tolerant. It thrives in low to bright indirect light and needs watering only every 2–3 weeks. Its glossy, dark green leaves add a sophisticated touch to any room with almost zero effort.',
      ),
      ArticleSection(
        heading: 'Aloe Vera',
        body:
            'Beyond its well-known skin-soothing properties, aloe vera is an extremely low-maintenance succulent. It needs bright light and infrequent watering—let the soil dry completely between waterings. Plant it in well-draining cactus mix and avoid overwatering, which is the only way to kill it.',
      ),
    ],
    sourceUrl: 'https://www.bhg.com/gardening/houseplants/easy-care/',
    sourceName: 'Better Homes & Gardens',
    category: 'Houseplants',
  ),

  ArticleData(
    id: 'art_003',
    title: 'Watering 101: How Much Is Too Much?',
    imageUrl: 'assets/images/util/article_image_sample.jpg',
    intro:
        'Overwatering is the number one killer of houseplants worldwide. More plants die from too much water than from too little. Learning to read your plants\' thirst cues and understanding proper watering technique will dramatically improve your gardening success rate.',
    sections: [
      ArticleSection(
        heading: 'The Finger Test',
        body:
            'Before reaching for the watering can, stick your finger 1–2 inches into the soil. If it feels moist, wait. If it feels dry, water thoroughly until it drains from the bottom. This simple test works for most tropical houseplants. Succulents and cacti need the soil to dry out completely between waterings.',
      ),
      ArticleSection(
        heading: 'Signs of Overwatering',
        body:
            'Yellow leaves, mushy stems, a foul-smelling soil, and fungus gnats are classic overwatering symptoms. Root rot sets in when roots sit in saturated soil for extended periods. If you suspect root rot, remove the plant from its pot, trim any black or mushy roots with sterile scissors, and repot in fresh, dry soil.',
      ),
      ArticleSection(
        heading: 'Signs of Underwatering',
        body:
            'An underwatered plant will have dry, crinkled or crispy leaf edges, drooping stems despite dry soil, and very lightweight pots. Most plants bounce back quickly from drought stress once watered thoroughly. For severely dehydrated plants, soak the pot in a basin of water for 30 minutes to rehydrate the root ball evenly.',
      ),
      ArticleSection(
        heading: 'Water Quality Matters',
        body:
            'Tap water with high chlorine or fluoride content can cause brown leaf tips on sensitive plants like spider plants and peace lilies. Let tap water sit overnight to off-gas chlorine, or use filtered water. Rainwater is ideal for most plants. Room-temperature water is also preferable to cold water, which can shock tropical roots.',
      ),
    ],
    sourceUrl: 'https://extension.umn.edu/houseplants/watering-houseplants',
    sourceName: 'University of Minnesota Extension',
    category: 'Plant Care Tips',
  ),

  ArticleData(
    id: 'art_004',
    title: 'Growing Vegetables in Tropical Climates: A Philippine Guide',
    imageUrl: 'assets/images/util/article_image_sample.jpg',
    intro:
        'The Philippines\' warm, humid climate is a gift for vegetable gardeners—if you know which crops to plant when. From ampalaya to pechay, growing your own food in the tropics is highly rewarding. Here\'s how to get the most out of your backyard or container garden.',
    sections: [
      ArticleSection(
        heading: 'Best Vegetables for the Philippine Climate',
        body:
            'Warm-season crops that thrive locally include ampalaya (bitter melon), okra, sitaw (string beans), kamote tops (sweet potato leaves), kangkong, and eggplant. These are heat-tolerant and grow vigorously in the lowlands. For higher elevations like Benguet and Bukidnon, cool-season crops like pechay, cabbage, and carrots do exceptionally well.',
      ),
      ArticleSection(
        heading: 'Planting Seasons',
        body:
            'The best planting windows are October to February (dry season) for most leafy vegetables, and March to May for warm-weather fruiting crops before the rains arrive. During the rainy season, raised beds and proper drainage become critical to prevent root rot and fungal issues.',
      ),
      ArticleSection(
        heading: 'Managing Pests Naturally',
        body:
            'Common tropical pests include aphids, whiteflies, and caterpillars. A simple neem oil spray (2 tbsp neem oil + a few drops of dish soap per liter of water) is effective and non-toxic. Companion planting with marigolds repels aphids and nematodes. Encourage natural predators like lizards and ladybugs by avoiding broad-spectrum pesticides.',
      ),
      ArticleSection(
        heading: 'Container Gardening for Urban Spaces',
        body:
            'Don\'t have a yard? No problem. Tomatoes, peppers, kangkong, and herbs like basil and pandan grow beautifully in containers. Use at least a 12-inch pot with drainage holes, and mix garden soil with compost or vermicast. Position containers in spots that get at least 6 hours of direct sunlight daily, such as a sunny balcony or rooftop.',
      ),
    ],
    sourceUrl: 'https://www.da.gov.ph/vegetable-production-guide/',
    sourceName: 'Department of Agriculture Philippines',
    category: 'Tropical Gardening',
  ),

  ArticleData(
    id: 'art_005',
    title: 'The Beginner\'s Guide to Fertilizing Your Plants',
    imageUrl: 'assets/images/util/article_image_sample.jpg',
    intro:
        'Fertilizer is plant food—but like any food, too much or the wrong kind can cause problems. Understanding the basics of plant nutrition will help you feed your plants correctly and watch them flourish.',
    sections: [
      ArticleSection(
        heading: 'NPK: The Big Three',
        body:
            'Every fertilizer label shows three numbers representing Nitrogen (N), Phosphorus (P), and Potassium (K). Nitrogen promotes leafy green growth, phosphorus supports root development and flowering, and potassium improves overall plant health and disease resistance. A balanced 10-10-10 fertilizer works well as a general-purpose option.',
      ),
      ArticleSection(
        heading: 'Organic vs. Synthetic Fertilizers',
        body:
            'Organic fertilizers like compost, fish emulsion, and bone meal release nutrients slowly and improve soil health over time. Synthetic fertilizers deliver nutrients immediately but can build up salts in the soil with repeated use. For houseplants and vegetables, organic options are generally safer and more sustainable.',
      ),
      ArticleSection(
        heading: 'When to Fertilize',
        body:
            'Most houseplants only need fertilizing during their active growing season—spring through summer. Fertilizing in fall and winter when plants are dormant can actually harm them by pushing weak, leggy growth. Outdoor vegetable gardens benefit from a slow-release fertilizer at planting time, followed by a liquid boost every 2–4 weeks during fruiting.',
      ),
      ArticleSection(
        heading: 'Signs of Nutrient Deficiency',
        body:
            'Pale or yellowing leaves often indicate nitrogen deficiency. Purple-tinged leaves can signal a phosphorus shortage. Brown leaf edges may point to potassium or calcium imbalance. However, always rule out watering issues before assuming a nutrient problem—overwatering can cause similar symptoms by blocking nutrient uptake at the roots.',
      ),
    ],
    sourceUrl: 'https://www.rhs.org.uk/soil-composts-mulches/fertilizers',
    sourceName: 'Royal Horticultural Society',
    category: 'Plant Care Tips',
  ),

  ArticleData(
    id: 'art_006',
    title: 'Indoor Plants That Improve Air Quality in Your Home',
    imageUrl: 'assets/images/util/article_image_sample.jpg',
    intro:
        'NASA\'s famous Clean Air Study revealed that certain houseplants can remove pollutants like benzene, formaldehyde, and trichloroethylene from indoor air. While plants alone won\'t replace a good air filtration system, they do contribute to a healthier home environment—and they look beautiful doing it.',
    sections: [
      ArticleSection(
        heading: 'Peace Lily (Spathiphyllum)',
        body:
            'One of the top air-purifying plants, the peace lily filters benzene, formaldehyde, and ammonia from the air. It thrives in low light and only needs watering when the soil is dry. Its elegant white blooms also add a calming aesthetic to any room. Note: it\'s mildly toxic to pets, so keep it out of reach of cats and dogs.',
      ),
      ArticleSection(
        heading: 'Spider Plant (Chlorophytum comosum)',
        body:
            'An incredibly resilient and fast-growing plant, the spider plant is excellent at removing carbon monoxide and xylene. It produces cascading "babies" that can be propagated easily. It thrives in indirect light and tolerates irregular watering—perfect for beginners who want the benefits of air purification without the maintenance burden.',
      ),
      ArticleSection(
        heading: 'Boston Fern (Nephrolepis exaltata)',
        body:
            'Boston ferns are particularly effective at adding moisture to dry indoor air, making them ideal for air-conditioned rooms. They excel at filtering formaldehyde and xylene. They do require consistent moisture and high humidity, so mist them regularly or place the pot on a pebble tray with water.',
      ),
      ArticleSection(
        heading: 'Rubber Plant (Ficus elastica)',
        body:
            'The rubber plant\'s large, waxy leaves are efficient at absorbing airborne toxins and converting carbon dioxide to oxygen. It prefers bright, indirect light and moderate watering. Its bold, architectural form makes it a popular statement plant for living rooms and offices alike.',
      ),
    ],
    sourceUrl: 'https://ntrs.nasa.gov/citations/19930073077',
    sourceName: 'NASA Technical Reports',
    category: 'Houseplants',
  ),

  ArticleData(
    id: 'art_007',
    title: 'How to Propagate Plants at Home: A Step-by-Step Guide',
    imageUrl: 'assets/images/util/article_image_sample.jpg',
    intro:
        'Propagation is the art of growing new plants from a parent plant—using cuttings, division, layering, or seeds. It\'s one of the most rewarding skills a gardener can develop, letting you multiply your collection for free and share plants with friends.',
    sections: [
      ArticleSection(
        heading: 'Stem Cuttings: The Most Common Method',
        body:
            'Take a 4–6 inch cutting just below a leaf node using clean, sharp scissors. Remove the lower leaves, leaving 2–3 at the top. Place the cutting in water or moist potting mix. Many popular houseplants—pothos, philodendron, basil, impatiens—root in water within 2–3 weeks. Change the water every few days to prevent bacteria buildup.',
      ),
      ArticleSection(
        heading: 'Leaf Cuttings for Succulents',
        body:
            'Succulents like echeveria and sedum can be propagated from individual leaves. Gently twist a healthy leaf from the stem so it comes off cleanly with the base intact. Let it callous for 1–2 days, then lay it on top of dry cactus mix. Mist lightly every few days. Within 2–4 weeks, tiny new rosettes will emerge from the base.',
      ),
      ArticleSection(
        heading: 'Division for Clumping Plants',
        body:
            'Plants that grow in clumps—like snake plants, hostas, and peace lilies—can be divided when repotting. Remove the plant from its pot, gently separate the root ball into sections (each with roots and leaves), and pot each section individually. Division not only propagates your plant but also rejuvenates older, crowded specimens.',
      ),
      ArticleSection(
        heading: 'Tips for Propagation Success',
        body:
            'Always use clean tools to prevent disease transmission. Rooting hormone powder or gel (available at garden centers) can significantly speed up root development for stem cuttings. Maintain warmth and humidity during rooting—a clear plastic bag over the cutting creates a mini greenhouse effect. Avoid placing cuttings in direct sun until they\'ve established roots.',
      ),
    ],
    sourceUrl: 'https://www.rhs.org.uk/propagation/cuttings',
    sourceName: 'Royal Horticultural Society',
    category: 'Plant Care Tips',
  ),

  ArticleData(
    id: 'art_008',
    title: 'Orchid Care: Demystifying the World\'s Most Elegant Flower',
    imageUrl: 'assets/images/util/article_image_sample.jpg',
    intro:
        'Orchids have a reputation for being difficult, but the truth is that most orchids sold in stores are moth orchids (Phalaenopsis)—one of the easiest houseplants to grow. With a few key care adjustments, you can keep them blooming year after year.',
    sections: [
      ArticleSection(
        heading: 'Light Requirements',
        body:
            'Orchids need bright, indirect light. An east-facing window is ideal. Direct afternoon sun will scorch the leaves, turning them yellow or brown. If your leaves are dark green (rather than bright green), the plant needs more light. If they\'re yellow-green, reduce sun exposure slightly.',
      ),
      ArticleSection(
        heading: 'The Right Way to Water',
        body:
            'The most common orchid care mistake is overwatering. Water thoroughly once a week by running water through the pot for 15–20 seconds, then let it drain completely. Never let orchids sit in standing water. The bark-based potting medium should dry out slightly between waterings. During winter, reduce watering frequency.',
      ),
      ArticleSection(
        heading: 'Encouraging Reblooming',
        body:
            'After the flowers drop, cut the spike just above the second or third node (the bumps on the stem). A side shoot often emerges and produces a second flush of blooms. To trigger reblooming, expose the plant to cooler nighttime temperatures (around 55–60°F / 13–16°C) for 4–6 weeks in fall—this temperature drop mimics their natural environment.',
      ),
      ArticleSection(
        heading: 'Feeding and Repotting',
        body:
            'Feed orchids with a balanced, water-soluble fertilizer (20-20-20) diluted to quarter strength, every two weeks during active growth. Skip feeding when in bloom. Repot every 1–2 years when the bark has broken down or roots are escaping the pot. Use orchid-specific bark mix, never regular potting soil.',
      ),
    ],
    sourceUrl: 'https://www.aos.org/orchids/orchid-care.aspx',
    sourceName: 'American Orchid Society',
    category: 'Flowers & Blooms',
  ),
];

// ─── ARTICLE SERVICE ─────────────────────────────────────────────────────────

class ArticleService {
  static const _kStoredIdsKey = 'article_cached_ids';
  static const _displayCount = 8;

  static List<ArticleData>? _cachedArticles;

  /// Returns the current session's article list.
  /// On app start, there is a 40% chance a new shuffle is generated.
  static Future<List<ArticleData>> getArticles() async {
    if (_cachedArticles != null) return _cachedArticles!;

    final prefs = await SharedPreferences.getInstance();
    final storedIds = prefs.getStringList(_kStoredIdsKey);

    final shouldShuffle = storedIds == null || _roll40Percent();

    if (shouldShuffle) {
      final shuffled = List<ArticleData>.from(_allArticles)..shuffle(Random());
      final selected = shuffled.take(_displayCount).toList();
      await prefs.setStringList(_kStoredIdsKey, selected.map((a) => a.id).toList());
      _cachedArticles = selected;
    } else {
      // Restore saved order
      final ordered = storedIds
          .map((id) {
            try {
              return _allArticles.firstWhere((a) => a.id == id);
            } catch (_) {
              return null;
            }
          })
          .whereType<ArticleData>()
          .toList();
      _cachedArticles = ordered.isNotEmpty ? ordered : _allArticles.take(_displayCount).toList();
    }

    return _cachedArticles!;
  }

  static bool _roll40Percent() => Random().nextDouble() < 0.40;
}