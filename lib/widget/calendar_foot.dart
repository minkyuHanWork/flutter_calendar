import 'package:calendar/model/todo_model.dart';
import 'package:calendar/provider/calendar_provider.dart';
import 'package:calendar/provider/isar_provider.dart';
import 'package:calendar/provider/selected_day_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Foot extends ConsumerWidget {
  Foot({
    super.key,
    required this.height,
    required this.width,
  });

  final TextEditingController controller = TextEditingController();
  final double height;
  final double width;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final year = ref.watch(calendarProvider.select((value) => value.year));
    final month = ref.watch(calendarProvider.select((value) => value.month));
    final day = ref.watch(selectedDayProvider);
    return Positioned(
      height: 100,
      width: width,
      bottom: MediaQuery.of(context).viewInsets.bottom,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        height: 100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                height: 40,
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceVariant,
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.5),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.5),
                      ),
                    ),
                    hintText: day == 0 ? '날짜를 선택해주세요' : '$month월 $day일 일정 추가',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant
                          .withOpacity(0.7),
                    ),
                    contentPadding: const EdgeInsets.only(
                      left: 10.0,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5,
                fixedSize: const Size(50, 50),
                shape: const CircleBorder(),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).clearSnackBars();

                // day의 선택이 되고, 일정을 쓰고 추가 하려 할 때. -> 바로 추가함.
                if (controller.text.isEmpty) {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => BottomSheet(
                      onClosing: () {},
                      builder: (context) {
                        return Container(
                          color: Colors.amber,
                        );
                      },
                    ),
                  );
                } else {
                  ref
                      .read(calendarProvider.notifier)
                      .wirteTodo(TodoModel(
                        title: controller.text,
                        year: year,
                        month: month,
                        day: day,
                      ))
                      .then((value) {
                    if (value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('성공적으로 저장되었습니다.')));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('일정을 저장하지 못했습니다.')));
                    }
                  });
                  controller.clear();
                }

                // day의 선택이 되지 않았는데, 일정을 쓰고 추가하려 할 때,
                // -> 일정 추가 sheet 를 보여주고, title을 그걸로 등록해줌.

                // day를 선택하지 않고 추가하려할 때 sheet를 보여줌.
              },
              child: const Icon(Icons.add),
            )
          ],
        ),
      ),
    );
  }
}
