// lib/screen/home/article_detail_screen.dart
//
// Full-article viewer (matches the "Article" screen in Image 2).
// Displays: hero image, title, body paragraphs, and the source URL.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme/colors.dart';
import '../../theme/fonts.dart';
import '../../util/appbar.dart';
import '../../util/snackbar.dart';
import '../../util/text.dart';
import '../../util/layout.dart';
import 'article_services.dart';

class ArticleDetailScreen extends StatelessWidget {
  const ArticleDetailScreen({super.key, required this.article});

  final PlantArticle article;

  Future<void> _launchUrl(BuildContext context) async {
    final uri = Uri.parse(article.sourceUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        _showSnackBar(context, 'Could not open the source URL.');
      }
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    showUtilSnackBar(
      context,
      duration: 2000,
      animationDuration: 200,
      color: colorAccent.cardDark,
      boxShadow: [
        BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.3), blurRadius: 5),
      ],
      width: 300,
      content: UtilText(
        message,
        align: TextAlign.center,
        family: Fonts.defaultFontRegular,
        color: colorAccent.primaryText,
        size: 15,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorAccent.background,
      // appBar: AppBar(
      //   backgroundColor: colorAccent.background,
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back, color: colorAccent.primaryText),
      //     onPressed: () => Navigator.of(context).pop(),
      //   ),
      //   title: UtilText(
      //     'Article',
      //     size: 20,
      //     family: Fonts.defaultFontSemiBold,
      //     color: colorAccent.primaryText,
      //   ),
      //   centerTitle: true,
      //   actions: [
      //     // Share button
      //     IconButton(
      //       icon: Icon(Icons.share_outlined, color: colorAccent.primaryText),
      //       onPressed: () {
      //         Clipboard.setData(ClipboardData(text: article.sourceUrl));
      //         ScaffoldMessenger.of(context).showSnackBar(
      //           const SnackBar(content: Text('URL copied to clipboard!')),
      //         );
      //       },
      //     ),
      //     // Bookmark (UI only – wire up to your own bookmarks feature)
      //     IconButton(
      //       icon: Icon(Icons.bookmark_outline, color: colorAccent.primaryText),
      //       onPressed: () {},
      //     ),
      //   ],
      // ),
      appBar: subAppbar(
        title: 'Article',
        addonChildren: [
          IconButton(
            icon: Icon(Icons.share_outlined, color: colorAccent.primaryText),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: article.sourceUrl));
              _showSnackBar(context, 'URL copied to clipboard!');
            },
          ),
          // Bookmark (UI only – wire up to your own bookmarks feature)
          // IconButton(
          //   icon: Icon(Icons.bookmark_outline, color: colorAccent.primaryText),
          //   onPressed: () {},
          // ),
        ]
      ),
      body: SingleChildScrollView(
        child: UtilFlexBox(
          gap: 0,
          children: [
            // ── Hero image ─────────────────────────────────────────────────
            _HeroImage(url: article.imageUrl),

            // ── Content ────────────────────────────────────────────────────
            UtilFlexBox(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              gap: 12,
              children: [
                // Title
                UtilText(
                  article.title,
                  size: 26,
                  family: Fonts.defaultFontSemiBold,
                  color: colorAccent.primaryText,
                ),

                // Source chip (tappable → opens URL)
                GestureDetector(
                  onTap: () => _launchUrl(context),
                  child: _SourceChip(article: article),
                ),

                const SizedBox(height: 4),

                // Body paragraphs
                ...article.body.split('\n\n').map(
                      (para) => para.trim().isEmpty
                          ? const SizedBox.shrink()
                          : UtilText(
                              para.trim(),
                              size: 16,
                              family: Fonts.defaultFontExtraLight,
                              color: colorAccent.secondaryText,
                            ),
                    ),

                const SizedBox(height: 8),

                // "Read full article" button
                GestureDetector(
                  onTap: () => _launchUrl(context),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: colorAccent.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        UtilText(
                          'Read Full Article',
                          size: 16,
                          family: Fonts.defaultFontMedium,
                          color: colorAccent.white,
                        ),
                        const SizedBox(width: 6),
                        Icon(Icons.open_in_new,
                            size: 16, color: colorAccent.white),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sub-widgets ──────────────────────────────────────────────────────────────

class _HeroImage extends StatelessWidget {
  const _HeroImage({required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(0),
        bottomRight: Radius.circular(0),
      ),
      child: Image.network(
        url,
        width: double.infinity,
        height: 240,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: double.infinity,
          height: 240,
          color: Colors.grey.shade200,
          child: const Icon(Icons.image_not_supported,
              size: 48, color: Colors.grey),
        ),
      ),
    );
  }
}

class _SourceChip extends StatelessWidget {
  const _SourceChip({required this.article});
  final PlantArticle article;

  @override
  Widget build(BuildContext context) {
    // Extract just the hostname for a clean label
    final host = Uri.tryParse(article.sourceUrl)?.host ?? article.sourceName;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorAccent.secondary.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorAccent.secondary.withOpacity(0.30),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.link, size: 14, color: colorAccent.secondary),
          const SizedBox(width: 4),
          Flexible(
            child: UtilText(
              host,
              size: 13,
              color: colorAccent.secondary,
              family: Fonts.defaultFontExtraLight,
            )
          ),
          const SizedBox(width: 4),
          Icon(Icons.open_in_new, size: 12, color: colorAccent.secondary),
        ],
      ),
    );
  }
}