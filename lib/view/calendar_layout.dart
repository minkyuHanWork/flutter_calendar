import 'package:calendar/provider/calendar_provider.dart';
import 'package:calendar/provider/page_index_provider.dart';
import 'package:calendar/widget/calendar_foot.dart';
import 'package:calendar/widget/custom_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalendarLayout extends StatelessWidget {
  const CalendarLayout({super.key});
  static String get routeName => 'calendar';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(
            children: [
              const CustomCalendar(),
              Foot(height: 80, width: MediaQuery.of(context).size.width),
            ],
          ),
        ),
      ),
    );
  }
}
