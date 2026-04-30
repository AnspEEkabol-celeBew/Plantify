import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

import '../../theme/colors.dart';
import '../../theme/fonts.dart';
import '../../util/image.dart';
import '../../util/text.dart';
import '../../util/layout.dart';
import 'article.dart';

class ArticleScreen extends StatelessWidget {
  final ArticleData article;

  const ArticleScreen({super.key, required this.article});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorAccent.background,
      body: CustomScrollView(
        slivers: [
          // ── App Bar with hero image ──────────────────────────────────────
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: colorAccent.background,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorAccent.background,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: colorAccent.primaryText,
                ),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () =>
                    Share.share('${article.title}\n${article.sourceUrl}\n\n - Article by Plantify.'),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorAccent.background,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.share_rounded,
                    color: colorAccent.primaryText,
                    size: 20,
                  ),
                ),
              ),
            ],
            centerTitle: true,
            title: UtilText(
              'Article',
              color: colorAccent.primaryText,
              size: 18,
              family: Fonts.defaultFontMedium,
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: UtilFitImage(
                article.imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // ── Article Body ────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colorAccent.secondary,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: UtilText(
                      article.category,
                      color: colorAccent.secondary,
                      size: 12,
                      family: Fonts.defaultFontMedium,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Title
                  UtilText(
                    article.title,
                    color: colorAccent.primaryText,
                    size: 24,
                    family: Fonts.defaultFontSemiBold,
                  ),
                  const SizedBox(height: 16),

                  // Introduction
                  _buildSectionHeading('Introduction'),
                  const SizedBox(height: 8),
                  _buildBody(article.intro),
                  const SizedBox(height: 20),

                  // Sections
                  ...article.sections.map(
                    (section) => Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeading(section.heading),
                          const SizedBox(height: 8),
                          _buildBody(section.body),
                        ],
                      ),
                    ),
                  ),

                  // Divider before source
                  Divider(color: colorAccent.cardLight, thickness: 1),
                  const SizedBox(height: 12),

                  // Source URL block
                  GestureDetector(
                    onTap: () => _launchUrl(article.sourceUrl),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: colorAccent.cardLight,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: colorAccent.secondary,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.link_rounded,
                            color: colorAccent.secondary,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                UtilText(
                                  'Source: ${article.sourceName}',
                                  color: colorAccent.primaryText,
                                  size: 13,
                                  family: Fonts.defaultFontMedium,
                                ),
                                const SizedBox(height: 2),
                                UtilText(
                                  article.sourceUrl,
                                  color: colorAccent.secondary,
                                  size: 11,
                                  family: Fonts.defaultFontExtraLight,
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.open_in_new_rounded,
                            color: colorAccent.secondary,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeading(String text) => UtilText(
    text,
    color: colorAccent.primaryText,
    size: 16,
    family: Fonts.defaultFontMedium,
  );

  Widget _buildBody(String text) => UtilText(
    text,
    color: colorAccent.secondaryText,
    size: 15,
    family: Fonts.defaultFontExtraLight,
  );
}
