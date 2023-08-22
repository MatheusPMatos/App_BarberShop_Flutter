import 'package:dw_barbershop/src/core/fp/either.dart';
import 'package:dw_barbershop/src/core/providers/application_providers.dart';
import 'package:dw_barbershop/src/features/auth/register/barbershop/barbershop_register_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'barbershop_register_vm.g.dart';

@riverpod
class BarbershopRegisterVm extends _$BarbershopRegisterVm {
  @override
  BarbershopRegisterState build() => BarbershopRegisterState.initial();

  void AddOrRemoveOpenDay(String weekDay){
    final openingDays = state.openingDays;
    if (openingDays.contains(weekDay)) {
      openingDays.remove(weekDay);
    }else{
      openingDays.add(weekDay);
    }
    state = state.copyWith(openingDays: openingDays);
  }

  void addOrRemoveOpenHour(int hour){
    final openningHours = state.openningHours;
    if (openningHours.contains(hour)) {
      openningHours.remove(hour);
    }else{
      openningHours.add(hour);
    }
    state = state.copyWith(openningHours:openningHours);
  }
  
  Future<void> register(String name, String email) async{
    final repository = ref.watch(barbershopRepositoryProvider);

    final BarbershopRegisterState(:openingDays, : openningHours) = state;

    final dto = (
      name: name,
      email: email,
      openingDays: openingDays,
      openningHours: openningHours
    );
    final result = await repository.save(dto);
    switch(result){
      case Sucess():
        ref.invalidate(getMyBarbershopProvider);
        state = state.copyWith(status: BarbershopRegisterStateStatus.sucess);
      case Failure():
        state = state.copyWith(status: BarbershopRegisterStateStatus.error);

    }
  }
}