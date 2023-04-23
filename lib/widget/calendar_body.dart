import 'package:calendar/common/calendar_functions.dart';
import 'package:calendar/model/day_model.dart';
import 'package:calendar/provider/calendar_length_provider.dart';
import 'package:calendar/provider/calendar_provider.dart';
import 'package:calendar/provider/page_index_provider.dart';
import 'package:calendar/provider/selected_day_provider.dart';
import 'package:calendar/widget/calendar_foot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

class CalendarBody extends StatelessWidget {
  const CalendarBody({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _calendar(),
        _todoList(),
      ],
    );
  }

  Widget _todoList() {
    return Consumer(builder: (context, ref, _) {
      final bool isLong = ref.watch(calendarLengthProvider);
      final List<DayModel> days =
          ref.watch(calendarProvider.select((value) => value.days));
      final int selectedDay = ref.watch(selectedDayProvider);
      final day = days.firstWhere(
        (e) => e.day == selectedDay,
        orElse: () => DayModel(
            year: 0,
            month: 0,
            day: 0,
            inMonth: MonthState.currunt,
            picked: false,
            today: false),
      );
      return AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: isLong ? 0 : height / 2,
        decoration: BoxDecoration(
          border: isLong
              ? null
              : Border(
                  top: BorderSide(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  ),
                ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.separated(
            itemCount: day.todoList.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8.0),
            itemBuilder: (context, index) {
              final todo = day.todoList[index];
              return Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: todo.color != null
                        ? Color(todo.color!)
                        : Theme.of(context).colorScheme.primary,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    Text(
                      '${todo.title}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    });
  }

  Widget _calendar() {
    return Consumer(builder: (context, ref, _) {
      final bool isLong = ref.watch(calendarLengthProvider);
      final List<DayModel> days =
          ref.watch(calendarProvider.select((value) => value.days));
      final int selectedDay = ref.watch(selectedDayProvider);
      return Wrap(
        children: days
            .mapIndexed((i, e) => InkWell(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (e.inMonth == MonthState.prev) {
                      ref.read(pageControllerProvider.notifier).throttlePrev();
                    } else if (e.inMonth == MonthState.next) {
                      ref.read(pageControllerProvider.notifier).throttleNext();
                    } else {
                      ref
                          .read(selectedDayProvider.notifier)
                          .update((state) => e.day);
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: width / 7,
                    height: isLong ? height / 6 : height / 12,
                    color: (selectedDay == e.day &&
                            e.inMonth == MonthState.currunt)
                        ? Theme.of(context).colorScheme.primary.withOpacity(0.6)
                        : null,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: e.today
                                ? Theme.of(context).colorScheme.primaryContainer
                                : null,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            e.day.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: e.inMonth == MonthState.currunt
                                  ? CF.getColorByIndex(i)
                                  : Colors.grey,
                            ),
                          ),
                        ),
                        if (e.todoList.length < 10)
                          Center(
                            child: Wrap(
                              spacing: 2,
                              runSpacing: 2,
                              children: e.todoList
                                  .map(
                                    (e) => CircleAvatar(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                      radius: 2,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        if (e.todoList.length >= 10)
                          Padding(
                            padding: const EdgeInsets.all(2),
                            child: Text(
                              '+${e.todoList.length}',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          )
                      ],
                    ),
                  ),
                ))
            .toList(),
      );
    });
  }
}
