import 'package:calendar/common/calendar_functions.dart';
import 'package:calendar/common/default_value.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class Weekend extends StatelessWidget {
  const Weekend({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: DV.week
          .mapIndexed(
            (i, e) => Flexible(
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(e,
                    style: TextStyle(
                        color: CF.getColorByIndex(i),
                        fontWeight: FontWeight.w500)),
              )),
            ),
          )
          .toList(),
    );
  }
}
