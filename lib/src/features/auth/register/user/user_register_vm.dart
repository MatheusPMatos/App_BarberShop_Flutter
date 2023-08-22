
import 'package:asyncstate/asyncstate.dart';
import 'package:dw_barbershop/src/core/fp/either.dart';
import 'package:dw_barbershop/src/core/providers/application_providers.dart';
import 'package:dw_barbershop/src/features/auth/register/user/user_register_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_register_vm.g.dart';


enum UserRegisterStateStatus{
  initial,
  sucess,
  error
}

@riverpod
class UserRegisterVm  extends _$UserRegisterVm {

  @override
  UserRegisterStateStatus build()=> UserRegisterStateStatus.initial;

  Future<void> register({ required String name,required String email,required String password}) async {

    final userRegisterService= ref.watch(userRegisterAdmServiceProvider);

    final userData = (
      name: name,
      email: email,
      password: password
    );

    final registerResult =await userRegisterService.execute(userData).asyncLoader();

    switch (registerResult) {
      case Sucess():
        ref.invalidate(getMeProvider);
        state = UserRegisterStateStatus.sucess;
      case Failure():
        state = UserRegisterStateStatus.error;
    }
  }
}