// lib/service/article_service.dart
//
// Fetches real plant care articles from the web.
// Articles are refreshed on app restart with a 40% probability.
// Cached articles persist between sessions via SharedPreferences.

import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// A real plant article fetched from the web.
class PlantArticle {
  final String title;
  final String description;   // short intro / excerpt
  final String imageUrl;
  final String sourceUrl;
  final String sourceName;
  final String body;          // full article text (HTML stripped)

  const PlantArticle({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.sourceUrl,
    required this.sourceName,
    required this.body,
  });

  factory PlantArticle.fromJson(Map<String, dynamic> json) => PlantArticle(
        title: json['title'] as String,
        description: json['description'] as String,
        imageUrl: json['imageUrl'] as String,
        sourceUrl: json['sourceUrl'] as String,
        sourceName: json['sourceName'] as String,
        body: json['body'] as String,
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
        'sourceUrl': sourceUrl,
        'sourceName': sourceName,
        'body': body,
      };
}

class ArticleService {
  static const _cacheKey = 'cached_plant_articles';
  static const _cacheTimeKey = 'cached_plant_articles_time';

  // ─── Hardcoded seed articles cause im broke asf (active URLs verified May 2026) ──────────────
  // These are used as a fallback or when the random refresh fires.
  // Feel free to extend / swap these out as needed.
  static final List<PlantArticle> _seedArticles = [
    PlantArticle(
      title: '9 Expert Gardening Techniques You Should Master',
      description:
          'Make a New Year resolution to grow your best-ever plants and master next-level gardening techniques that will turn you into an expert in no time.',
      imageUrl:
          'https://cdn.mos.cms.futurecdn.net/ogZLxC36t476Z7zdJtMCRT-1600-80.jpg',
      sourceUrl:
          'https://www.gardeningknowhow.com/garden-how-to/info/expert-gardening-techniques',
      sourceName: 'Gardening Know How',
      body:
          'Amending garden soil is a careful science. Learn and apply this science to enjoy better water retention or drainage, improved aeration, a careful balance of nutrients, and the appropriate pH level for your plants.\n\n'
          'To amend garden soil, start by assessing its texture and fertility. If your soil is heavy clay, mix in organic matter like compost or well-rotted manure to improve drainage and structure. Sandy soil benefits from the same amendments as they help retain moisture and nutrients.\n\n'
          'Instead of buying lots of different plants, use the landscaping rule of three, which involves repeating plants in odd numbers for a more natural yet coherent look in the garden.\n\n'
          'Training is the art of manipulating how a plant grows to achieve a specific shape or structure. You can train shrubs, trees, and vines. For example, you can train a shrub to grow on one main stem, as a standard plant, so it looks like a small tree.',
    ),
    PlantArticle(
      title: '15 Easy-Going Plants That Practically Grow Themselves',
      description:
          'Put your feet up and your trowel down: all these glorious plants are ridiculously easy to grow and bring maximum reward for minimal effort.',
      imageUrl:
          'https://cdn.mos.cms.futurecdn.net/GMoLGgksv83Rq8ZzezL4yQ-1600-80.jpg.webp',
      sourceUrl:
          'https://www.gardeningknowhow.com/ornamental/easy-to-grow-plants-for-a-low-maintenance-garden',
      sourceName: 'Gardening Know How',
      body:
          'Gardening doesn\'t need to be difficult or time-consuming, and you\'ll have to try far harder to kill these plants than you will to keep them alive. If you\'re a beginner gardener, they\'re a great spot to start.\n\n'
          'Carex is a useful plant for containers and groundcover in a shady spot as its evergreen foliage starts a lovely lime green and gradually turns golden. It doesn\'t need pruning and is deer and rabbit resistant (Zones 6–8).\n\n'
          'Hardy geraniums bring blooms all summer for zero effort, working their way around other plants in a border while the foliage turns red in fall (Zones 5–9).\n\n'
          'Nigella damascena is easy to grow from seed and although it\'s an annual it\'ll self-seed and be back next year, with stunning seedpods that bring fabulous structure (Zones 4–9).',
    ),
    PlantArticle(
      title: 'Top Trending Houseplants for 2025 & Beyond',
      description:
          'Looking to build a houseplant collection? Choose houseplants trending right now — bold colors, eye-catching leaf patterns, and air-purifying superpowers.',
      imageUrl:
          'https://cdn.mos.cms.futurecdn.net/cwhtRoevpS4T3TbzX2rG64-1600-80.jpg.webp',
      sourceUrl:
          'https://www.gardeningknowhow.com/houseplants/the-hottest-houseplants-of-2025-what-to-look-out-for',
      sourceName: 'Gardening Know How',
      body:
          'Houseplants have exploded in popularity in recent years, becoming must-have décor for living spaces. Bringing nature indoors appeals to our environmental aesthetic, and choosing plants that help clean the air appeals to our sense of well-being.\n\n'
          'Today, plant enthusiasts are attracted to bolder, more unusual houseplants with vibrant colors, eye-catching leaf patterns, therapeutic scents, or air-purifying capabilities.\n\n'
          'With the advent of plant care and ID apps, navigating the houseplant world is easier than ever. For 2025 houseplants, look for vibrant colors and patterns, striking variegation, or unusual leaf shapes.\n\n'
          'Dark and moody varieties are trending strongly into 2026 — think deep burgundy, near-black foliage, and dramatic contrasts that make a statement in any room.',
    ),
    PlantArticle(
      title: '25 Gardening Lessons from 2025',
      description:
          'From peat-free planting to AI in the garden — the trends and talking points that defined the horticultural year, as told by the RHS.',
      imageUrl:
          'https://www.rhs.org.uk/getmedia/75927269-2de6-4a2f-9090-054e2d26d9b2/header.jpg',
      sourceUrl: 'https://www.rhs.org.uk/garden-inspiration/seasonal/25-lessons-from-2025',
      sourceName: 'RHS',
      body:
          '"Mullet gardening is the idea of keeping things tidy at the front, while letting them grow a bit wild at the back," explains Garden Manager Mark Tuson, a pioneer of this approach at RHS Wisley. It\'s gardening for wildlife: providing habitat and food, while remaining visually cared for.\n\n'
          '70% of gardeners bought peat-free compost in 2025 — a boon for peat bogs, the carbon they store, and the biodiversity they sustain. From January 2026, every plant sold through RHS Garden Centres will be grown peat-free.\n\n'
          'When the RHS announced a Chelsea garden exploring AI in a garden context, the response was intense. Some were curious, but many raised concerns: would incorporating AI diminish intuitive knowledge passed down through generations? Could it distance us from the hands-on relationship that makes gardening so meaningful?\n\n'
          'What was discovered is that real, living gardens have a way of grounding abstract conversations. AI works best as a companion to — not a replacement for — human horticultural wisdom.',
    ),
    PlantArticle(
      title: '2025 Gardening Predictions: Trends for the Year Ahead',
      description:
          'In 2025 gardeners will be tearing up traditional planting choices with front gardens reimagined for a greener future, says the RHS.',
      imageUrl:
          'https://www.rhs.org.uk/getmedia/7c1dfd18-8826-4e2d-9ee8-c8aa7ac2a381/Little-gardener-1088x512.jpg?width=1184',
      sourceUrl:
          'https://www.rhs.org.uk/garden-inspiration/seasonal/2025-gardening-predictions',
      sourceName: 'RHS',
      body:
          'Gardens never stand still and 2025 is likely to see not only new, exciting planting choices but new ways of designing, growing, and maintaining spaces.\n\n'
          'Community gardens are increasingly at the centre of local water capture and storage, helping to meet the needs of the immediate space but also local people during extended dry spells.\n\n'
          'The proliferation of smaller-scale growing spaces in more urban areas is also seen as valuable protection from flash flooding — plants help slow the flow of rainwater before it\'s soaked up by the soil, nature\'s largest natural water butt.\n\n'
          '2025 is expected to see a growth in so-called "sponge city" capabilities as developers and councils increasingly recognise the broader benefits of planted spaces. Green roofs and walls will be sought out to provide thermal regulation, reduce flooding, and boost habitat provision.',
    ),
    PlantArticle(
      title: 'The Soil Science: How to Build the Perfect Foundation for Growth',
      description:
          'Healthy plants begin with healthy soil. Soil is more than just dirt — it is a living environment that supports plant roots, stores nutrients, and regulates water and air.',
      imageUrl:
          'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=800&q=80',
      sourceUrl:
          'https://www.gardeningknowhow.com/garden-how-to/soil-fertilizers/improving-garden-soil.htm',
      sourceName: 'Gardening Know How',
      body:
          'Understanding soil science helps gardeners create the ideal conditions for plant growth, whether they are growing houseplants, vegetables, or outdoor garden plants.\n\n'
          'Different plants require different soil conditions. Some thrive in loose, well-drained soil, while others prefer moisture-rich environments. By learning how soil works and how to prepare it properly, you can give every plant the best possible start.\n\n'
          'Perform a soil test to check pH levels. If your soil is too acidic for the plants you want to grow, add lime. If it\'s too alkaline, sulfur can help. Spread a balanced organic fertilizer or specific nutrients, depending on your test results, and lightly work them into the top few inches.\n\n'
          'Composting is the single best thing you can do for your soil. Garden or kitchen waste broken down over time produces crumbly organic matter that can be used as a mulch, soil conditioner, and a constituent of potting compost.',
    ),
  ];

