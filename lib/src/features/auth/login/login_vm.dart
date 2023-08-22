import 'package:asyncstate/asyncstate.dart';
import 'package:dw_barbershop/src/core/exceptions/service_exception.dart';
import 'package:dw_barbershop/src/core/fp/either.dart';
import 'package:dw_barbershop/src/core/providers/application_providers.dart';
import 'package:dw_barbershop/src/features/auth/login/login_state.dart';
import 'package:dw_barbershop/src/model/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_vm.g.dart';

@riverpod
class LoginVm  extends _$LoginVm{

  @override
  LoginState build()=> LoginState.initial();

  

  Future<void> login(String email, String password) async {

    final loadHandler = AsyncLoaderHandler()..start();

    final loginService = ref.watch(userLoginServiceProvider);

    final result = await loginService.execute(email, password);
    switch (result) {
      case Sucess():

      // Invalidando caches para evitar o login com o usuário errado.
      ref.invalidate(getMeProvider);
      ref.invalidate(getMyBarbershopProvider);

      final userModel = await ref.read(getMeProvider.future);
      switch(userModel){
        case UserModelAdm():
        state = state.copywith(status: LoginStateStatus.admLogin);
        case UserModelEmploye():
        state = state.copywith(status: LoginStateStatus.employeeLogin);
      }
      
      case Failure(exception: ServiceException(: final message)):
        state = state.copywith(status: LoginStateStatus.error,
        errorMessage: () => message
        ); 
        
    }
      loadHandler.close();
    
  }
}