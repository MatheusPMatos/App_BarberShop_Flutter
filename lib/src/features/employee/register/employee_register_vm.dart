import 'package:asyncstate/asyncstate.dart';
import 'package:dw_barbershop/src/core/exceptions/repository_exception.dart';
import 'package:dw_barbershop/src/core/fp/nil.dart';
import 'package:dw_barbershop/src/core/providers/application_providers.dart';
import 'package:dw_barbershop/src/features/employee/register/employee_register_state.dart';
import 'package:dw_barbershop/src/model/barbershop_model.dart';
import 'package:dw_barbershop/src/repositories/user/user_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/fp/either.dart';

part 'employee_register_vm.g.dart';


@riverpod
class EmployeeRegisterVm extends _$EmployeeRegisterVm {

  @override
  EmployeeRegisterState build() => EmployeeRegisterState.initial();

  void setRegisterADM (bool isRegisterAdm){
    state = state.copyWith(registerAdm: isRegisterAdm);
  }

  void addOrRemoveWordDays(String weekDay){
    final EmployeeRegisterState(:workdays) = state;
    if(workdays.contains(weekDay)){
      workdays.remove(weekDay);
    }else {
      workdays.add(weekDay);
    }
    state = state.copyWith(workdays: workdays);
  }

  void addOrRemoveHours(int hours){
  final EmployeeRegisterState(:workHours) = state;
  if(workHours.contains(hours)){
    workHours.remove(hours);
  }else{
    workHours.add(hours);
  }
  state = state.copyWith(workHours: workHours);
  }

  Future<void> register({String? name, String? email, String? password, }) async {

    final EmployeeRegisterState(:registerAdm, :workdays, :workHours) = state;
    final asyncLoadhandler= AsyncLoaderHandler()..start();

    final UserRepository(:registerAdmAsEmployee, :registerEmployee)= ref.read(userRepositoryProvider);
    final Either<RepositoryException, Nil> resultRegister;

    if(registerAdm){
      final dto = (
        workdays: workdays,
        workHours: workHours
      );
      resultRegister = await registerAdmAsEmployee(dto);
    } else{
      final BarbershopModel(:id)= await ref.watch(getMyBarbershopProvider.future);
      final dto = (
        barbershopId: id,
        name: name!,
        email: email!,
        password: password!,
        workdays: workdays,
        workHours: workHours
      );
      resultRegister = await registerEmployee(dto);
    }

    switch (resultRegister) {
      case Sucess():
      state = state.copyWith(status: EmployeeRegisterStateStatus.sucess);
      case Failure():
      state = state.copyWith(status: EmployeeRegisterStateStatus.error);
      
    }
  asyncLoadhandler.close();

    }

  
}