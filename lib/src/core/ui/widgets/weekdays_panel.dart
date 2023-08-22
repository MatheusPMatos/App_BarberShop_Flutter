// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:dw_barbershop/src/core/ui/widgets/constants.dart';

class WeekdaysPanel extends StatelessWidget {
  final List<String>? enableDays;
   final ValueChanged<String> onDaySelected;
  const WeekdaysPanel({
    Key? key,
    required this.onDaySelected, this.enableDays,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Selecione os dias da semana",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 16,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ButtonDay(label: 'Seg', onDaySelected: onDaySelected, enableDays: enableDays),
              ButtonDay(label: 'Ter', onDaySelected: onDaySelected, enableDays: enableDays),
              ButtonDay(label: 'Qua', onDaySelected: onDaySelected, enableDays: enableDays),
              ButtonDay(label: 'Qui', onDaySelected: onDaySelected, enableDays: enableDays),
              ButtonDay(label: 'Sex', onDaySelected: onDaySelected, enableDays: enableDays),
              ButtonDay(label: 'Sab', onDaySelected: onDaySelected, enableDays: enableDays),
              ButtonDay(label: 'Dom', onDaySelected: onDaySelected, enableDays: enableDays),
            ],
          ),
        )
      ],
    );
  }
}

class ButtonDay extends StatefulWidget {
  final String label;
  final ValueChanged<String> onDaySelected;
  final List<String>? enableDays;

  const ButtonDay({
    Key? key,
    required this.label,
    required this.onDaySelected,
    this.enableDays,
  }) : super(key: key);

  @override
  State<ButtonDay> createState() => _ButtonDayState();
}

class _ButtonDayState extends State<ButtonDay> {
  var selected = false;
  @override
  Widget build(BuildContext context) {
    final textcolor = selected ? Colors.white : ColorsConstants.grey;
    var buttonCollor = selected ? ColorsConstants.brow : Colors.white;
    final buttonBorderColors =
        selected ? ColorsConstants.brow : ColorsConstants.grey;

    final ButtonDay(:enableDays, :label) = widget;
    final disableDay = enableDays != null && !enableDays.contains(label);
    if(disableDay){
      buttonCollor = Colors.grey[400]!;
    }

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap:  disableDay? null : () {
          widget.onDaySelected(label);
          setState(() {
            selected = !selected;
          });
        },
        child: Container(
          width: 40,
          height: 56,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: buttonCollor,
              border: Border.all(color: buttonBorderColors)),
          child: Center(
            child: Text(
              widget.label,
              style: TextStyle(
                  fontSize: 12, color: textcolor, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}
