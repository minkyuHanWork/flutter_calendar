import 'package:calendar/common/default_value.dart';
import 'package:calendar/provider/calendar_provider.dart';
import 'package:calendar/provider/color_scheme_seed_provider.dart';
import 'package:calendar/provider/page_index_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Header extends ConsumerWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final color = ref.watch(colorSchemeSeedProvider);
    final year = ref.watch(calendarProvider.select((value) => value.year));
    final month = ref.watch(calendarProvider.select((value) => value.month));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
            // onPressed: () => ref.read(calendarProvider.notifier).prevMonth(),
            onPressed: () =>
                ref.read(pageControllerProvider.notifier).throttlePrev(),
            icon: const Icon(Icons.arrow_back_ios)),
        InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Pick a color!'),
                  content: SingleChildScrollView(
                    child: MaterialPicker(
                      pickerColor: color,
                      onColorChanged: (cColor) {
                        ref
                            .read(colorSchemeSeedProvider.notifier)
                            .update((state) => cColor);
                      },
                    ),
                    // Use Material color picker:
                    //
                    // child: MaterialPicker(
                    //   pickerColor: pickerColor,
                    //   onColorChanged: changeColor,
                    //   showLabel: true, // only on portrait mode
                    // ),
                    //
                    // Use Block color picker:
                    //
                    // child: BlockPicker(
                    //   pickerColor: currentColor,
                    //   onColorChanged: changeColor,
                    // ),
                    //
                    // child: MultipleChoiceBlockPicker(
                    //   pickerColors: currentColors,
                    //   onColorsChanged: changeColors,
                    // ),
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      child: const Text('Got it'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Text(
            '${year.toString()}.${month.toString().padLeft(2, '0')}',
            style: DV.titleTextStyle,
          ),
        ),
        IconButton(
            onPressed: () =>
                ref.read(pageControllerProvider.notifier).throttleNext(),
            icon: const Icon(Icons.arrow_forward_ios)),
      ],
    );
  }
}
