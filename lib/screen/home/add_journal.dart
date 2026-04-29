import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plantify/theme/colors.dart';
import 'package:plantify/theme/fonts.dart';
import 'package:plantify/util/container.dart';
import 'package:plantify/util/layout.dart';
import 'package:plantify/util/text.dart';

class AddJournalSheet extends StatefulWidget {
  const AddJournalSheet({super.key, required this.onSave});

  final Future<void> Function(Map<String, dynamic> entry) onSave;

  @override
  State<AddJournalSheet> createState() => _AddJournalSheetState();
}

class _AddJournalSheetState extends State<AddJournalSheet> {
  String? _selectedType;
  final TextEditingController _noteController = TextEditingController();
  bool _isSaving = false;

  static final _types = [
    {
      'label': 'Watering',
      'icon': Icons.water_drop,
      'color': colorAccent.watering,
    },
    {
      'label': 'Fertilizing',
      'icon': Icons.compost,
      'color': colorAccent.fertilizing,
    },
    {
      'label': 'Trimming',
      'icon': Icons.content_cut,
      'color': colorAccent.trimming,
    },
    {
      'label': 'Notes',
      'icon': Icons.note_alt,
      'color': colorAccent.notes,
    },
  ];

  Future<void> _save() async {
    if (_selectedType == null) return;

    setState(() => _isSaving = true);

    final now = DateTime.now();
    final dateStr = _formatDate(now);

    final entry = {
      'type': _selectedType,
      'date': dateStr,
      'note': _noteController.text.trim(),
    };

    await widget.onSave(entry);

    if (mounted) Navigator.pop(context);
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final day = DateTime(dt.year, dt.month, dt.day);

    final time = DateFormat('h:mm a').format(dt).toLowerCase();

    if (day == today) return "Today - $time";
    if (day == yesterday) return "Yesterday - $time";
    return "${DateFormat('MMM d, yyyy').format(dt)} - $time";
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomPad),
      decoration: BoxDecoration(
        color: colorAccent.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: UtilFlexBox(
        direction: Axis.vertical,
        gap: 18,
        children: [
          // ── Handle ─────────────────────────────────────────────────────────
          Center(
            child: UtilContainer(
              width: 44,
              height: 7,
              borderRadius: BorderRadius.circular(100),
              color: colorAccent.secondaryText,
            ),
          ),

          // ── Title ──────────────────────────────────────────────────────────
          UtilText(
            "Add Journal",
            size: 28,
            family: Fonts.defaultFontSemiBold,
            color: colorAccent.primaryText,
          ),

          // ── Type Selector ──────────────────────────────────────────────────
          UtilText(
            "Select Type",
            size: 18,
            family: Fonts.defaultFontRegular,
            color: colorAccent.primaryText,
          ),

          UtilFlexBox(
            direction: Axis.horizontal,
            gap: 10,
            children: List.generate(_types.length, (i) {
              final t = _types[i];
              final label = t['label'] as String;
              final icon = t['icon'] as IconData;
              final color = t['color'] as Color;
              final isSelected = _selectedType == label;

              return Expanded(
                child: UtilContainer(
                  onTap: () => setState(() => _selectedType = label),
                  height: 80,
                  borderRadius: BorderRadius.circular(14),
                  color: isSelected ? color : colorAccent.cardLight,
                  border: isSelected
                      ? Border.all(color: color, width: 2)
                      : null,
                  alignment: Alignment.center,
                  child: UtilFlexBox(
                    direction: Axis.vertical,
                    main: MainAxisAlignment.center,
                    cross: CrossAxisAlignment.center,
                    gap: 6,
                    children: [
                      Icon(
                        icon,
                        color: isSelected ? Colors.white : color,
                        size: 26,
                      ),
                      UtilText(
                        label,
                        size: 11,
                        family: Fonts.defaultFontRegular,
                        color: isSelected
                            ? Colors.white
                            : colorAccent.primaryText,
                        align: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),

          // ── Note (only for Notes type, optional for others) ────────────────
          UtilText(
            "Note (optional)",
            size: 18,
            family: Fonts.defaultFontRegular,
            color: colorAccent.primaryText,
          ),
          Container(
            decoration: BoxDecoration(
              color: colorAccent.cardLight,
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: TextField(
              controller: _noteController,
              maxLines: 4,
              style: TextStyle(
                fontFamily: Fonts.defaultFontRegular.fontFamily,
                fontSize: 15,
                color: colorAccent.primaryText,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Write something about this activity...",
                hintStyle: TextStyle(
                  fontFamily: Fonts.defaultFontExtraLight.fontFamily,
                  fontSize: 14,
                  color: colorAccent.secondaryText,
                ),
              ),
            ),
          ),

          // ── Save Button ────────────────────────────────────────────────────
          UtilContainer(
            onTap: _selectedType == null || _isSaving ? null : _save,
            width: double.maxFinite,
            height: 56,
            borderRadius: BorderRadius.circular(100),
            color: _selectedType == null
                ? colorAccent.secondaryText
                : colorAccent.secondary,
            alignment: Alignment.center,
            child: _isSaving
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colorAccent.white,
                    ),
                  )
                : UtilText(
                    "Save Journal",
                    family: Fonts.defaultFontRegular,
                    size: 16,
                    color: colorAccent.white,
                  ),
          ),
        ],
      ),
    );
  }
}