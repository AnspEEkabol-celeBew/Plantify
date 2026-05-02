import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plantify/backend/firestore/firestore.dart';
import 'package:plantify/storage/preferences.dart';
import 'package:plantify/theme/colors.dart';
import 'package:plantify/theme/fonts.dart';
import 'package:plantify/util/container.dart';
import 'package:plantify/util/date.dart';
import 'package:plantify/util/layout.dart';
import 'package:plantify/util/refresh.dart';
import 'package:plantify/util/snackbar.dart';
import 'package:plantify/util/text.dart';
import 'package:uuid/uuid.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../util/miscellaneous.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

UtilDate utilDate = UtilDate();

class _ReminderScreenState extends State<ReminderScreen> {
  List<dynamic> _reminders = [];
  DateTime _selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  final InternetConnection internetConnection = InternetConnection();

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    final userData = await loadPreferencesOnMap('userData', {});
    final raw = userData['reminder'] ?? '[]';
    setState(() {
      _reminders = json.decode(raw);
    });
  }

  List<dynamic> _remindersForDay(DateTime day) {
    return _reminders.where((r) {
      try {
        final startDate = DateTime.parse(r['start_date']);
        final repeatRaw = r['repeat'] as String? ?? 'Once';
        final d = DateTime(day.year, day.month, day.day);
        final s = DateTime(startDate.year, startDate.month, startDate.day);

        if (d.isBefore(s)) return false;

        switch (repeatRaw) {
          case 'Once':
            return d == s;
          case 'Every day':
            return true;
          case 'Every week':
            return d.difference(s).inDays % 7 == 0;
          case 'Every 2 days':
            return d.difference(s).inDays % 2 == 0;
          case 'Every month':
            return d.day == s.day;
          default:
            return d == s;
        }
      } catch (_) {
        return false;
      }
    }).toList();
  }

  bool _hasReminderOnDay(DateTime day) =>
      _remindersForDay(day).isNotEmpty;

  void _openAddReminder() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddReminderSheet(
        initialDate: _selectedDay,
        onSave: _saveReminder,
      ),
    );
  }

  Future<void> _saveReminder(Map<String, dynamic> entry) async {
    if (!(await internetConnection.hasInternetAccess)) {
      _showSnackBar("No Internet Connection");
      return;
    }
    final userData = await loadPreferencesOnMap('userData', {});
    final List<dynamic> list = json.decode(userData['reminder'] ?? '[]');
    list.add(entry);
    userData['reminder'] = json.encode(list);
    await savePreferencesOnMap('userData', userData);
    _updateFirestore(userData);
    setState(() => _reminders = list);
    _showSnackBar("Reminder saved!");
  }

  int findReminderIndex(List<dynamic> reminderList, String reminderId) {
    for (int l=0;l<reminderList.length;l++) {
      if (reminderList[l]['rid'] == reminderId) {
        return l;
      }
    }
    return -1;
  }

  Future<void> _deleteReminder(int index) async {
    if (!(await internetConnection.hasInternetAccess)) {
      _showSnackBar("No Internet Connection");
      return;
    }
    final userData = await loadPreferencesOnMap('userData', {});
    final List<dynamic> list = json.decode(userData['reminder'] ?? '[]');

    // Find the actual index in full list matching displayed reminders
    final displayed = _remindersForDay(_selectedDay);
    final target = displayed[index];

    int ind = findReminderIndex(list, target['rid']);

    if (ind != -1) {
      list.removeAt(ind);
    } else {
      debugPrint("edrfhhj");
    }

    userData['reminder'] = json.encode(list);
    await savePreferencesOnMap('userData', userData);
    _updateFirestore(userData);
    setState(() => _reminders = list);
    _showSnackBar("Reminder deleted.");
  }

  void _updateFirestore(Map<String, dynamic> userData) {
    FirestoreService().updateWhere(
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
      boxShadow: [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.3), blurRadius: 5)],
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
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    final displayedReminders = _remindersForDay(_selectedDay);
    final selectedLabel = _selectedDay == today
        ? "Today"
        : DateFormat('MMMM d, yyyy').format(_selectedDay);

    return UtilRefresh(
      onRefresh: () async {
        Future.wait([_loadReminders()]);
      },
      child: UtilFlexBox(
      direction: Axis.vertical,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      children: [
        // ── Calendar ──────────────────────────────────────────────────────
        UtilFlexBox(
          direction: Axis.vertical,
          children: [
            // Month nav
            UtilFlexBox(
              direction: Axis.horizontal,
              children: [
                UtilContainer(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () => setState(() => utilDate.shift(-1)),
                  child: Icon(Icons.navigate_before_rounded,
                      color: colorAccent.primaryText, size: 40),
                ),
                Expanded(
                  child: UtilText(
                    "${utilDate.getMonthName()} ${utilDate.getYearNow()}",
                    align: TextAlign.center,
                    size: 28,
                    family: Fonts.defaultFontSemiBold,
                    color: colorAccent.primaryText,
                  ),
                ),
                UtilContainer(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () => setState(() => utilDate.shift(1)),
                  child: Icon(Icons.navigate_next_rounded,
                      color: colorAccent.primaryText, size: 40),
                ),
              ],
            ),

            // Calendar grid with interactive days
            UtilGridBox(
              gapX: 5,
              gapY: 5,
              columns: 7,
              children: _buildCalendarGrid(
                utilDate.getYearNow(),
                utilDate.getMonthNow(),
              ),
            ),
          ],
        ),

        SizedBox(height: 16),

        // ── My Reminders header ────────────────────────────────────────────
        UtilFlexBox(
          direction: Axis.horizontal,
          cross: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: UtilFlexBox(
                direction: Axis.vertical,
                children: [
                  UtilText(
                    "My Reminders",
                    family: Fonts.defaultFontMedium,
                    size: 25,
                    color: colorAccent.primaryText,
                  ),
                  UtilText(
                    selectedLabel,
                    family: Fonts.defaultFontThin,
                    size: 17,
                    color: colorAccent.primaryText,
                  ),
                ],
              ),
            ),
            UtilContainer(
              onTap: _openAddReminder,
              color: colorAccent.tertiary,
              width: 50,
              height: 50,
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                ),
              ],
              alignment: Alignment.center,
              child: Icon(Icons.add, color: colorAccent.white),
            ),
          ],
        ),

        SizedBox(height: 10),

        // ── Reminder List ──────────────────────────────────────────────────
        Expanded(
          child: displayedReminders.isEmpty
              ? Center(
                  child: UtilText(
                    "No reminders here!",
                    family: Fonts.defaultFontExtraLight,
                    size: 16,
                    color: colorAccent.secondaryText,
                  ),
                )
              : SingleChildScrollView(
                  child: UtilFlexBox(
                    gap: 12,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    children: List.generate(
                      displayedReminders.length,
                      (i) => _ReminderItem(
                        reminder: displayedReminders[i],
                        onDelete: () => _deleteReminder(i),
                      ),
                    ),
                  ),
                ),
        ),
      ],
    ));
  }

  // ── Build interactive calendar grid ───────────────────────────────────────

  List<Widget> _buildCalendarGrid(int year, int month) {
    const headers = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    final headerWidgets = List.generate(
      headers.length,
      (i) => _CalendarCell(
        label: headers[i],
        isHeader: true,
        isSunday: i == 0,
      ),
    );

    final calData = generateCalendarData(year, month);

    final dayWidgets = List.generate(calData.length, (index) {
      final item = calData[index];
      final cellDate = DateTime(
        year,
        month + (item.isCurrentMonth ? 0 : (index < 7 ? -1 : 1)),
        item.day,
      );
      // Safer: reconstruct actual date
      final actualDate = _resolveDate(year, month, index, item);
      final isToday = actualDate == today;
      final isSelected = actualDate == _selectedDay;
      final hasReminder = item.isCurrentMonth && _hasReminderOnDay(actualDate);

      return _CalendarCell(
        label: item.day.toString(),
        isHeader: false,
        isSunday: index % 7 == 0,
        isCurrentMonth: item.isCurrentMonth,
        isToday: isToday,
        isSelected: isSelected,
        hasReminder: hasReminder,
        onTap: item.isCurrentMonth
            ? () => setState(() => _selectedDay = actualDate)
            : null,
      );
    });

    return headerWidgets + dayWidgets;
  }

  DateTime _resolveDate(int year, int month, int index, CalendarDay item) {
    if (!item.isCurrentMonth) {
      // previous or next month — approximate
      if (index < 7) {
        final prev = DateTime(year, month, 0);
        return DateTime(prev.year, prev.month, item.day);
      } else {
        final next = DateTime(year, month + 1, 1);
        return DateTime(next.year, next.month, item.day);
      }
    }
    return DateTime(year, month, item.day);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Calendar Cell
// ─────────────────────────────────────────────────────────────────────────────

class _CalendarCell extends StatelessWidget {
  const _CalendarCell({
    required this.label,
    required this.isHeader,
    required this.isSunday,
    this.isCurrentMonth = true,
    this.isToday = false,
    this.isSelected = false,
    this.hasReminder = false,
    this.onTap,
  });

  final String label;
  final bool isHeader;
  final bool isSunday;
  final bool isCurrentMonth;
  final bool isToday;
  final bool isSelected;
  final bool hasReminder;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textColor = isSunday
        ? colorAccent.sunday
        : colorAccent.primaryText;

    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: isCurrentMonth ? 1.0 : 0.3,
        child: UtilContainer(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Day number / header — today gets a green circle, selected gets a light circle
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isToday
                      ? colorAccent.primary
                      : isSelected
                          ? colorAccent.cardDark
                          : Colors.transparent,
                ),
                alignment: Alignment.center,
                child: UtilText(
                  label,
                  size: isHeader ? 14 : 16,
                  family: isHeader
                      ? Fonts.defaultFontMedium
                      : Fonts.defaultFontThin,
                  color: isToday
                      ? colorAccent.white
                      : textColor,
                ),
              ),

              // Blue dot indicator for reminders
              SizedBox(height: 2),
              Container(
                width: 18,
                height: 3,
                decoration: BoxDecoration(
                  color: hasReminder ? Colors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reminder Item
// ─────────────────────────────────────────────────────────────────────────────

class _ReminderItem extends StatelessWidget {
  const _ReminderItem({required this.reminder, required this.onDelete});

  final Map<String, dynamic> reminder;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final title = reminder['title'] as String? ?? '';
    final time = reminder['time'] as String? ?? '';
    final repeat = reminder['repeat'] as String? ?? '';

    return UtilFlexBox(
      padding: EdgeInsets.all(6),
      border: Border(
        left: BorderSide(
          color: colorAccent.secondary,
          width: 10,
        ),
      ),
      borderRadius: BorderRadius.circular(10),
      color: colorAccent.cardLight,
      width: double.maxFinite,
      direction: Axis.horizontal,
      cross: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: UtilFlexBox(
            direction: Axis.vertical,
            children: [
              UtilText(
                title,
                family: Fonts.defaultFontMedium,
                size: 18,
                color: colorAccent.primaryText,
              ),
              UtilText(
                "$time - $repeat",
                family: Fonts.defaultFontRegular,
                size: 14,
                color: colorAccent.primaryText,
              ),
            ],
          ),
        ),
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
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Add Reminder Sheet
// ─────────────────────────────────────────────────────────────────────────────

class AddReminderSheet extends StatefulWidget {
  const AddReminderSheet({
    super.key,
    required this.onSave,
    this.initialDate,
  });

  final Future<void> Function(Map<String, dynamic> entry) onSave;
  final DateTime? initialDate;

  @override
  State<AddReminderSheet> createState() => _AddReminderSheetState();
}

class _AddReminderSheetState extends State<AddReminderSheet> {
  Uuid uuid = Uuid();

  static const _reminderTypes = [
    'Watering',
    'Fertilizing',
    'Trimming',
    'Custom',
  ];

  static const _repeatOptions = [
    'Once',
    'Every day',
    'Every week',
    'Every 2 days',
    'Every month',
  ];

  String _selectedType = 'Watering';
  String _selectedRepeat = 'Once';
  late DateTime _selectedDate;
  TimeOfDay _selectedTime = TimeOfDay(hour: 8, minute: 0);
  final TextEditingController _customTitleController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _customTitleController.dispose();
    super.dispose();
  }

  String _formatTime(TimeOfDay t) {
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final min = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'am' : 'pm';
    return "$hour:$min $period";
  }

  String _formatDate(DateTime d) =>
      DateFormat('MMM d').format(d);

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  Future<void> _save() async {
    final title = _selectedType == 'Custom'
        ? _customTitleController.text.trim()
        : _selectedType;

    if (title.isEmpty) return;

    setState(() => _isSaving = true);

    String rid = uuid.v1();

    final entry = {
      'rid': rid,
      'title': title,
      'type': _selectedType,
      'start_date': _selectedDate.toIso8601String(),
      'time': _formatTime(_selectedTime),
      'repeat': _selectedRepeat,
    };

    await widget.onSave(entry);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).viewInsets.bottom + 50;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomPad),
      decoration: BoxDecoration(
        color: colorAccent.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: UtilFlexBox(
          direction: Axis.vertical,
          gap: 18,
          children: [
            // Handle
            Center(
              child: UtilContainer(
                width: 44,
                height: 4,
                borderRadius: BorderRadius.circular(100),
                color: colorAccent.secondaryText,
              ),
            ),

            UtilText(
              "Add Custom Reminder",
              size: 28,
              family: Fonts.defaultFontSemiBold,
              color: colorAccent.primaryText,
            ),

            // ── Remind me to ─────────────────────────────────────────────
            _FieldLabel("Remind me to"),
            _DropdownField(
              value: _selectedType,
              items: _reminderTypes,
              onChanged: (v) => setState(() => _selectedType = v!),
            ),

            // Custom title input (only if 'Custom')
            if (_selectedType == 'Custom') ...[
              _FieldLabel("Title"),
              _TextInputField(
                controller: _customTitleController,
                hint: "e.g. Check my garden",
              ),
            ],

            // ── Start Date ───────────────────────────────────────────────
            _FieldLabel("Start Date"),
            _TapField(
              label: _formatDate(_selectedDate),
              onTap: _pickDate,
            ),

            // ── Time ─────────────────────────────────────────────────────
            _FieldLabel("Time"),
            _TapField(
              label: _formatTime(_selectedTime),
              onTap: _pickTime,
            ),

            // ── Repeat ───────────────────────────────────────────────────
            _FieldLabel("Repeat"),
            _DropdownField(
              value: _selectedRepeat,
              items: _repeatOptions,
              onChanged: (v) => setState(() => _selectedRepeat = v!),
            ),

            // ── Buttons ──────────────────────────────────────────────────
            UtilFlexBox(
              direction: Axis.horizontal,
              gap: 12,
              children: [
                Expanded(
                  child: UtilContainer(
                    onTap: () => Navigator.pop(context),
                    height: 56,
                    borderRadius: BorderRadius.circular(100),
                    color: colorAccent.secondary,
                    alignment: Alignment.center,
                    child: UtilText(
                      "Cancel",
                      family: Fonts.defaultFontRegular,
                      size: 16,
                      color: colorAccent.white,
                    ),
                  ),
                ),
                Expanded(
                  child: UtilContainer(
                    onTap: _isSaving ? null : _save,
                    height: 56,
                    borderRadius: BorderRadius.circular(100),
                    color: colorAccent.secondary,
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
                            "Save",
                            family: Fonts.defaultFontRegular,
                            size: 16,
                            color: colorAccent.white,
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Small reusable sub-widgets for the sheet
// ─────────────────────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return UtilText(
      label,
      size: 15,
      family: Fonts.defaultFontMedium,
      color: colorAccent.primaryText,
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return UtilContainer(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      borderRadius: BorderRadius.circular(14),
      color: colorAccent.cardLight,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: colorAccent.cardLight,
          style: TextStyle(
            fontFamily: Fonts.defaultFontRegular.fontFamily,
            fontSize: 16,
            color: colorAccent.primaryText,
          ),
          icon: Icon(Icons.keyboard_arrow_down_rounded,
              color: colorAccent.primaryText),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _TapField extends StatelessWidget {
  const _TapField({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return UtilContainer(
      onTap: onTap,
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      borderRadius: BorderRadius.circular(14),
      color: colorAccent.cardLight,
      child: UtilFlexBox(
        direction: Axis.horizontal,
        cross: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: UtilText(
              label,
              family: Fonts.defaultFontRegular,
              size: 16,
              color: colorAccent.primaryText,
            ),
          ),
          Icon(Icons.keyboard_arrow_down_rounded,
              color: colorAccent.primaryText),
        ],
      ),
    );
  }
}

class _TextInputField extends StatelessWidget {
  const _TextInputField({required this.controller, required this.hint});

  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return UtilContainer(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      borderRadius: BorderRadius.circular(14),
      color: colorAccent.cardLight,
      child: TextField(
        controller: controller,
        style: TextStyle(
          fontFamily: Fonts.defaultFontRegular.fontFamily,
          fontSize: 16,
          color: colorAccent.primaryText,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(
            fontFamily: Fonts.defaultFontExtraLight.fontFamily,
            fontSize: 15,
            color: colorAccent.secondaryText,
          ),
        ),
      ),
    );
  }
}