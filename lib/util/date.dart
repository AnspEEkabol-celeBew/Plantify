import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plantify/util/text.dart';

import '../theme/colors.dart';
import '../theme/fonts.dart';
import 'container.dart';

class UtilDate {
  DateTime dateNow = DateTime.now();
  late int month = dateNow.month;
  late int year = dateNow.year;

  int getMonthNow() {
    return month;
  }

  String getMonthName() {
    const months = [
      'January', 'February', 'March', 'April',
      'May', 'June', 'July', 'August',
      'September', 'October', 'November', 'December'
    ];

    return months[month - 1];
  }

  int getYearNow() {
    return year;
  }

  void shift(int shift) {
    int tempMonth = month + shift;
    int tempYear = year;
    if (tempMonth > 12) {
        tempMonth -= 12;
        tempYear++;
        if (tempYear > 2100) return;
    } else if (tempMonth < 1) {
        tempMonth += 12;
        tempYear--;
        if (tempYear < 1800) return;
    }

    year = tempYear;
    month = tempMonth;
  }
}

Widget getBlockDay(String? day, int index, bool header, bool currentMonth) {
  return Opacity(
    opacity: currentMonth? 1 : 0.3,
    child: UtilContainer(
      alignment: Alignment.center,
      child: UtilText(
        day?? "",
        size: 20,
        family: header? Fonts.defaultFontMedium : Fonts.defaultFontThin,
        color: index % 7 == 0? colorAccent.sunday : colorAccent.primaryText,
      ),
    ),
  );
}

class CalendarDay {
  final int day;
  final bool isCurrentMonth;

  CalendarDay({required this.day, required this.isCurrentMonth});
}

List<CalendarDay> generateCalendarData(int year, int month) {
  int totalSlots = 42;

  DateTime firstDay = DateTime(year, month, 1);
  int startIndex = firstDay.weekday % 7;

  int daysInMonth = DateTime(year, month + 1, 0).day;

  // Previous month
  int prevMonthDays = DateTime(year, month, 0).day;

  List<CalendarDay> calendar = List.generate(totalSlots, (i) {
    int dayNum = i - startIndex + 1;

    if (i < startIndex) {
      return CalendarDay(
        day: prevMonthDays - (startIndex - i - 1),
        isCurrentMonth: false,
      );
    }

    if (dayNum <= daysInMonth) {
      return CalendarDay(
        day: dayNum,
        isCurrentMonth: true,
      );
    }

    // 🔹 Next month
    return CalendarDay(
      day: dayNum - daysInMonth,
      isCurrentMonth: false,
    );
  });

  return calendar;
}

List<Widget> generateCalendarGrid(int year, int month) {
  const List<String> weeksSlot = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'];

  final weeksTemplate = List.generate(
    weeksSlot.length,
    (ind) => getBlockDay(weeksSlot[ind], ind, true, true),
  );

  final calendarData = generateCalendarData(year, month);

  final calendarWidgets = List.generate(calendarData.length, (index) {
    final item = calendarData[index];

    return getBlockDay(
      item.day.toString(),
      index,
      false,
      item.isCurrentMonth,
    );
  });

  return weeksTemplate + calendarWidgets;
}

int calculateAge(DateTime birthDate, {DateTime? currentDate}) {
  final today = currentDate ?? DateTime.now();

  int age = today.year - birthDate.year;

  // Check if birthday has not occurred yet this year
  final hasNotHadBirthdayYet =
      (today.month < birthDate.month) ||
      (today.month == birthDate.month && today.day < birthDate.day);

  if (hasNotHadBirthdayYet) {
    age--;
  }

  return age;
}

class UtilDateController extends ValueNotifier<DateTime?> {
  UtilDateController(super.value);

  void setDate(DateTime date) {
    value = date;
  }
}

class UtilDateInput extends StatefulWidget {
  final UtilDateController? controller;
  final DateTime? value;
  final ValueChanged<DateTime>? onChanged;

  // size (LIKE CONTAINER)
  final double? width;
  final double? height;

  // layout
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry? alignment;

