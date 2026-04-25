import 'package:flutter/material.dart';
import 'package:plantify/theme/colors.dart';
import 'package:plantify/util/container.dart';
import 'package:plantify/util/date.dart';
import 'package:plantify/util/layout.dart';
import 'package:plantify/util/text.dart';

import '../../theme/fonts.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

UtilDate utilDate = UtilDate();

class _ReminderScreenState extends State<ReminderScreen> {
  @override
  Widget build(BuildContext context) {
    return UtilFlexBox(
      direction: Axis.vertical,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      children: [
        //calendar
        UtilFlexBox(
          direction: Axis.vertical,
          children: [
            UtilFlexBox(
              direction: Axis.horizontal,
              children: [
                UtilContainer(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () {
                    setState(() {
                      utilDate.shift(-1);
                    });
                  },
                  child: Icon(Icons.navigate_before_rounded, color: colorAccent.primaryText, size: 40),
                ),
                Expanded(
                  child: UtilText(
                    "${utilDate.getMonthName()} ${utilDate.getYearNow().toString()}",
                    align: TextAlign.center,
                    size: 28,
                    family: Fonts.defaultFontSemiBold,
                    color: colorAccent.primaryText,
                  ),
                ),
                UtilContainer(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () {
                    setState(() {
                      utilDate.shift(1);
                    });
                  },
                  child: Icon(Icons.navigate_next_rounded, color: colorAccent.primaryText, size: 40),
                ),
              ],
            ),
            UtilGridBox(
              gapX: 5,
              gapY: 5,
              columns: 7,
              children: generateCalendarGrid(utilDate.getYearNow(), utilDate.getMonthNow()),
            )
          ],
        ),

        //my reminders and add
        UtilFlexBox(
          direction: Axis.vertical,
          children: [
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
                        "April 11, 2026",
                        family: Fonts.defaultFontThin,
                        size: 17,
                        color: colorAccent.primaryText,
                      )
                    ],
                  ),
                ),
                UtilContainer(
                  color: colorAccent.tertiary,
                  width: 50,
                  height: 50,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                    )
                  ],
                  child: Icon(Icons.add, color: colorAccent.white),
                )
              ],
            )
          ],
        ),

        Expanded(
          child: SingleChildScrollView(
            child: UtilFlexBox(
              gap: 12,
              margin: EdgeInsets.symmetric(vertical: 20),
              children: [
                ReminderList(
                  title: 'Watering my Hibiscus',
                  isCustom: false,
                  time: '10:00 am',
                  repeat: 'Everyday',
                ),
                ReminderList(
                  title: 'Exploring my Garden',
                  isCustom: true,
                  time: '1:00 pm',
                  repeat: 'Every week',
                ),
                ReminderList(
                  title: 'Watering my Sunflower',
                  isCustom: false,
                  time: '1:00 pm',
                  repeat: 'Every 2 days',
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class ReminderList extends StatelessWidget {
  const ReminderList({
    required this.title,
    required this.isCustom,
    required this.time,
    required this.repeat,
    super.key,
  });

  final String title;
  final bool isCustom;
  final String time;
  final String repeat;

  @override
  Widget build(BuildContext context) {
    return UtilFlexBox(
      padding: EdgeInsets.all(6),
      border: Border(
        left: BorderSide(
          color: isCustom? colorAccent.customReminder : colorAccent.myGardenReminder,
          width: 10
        )
      ),
      borderRadius: BorderRadius.circular(10),
      color: colorAccent.cardLight,
      width: double.maxFinite,
      direction: Axis.vertical,
      children: [
        UtilText(
          title,
          family: Fonts.defaultFontMedium,
          size: 21,
          color: colorAccent.primaryText,
        ),
        UtilText(
          isCustom? 'Custom Reminder' : 'My Garden',
          family: Fonts.defaultFontExtraLight,
          size: 12,
          color: colorAccent.primaryText,
        ),
        UtilText(
          "$time - $repeat",
          family: Fonts.defaultFontRegular,
          size: 17,
          color: colorAccent.primaryText,
        ),
      ],
    );
  }
}
