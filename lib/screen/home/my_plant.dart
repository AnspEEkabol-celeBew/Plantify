import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:plantify/backend/firestore/firestore.dart';
import 'package:plantify/screen/home/plant_info.dart';
import 'package:plantify/storage/plants.dart';
import 'package:plantify/storage/preferences.dart';
import 'package:plantify/theme/colors.dart';
import 'package:plantify/theme/fonts.dart';
import 'package:plantify/util/appbar.dart';
import 'package:plantify/util/container.dart';
import 'package:plantify/util/image.dart';
import 'package:plantify/util/layout.dart';
import 'package:plantify/util/snackbar.dart';
import 'package:plantify/util/text.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'add_journal.dart';

class MyPlantScreen extends StatefulWidget {
  const MyPlantScreen({super.key, required this.gardenData});

  /// The entry from gardenList: { 'plant_id': '...', 'journal': [...] }
  final Map<String, dynamic> gardenData;

  @override
  State<MyPlantScreen> createState() => _MyPlantScreenState();
}

class _MyPlantScreenState extends State<MyPlantScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Map<String, dynamic> plant;
  late List<dynamic> journalList;
  final InternetConnection internetConnection = InternetConnection();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    plant = plants.getPlantById(widget.gardenData['plant_id']) ?? {};
    journalList = List<dynamic>.from(widget.gardenData['journal'] ?? []);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ─── Add Journal ──────────────────────────────────────────────────────────

  void _openAddJournal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorAccent.background,
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.95,
        child: SingleChildScrollView(
          child: AddJournalSheet(
            onSave: (Map<String, dynamic> entry) => _saveJournal(entry),
          )
        )
      ),
    );
  }

  Future<void> _saveJournal(Map<String, dynamic> entry) async {
    if (!(await internetConnection.hasInternetAccess)) {
      _showSnackBar("No Internet Connection");
      return;
    }
    Map<String, dynamic> userData = await loadPreferencesOnMap('userData', {});
    List<dynamic> gardenList = json.decode(userData['garden']);

    // Find this plant in the garden list and append the entry
    for (int i = 0; i < gardenList.length; i++) {
      if (gardenList[i]['plant_id'] == widget.gardenData['plant_id']) {
        gardenList[i]['journal'].add(entry);
        break;
      }
    }

    userData['garden'] = json.encode(gardenList);
    await savePreferencesOnMap('userData', userData);
    _updateToFirestore(userData);

    setState(() {
      journalList = List<dynamic>.from(
        gardenList.firstWhere(
          (g) => g['plant_id'] == widget.gardenData['plant_id'],
        )['journal'],
      );
    });

    _showSnackBar("Journal added!");
  }

  // ─── Delete Journal ───────────────────────────────────────────────────────

  Future<void> _deleteJournal(int index) async {
    if (!(await internetConnection.hasInternetAccess)) {
      _showSnackBar("No Internet Connection");
      return;
    }
    Map<String, dynamic> userData = await loadPreferencesOnMap('userData', {});
    List<dynamic> gardenList = json.decode(userData['garden']);

    for (int i = 0; i < gardenList.length; i++) {
      if (gardenList[i]['plant_id'] == widget.gardenData['plant_id']) {
        gardenList[i]['journal'].removeAt(index);
        break;
      }
    }

    userData['garden'] = json.encode(gardenList);
    await savePreferencesOnMap('userData', userData);
    _updateToFirestore(userData);

    setState(() {
      journalList.removeAt(index);
    });

    _showSnackBar("Journal deleted.");
  }

  void _updateToFirestore(Map<String, dynamic> userData) {
    FirestoreService firestoreService = FirestoreService();
    firestoreService.updateWhere(
      collection: 'users',
      field: 'uuid',
      isEqualTo: userData['uuid'],
      newData: userData,
    );
  }

  void _showSnackBar(String message) {
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

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorAccent.background,
      resizeToAvoidBottomInset: false,
      appBar: subAppbarModifyLeading(
        title: "My Plant",
        leading: UtilContainer(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: UtilFlexBox(
        direction: Axis.vertical,
        gap: 15,
        margin: EdgeInsets.symmetric(horizontal: 20),
        children: [
          // ── Hero Image ──────────────────────────────────────────────────
          UtilFitImage(
            plant['image_url'] ?? '',
            width: double.maxFinite,
            height: 220,
            borderRadius: BorderRadius.circular(20),
          ),

          // ── Plant Name / Taxonomy ────────────────────────────────────────
          UtilFlexBox(
            direction: Axis.vertical,
            gap: 4,
            children: [
              UtilText(
                plant['plant_name'] ?? '',
                size: 28,
                family: Fonts.defaultFontSemiBold,
                color: colorAccent.primaryText,
              ),
              UtilText(
                "Genus: ${plant['genus'] ?? ''}",
                size: 16,
                family: Fonts.defaultFontRegular,
                color: colorAccent.secondaryText,
              ),
              UtilText(
                "Specific Name: ${plant['scientific_name'] ?? ''}",
                size: 16,
                family: Fonts.defaultFontRegular,
                color: colorAccent.secondaryText,
              ),
            ],
          ),

          // ── Tab Bar ──────────────────────────────────────────────────────
          UtilContainer(
            width: double.maxFinite,
            borderRadius: BorderRadius.circular(12),
            color: colorAccent.cardLight,
            padding: EdgeInsets.all(4),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: colorAccent.secondary,
                borderRadius: BorderRadius.circular(10),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: colorAccent.white,
              unselectedLabelColor: colorAccent.secondaryText,
              dividerColor: Colors.transparent,
              labelStyle: TextStyle(
                fontFamily: Fonts.defaultFontMedium.fontFamily,
                fontSize: 15,
              ),
              unselectedLabelStyle: TextStyle(
                fontFamily: Fonts.defaultFontRegular.fontFamily,
                fontSize: 15,
              ),
              tabs: const [
                Tab(text: "Journal"),
                Tab(text: "Plant Info"),
              ],
            ),
          ),

          // ── Tab Views ────────────────────────────────────────────────────
          SizedBox(
            height: 300,
            child: TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                // ── Journal Tab ─────────────────────────────────────────
                SingleChildScrollView(
                  child: _JournalTab(
                    journalList: journalList,
                    onAddJournal: _openAddJournal,
                    onDeleteJournal: _deleteJournal,
                  ),
                ),

                // ── Plant Info Tab ──────────────────────────────────────
                SingleChildScrollView(child: PlantInfoSub(plant: plant)),
              ],
            ),
          ),

          SizedBox(height: 80),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Journal Tab
// ─────────────────────────────────────────────────────────────────────────────

class _JournalTab extends StatelessWidget {
  const _JournalTab({
    required this.journalList,
    required this.onAddJournal,
    required this.onDeleteJournal,
  });

  final List<dynamic> journalList;
  final VoidCallback onAddJournal;
  final Future<void> Function(int index) onDeleteJournal;

  @override
  Widget build(BuildContext context) {
    return UtilFlexBox(
      direction: Axis.vertical,
      gap: 10,
      children: [
        // Add Journal Button
        UtilContainer(
          onTap: onAddJournal,
          width: double.maxFinite,
          height: 56,
          borderRadius: BorderRadius.circular(100),
          color: colorAccent.secondary,
          alignment: Alignment.center,
          child: UtilText(
            "Add Journal",
            family: Fonts.defaultFontRegular,
            size: 16,
            color: colorAccent.white,
          ),
        ),

        // Journal Entries
        if (journalList.isEmpty)
          UtilContainer(
            padding: EdgeInsets.symmetric(vertical: 40),
            alignment: Alignment.center,
            child: UtilText(
              "No journal entries yet.",
              family: Fonts.defaultFontExtraLight,
              color: colorAccent.secondaryText,
              size: 15,
              align: TextAlign.center,
            ),
          )
        else
          ...List.generate(
            journalList.length,
            (i) => _JournalItem(
              entry: journalList[i],
              onDelete: () => onDeleteJournal(i),
            ),
          ).reversed,
      ],
    );
  }
}

// ─── Journal Item ─────────────────────────────────────────────────────────────

class _JournalItem extends StatelessWidget {
  const _JournalItem({required this.entry, required this.onDelete});

  final Map<String, dynamic> entry;
  final VoidCallback onDelete;

  static final _typeConfig = {
    'Watering': {'icon': Icons.water_drop, 'color': colorAccent.watering},
    'Fertilizing': {'icon': Icons.compost, 'color': colorAccent.fertilizing},
    'Trimming': {'icon': Icons.content_cut, 'color': colorAccent.trimming},
    'Notes': {'icon': Icons.note_alt, 'color': colorAccent.notes},
  };

  @override
  Widget build(BuildContext context) {
    final type = entry['type'] as String? ?? 'Notes';
    final cfg = _typeConfig[type] ?? _typeConfig['Notes']!;
    final color = cfg['color'] as Color;
    final icon = cfg['icon'] as IconData;
    final dateStr = entry['date'] as String? ?? '';
    final noteText = entry['note'] as String?;

    return UtilFlexBox(
      direction: Axis.vertical,
      color: colorAccent.cardLight,
      borderRadius: BorderRadius.circular(15),
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      gap: 8,
      children: [
        // ── Row: icon + title + menu ──────────────────────────────────────
        UtilFlexBox(
          direction: Axis.horizontal,
          cross: CrossAxisAlignment.center,
          children: [
            // Circle icon
            UtilContainer(
              width: 52,
              height: 52,
              borderRadius: BorderRadius.circular(100),
              color: color,
              alignment: Alignment.center,
              child: Icon(icon, color: Colors.white, size: 26),
            ),
            SizedBox(width: 12),
            // Title + date
            Expanded(
              child: UtilFlexBox(
                direction: Axis.vertical,
                gap: 3,
                children: [
                  UtilText(
                    type,
                    family: Fonts.defaultFontMedium,
                    size: 16,
                    color: colorAccent.primaryText,
                  ),
                  UtilText(
                    dateStr,
                    family: Fonts.defaultFontExtraLight,
                    size: 13,
                    color: colorAccent.secondaryText,
                  ),
                ],
              ),
            ),
            // 3-dot menu
            PopupMenuButton<String>(
              color: colorAccent.cardDark,
              icon: Icon(Icons.more_vert, color: colorAccent.secondaryText),
              onSelected: (val) {
                if (val == 'delete') onDelete();
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'delete',
                  child: UtilText(
                    "Delete",
                    family: Fonts.defaultFontRegular,
                    color: colorAccent.primaryText,
                    size: 15,
                  ),
                ),
              ],
            ),
          ],
        ),

        // ── Note text (if any) ────────────────────────────────────────────
        if (noteText != null && noteText.isNotEmpty) ...[
          Divider(color: colorAccent.secondaryText, height: 1),
          UtilText(
            noteText,
            family: Fonts.defaultFontRegular,
            size: 14,
            color: colorAccent.secondaryText,
          ),
        ],
      ],
    );
  }
}