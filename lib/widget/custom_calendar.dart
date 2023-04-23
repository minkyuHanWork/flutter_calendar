import 'package:calendar/common/type_def.dart';
import 'package:calendar/provider/calendar_length_provider.dart';
import 'package:calendar/provider/calendar_provider.dart';
import 'package:calendar/provider/isar_provider.dart';
import 'package:calendar/provider/page_index_provider.dart';
import 'package:calendar/provider/selected_day_provider.dart';
import 'package:calendar/widget/calendar_body.dart';
import 'package:calendar/widget/calendar_foot.dart';
import 'package:calendar/widget/calendar_header.dart';
import 'package:calendar/widget/calendar_weekend.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

String blueColor = Colors.blue.toString();

class CustomCalendar extends ConsumerStatefulWidget {
  const CustomCalendar({
    super.key,
    this.titleTextStyle,
    this.todayColor = Colors.lime,
  });

  final TitleTextStyle? titleTextStyle;
  final Color? todayColor;

  @override
  ConsumerState<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends ConsumerState<CustomCalendar> {
  final ScrollController controller = ScrollController();
  late PageController pageController;
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    controller.addListener(stretch);
    controller.addListener(shrink);
    pageController = ref.read(pageControllerProvider);
  }

  void stretch() {
    if (controller.position.userScrollDirection == ScrollDirection.forward) {
      ref.read(calendarLengthProvider.notifier).update((state) => true);
      // print('forward scrolls');
    }
  }

  void shrink() {
    if (controller.position.userScrollDirection == ScrollDirection.reverse) {
      ref.read(calendarLengthProvider.notifier).update((state) => false);
      // print('reverse scroll');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cache = ref.watch(todoCacheProvider);

    // Color(int.parse(('0xff${blueColor.split('0xff')[1].split('))')[0]}')))
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Header(),
          const SizedBox(height: 8.0),
          const Weekend(),
          _body(),
        ],
      ),
    );
  }

  Widget _body() {
    return Expanded(
      child: PageView.builder(
          controller: pageController,
          onPageChanged: (index) {
            ref.read(selectedDayProvider.notifier).update((state) => 0);

            int prevIndex = pageController.page!.toInt();
            if (prevIndex < index) {
              ref.read(calendarProvider.notifier).nextMonth();
            } else {
              ref.read(calendarProvider.notifier).prevMonth();
            }
          },
          itemBuilder: (context, index) {
            return LayoutBuilder(builder: (contex, cons) {
              return SingleChildScrollView(
                controller: controller,
                physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics()),
                child: CalendarBody(
                    height: cons.maxHeight - 80, width: cons.maxWidth),
              );
            });
          }),
    );
  }
}