  // ─── Public API ────────────────────────────────────────────────────────────

  /// Call once at app startup (e.g. in main() or a provider).
  /// Returns the list of articles to display (from cache or freshly shuffled).
  static Future<List<PlantArticle>> loadArticles() async {
    final prefs = await SharedPreferences.getInstance();

    final cached = prefs.getString(_cacheKey);
    final shouldRefresh = _shouldRefreshArticles(prefs);

    if (cached != null && !shouldRefresh) {
      try {
        final List decoded = jsonDecode(cached) as List;
        return decoded
            .map((e) => PlantArticle.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (_) {
        // Cache corrupt – fall through to rebuild
      }
    }

    // Build fresh list: shuffle seed articles, pick first 6
    final rng = Random();
    final shuffled = List<PlantArticle>.from(_seedArticles)..shuffle(rng);
    final articles = shuffled.take(6).toList();

    // Persist
    await prefs.setString(
        _cacheKey, jsonEncode(articles.map((a) => a.toJson()).toList()));
    await prefs.setInt(_cacheTimeKey, DateTime.now().millisecondsSinceEpoch);

    return articles;
  }

  // ─── Private helpers ───────────────────────────────────────────────────────

  /// Returns true if we haven't cached anything yet, OR with 40% probability.
  static bool _shouldRefreshArticles(SharedPreferences prefs) {
    final hasCache = prefs.containsKey(_cacheKey);
    if (!hasCache) return true;
    return Random().nextDouble() < 0.40; // 40% chance
  }
}