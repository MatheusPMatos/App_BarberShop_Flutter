// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dw_barbershop/src/core/ui/widgets/constants.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:dw_barbershop/src/model/schedule_model.dart';

class AppointmenteDs extends CalendarDataSource {
  final List<ScheduleModel> schedules;
  AppointmenteDs({
    required this.schedules,
  });

  List<dynamic>? get appointments {
    return schedules.map((e) {

      final ScheduleModel(
      date: DateTime(:year, :month, :day), 
      :hour,
      :clientName
      ) = e;

      final startTime = DateTime(year, month, day, hour, 0, 0);
      final endTime = DateTime(year, month, day, hour +1, 0, 0);


      return Appointment(
        color: ColorsConstants.brow,
        startTime: startTime, 
        endTime: endTime,
        subject: clientName
        
        );

    }).toList();
  }
}
