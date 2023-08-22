
import 'package:dw_barbershop/src/core/fp/either.dart';
import 'package:dw_barbershop/src/core/providers/application_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
 part 'home_employee_provider.g.dart';
@riverpod
Future<int> getTotalSchedulesToday(GetTotalSchedulesTodayRef ref,int userId)async {

  final DateTime(:year, :month, :day)= DateTime.now();
  final scheduleRepository = ref.read(scheduleRepositoryProvider);
  final filter=(
    date: DateTime(year, month, day, 0,0,0),
    userId: userId
  );

   final scheduleResult = await scheduleRepository.findScheduleByDate(filter);
  
  return switch(scheduleResult){
    Sucess(value:  List(length: final totalschedules))=> totalschedules,
    Failure(:final exception)=> throw exception
  };

}