  // style
  final Color? color;
  final Color? focusColor;
  final Color? disabledColor;

  final Gradient? gradient;
  final BorderRadius? borderRadius;

  final BoxBorder? border;
  final BoxBorder? focusBorder;
  final BoxBorder? disabledBorder;

  final List<BoxShadow>? boxShadow;

  // text (UTILTEXT STYLE)
  final double? fontSize;
  final Color? textColor;
  final Fonts? fonts;

  final double? placeholderSize;
  final Color? placeholderColor;
  final Fonts? placeholderFonts;

  final String placeholder;

  // extras
  final Widget? prefix;
  final Widget? suffix;

  final DateTime? firstDate;
  final DateTime? lastDate;

  final String dateFormat;

  final bool enabled;

  const UtilDateInput({
    super.key,
    this.controller,
    this.value,
    this.onChanged,

    this.width,
    this.height,
    this.margin,
    this.padding,
    this.alignment,

    this.color,
    this.focusColor,
    this.disabledColor,

    this.gradient,
    this.borderRadius,

    this.border,
    this.focusBorder,
    this.disabledBorder,

    this.boxShadow,

    this.fontSize,
    this.textColor,
    this.fonts,

    this.placeholderSize,
    this.placeholderColor,
    this.placeholderFonts,

    this.placeholder = "Select date",

    this.prefix,
    this.suffix,

    this.firstDate,
    this.lastDate,

    this.dateFormat = "MMMM d, y",

    this.enabled = true,
  });

  @override
  State<UtilDateInput> createState() => _UtilDateInputState();
}

class _UtilDateInputState extends State<UtilDateInput> {
  bool isFocused = false;

  DateTime? get currentValue =>
      widget.controller?.value ?? widget.value;

  String formatDate(DateTime date) {
    return DateFormat(widget.dateFormat).format(date);
  }

  Future<void> pickDate() async {
    if (!widget.enabled) return;

    final picked = await showDatePicker(
      context: context,
      initialDate: currentValue ?? DateTime.now(),
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? DateTime(2100),
    );

    if (picked != null) {
      widget.controller?.setDate(picked);
      widget.onChanged?.call(picked);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final date = currentValue;

    final currentColor = !widget.enabled
        ? widget.disabledColor ?? widget.color
        : isFocused
            ? widget.focusColor ?? widget.color
            : widget.color;

    final currentBorder = !widget.enabled
        ? widget.disabledBorder ?? widget.border
        : isFocused
            ? widget.focusBorder ?? widget.border
            : widget.border;

    Widget textWidget = Text(
      date != null ? formatDate(date) : widget.placeholder,
      style: TextStyle(
        fontSize: date != null
            ? widget.fontSize
            : widget.placeholderSize ?? widget.fontSize,
        color: date != null
            ? widget.textColor
            : widget.placeholderColor ?? Colors.grey,
        fontFamily: date != null
            ? widget.fonts?.fontFamily
            : widget.placeholderFonts?.fontFamily ??
                widget.fonts?.fontFamily,
        fontWeight: date != null
            ? widget.fonts?.weight
            : widget.placeholderFonts?.weight ?? widget.fonts?.weight,
        fontStyle: date != null
            ? widget.fonts?.style
            : widget.placeholderFonts?.style ?? widget.fonts?.style,
      ),
    );

    return GestureDetector(
      onTap: pickDate,
      child: Container(
        width: widget.width,
        height: widget.height,
        margin: widget.margin,
        padding: widget.padding ??
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        alignment: widget.alignment,
        decoration: BoxDecoration(
          color: widget.gradient == null ? currentColor : null,
          gradient: widget.gradient,
          borderRadius: widget.borderRadius,
          border: currentBorder,
          boxShadow: widget.boxShadow,
        ),
        child: Row(
          children: [
            if (widget.prefix != null) ...[
              widget.prefix!,
              const SizedBox(width: 8),
            ],

            Expanded(child: textWidget),

            if (widget.suffix != null) ...[
              const SizedBox(width: 8),
              widget.suffix!,
            ]
          ],
        ),
      ),
    );
  }
}