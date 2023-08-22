// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:dw_barbershop/src/core/ui/widgets/constants.dart';

class HoursPanel extends StatefulWidget {
  final List<int>? enableHours;
  final int starTime;
  final int endTime;
  final ValueChanged<int> onHourPressed;
  final bool singleSelection;

  const HoursPanel({
    super.key,
    this.enableHours,
    required this.starTime,
    required this.endTime,
    required this.onHourPressed,
  }) : singleSelection = false;

  const HoursPanel.singleSelection({
    super.key,
    this.enableHours,
    required this.starTime,
    required this.endTime,
    required this.onHourPressed,
  }) : singleSelection = true;

  @override
  State<HoursPanel> createState() => _HoursPanelState();
}

class _HoursPanelState extends State<HoursPanel> {
  int? lastSelection;

  @override
  Widget build(BuildContext context) {
    final HoursPanel(:singleSelection) = widget;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Selecione os horarios de atendimento.",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 16,
        ),
        Wrap(
          spacing: 8,
          runSpacing: 16,
          children: [
            for (int i = widget.starTime; i <= widget.endTime; i++)
              TimeButton(
                timeSelected: lastSelection,
                singleSelection: singleSelection,
                enableHours: widget.enableHours,
                label: '${i.toString().padLeft(2, '0')}:00 ',
                value: i,
                onPressed: (time) {
                  setState(() {
                    if (singleSelection) {
                      if (lastSelection == time) {
                        lastSelection = null;
                      } else {
                        lastSelection = time;
                      }
                    }
                  });

                  widget.onHourPressed(time);
                },
              )
          ],
        )
      ],
    );
  }
}

class TimeButton extends StatefulWidget {
  final List<int>? enableHours;
  final String label;
  final int value;
  final ValueChanged<int> onPressed;
  final bool singleSelection;
  final int? timeSelected;

  const TimeButton(
      {Key? key,
      this.enableHours,
      required this.label,
      required this.value,
      required this.onPressed,
      required this.singleSelection,
      required this.timeSelected})
      : super(key: key);

  @override
  State<TimeButton> createState() => _TimeButtonState();
}

class _TimeButtonState extends State<TimeButton> {
  var selected = false;
  @override
  Widget build(BuildContext context) {
    final TimeButton(
      :value,
      :label,
      :enableHours,
      :onPressed,
      :singleSelection,
      :timeSelected
    ) = widget;

    if (singleSelection) {
      if (timeSelected != null) {
        if (timeSelected == value) {
          selected = true;
        } else {
          selected = false;
        }
      }
    }

    final textcolor = selected ? Colors.white : ColorsConstants.grey;
    var buttonCollor = selected ? ColorsConstants.brow : Colors.white;
    final buttonBorderColors =
        selected ? ColorsConstants.brow : ColorsConstants.grey;

    final disableHour = enableHours != null && !enableHours.contains(value);
    if (disableHour) {
      buttonCollor = Colors.grey[400]!;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: disableHour
          ? null
          : () {
              onPressed(value);
              setState(() {
                selected = !selected;
              });
            },
      child: Container(
        width: 64,
        height: 36,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: buttonCollor,
            border: Border.all(color: buttonBorderColors)),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
                fontSize: 12, color: textcolor, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
