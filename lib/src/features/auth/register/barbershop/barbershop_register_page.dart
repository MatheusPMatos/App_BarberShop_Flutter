import 'package:dw_barbershop/src/core/ui/helpers/form_helper.dart';
import 'package:dw_barbershop/src/core/ui/helpers/messages.dart';
import 'package:dw_barbershop/src/core/ui/widgets/hours_panel.dart';
import 'package:dw_barbershop/src/core/ui/widgets/weekdays_panel.dart';
import 'package:dw_barbershop/src/features/auth/register/barbershop/barbershop_register_state.dart';
import 'package:dw_barbershop/src/features/auth/register/barbershop/barbershop_register_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:validatorless/validatorless.dart';

class BarbershopRegisterPage extends ConsumerStatefulWidget {
  const BarbershopRegisterPage({super.key});

  @override
  ConsumerState<BarbershopRegisterPage> createState() =>
      _BarbershopRegisterPageState();
}

class _BarbershopRegisterPageState
    extends ConsumerState<BarbershopRegisterPage> {

     final _formKey = GlobalKey<FormState>();
     final _nameEC = TextEditingController(); 
     final _emailEC = TextEditingController();

     @override
  void dispose() {
    _emailEC.dispose();
    _nameEC.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final barbershopRegisterVm =
        ref.watch(barbershopRegisterVmProvider.notifier);
    ref.listen(barbershopRegisterVmProvider, (_, state) {
      switch (state.status) {
        case BarbershopRegisterStateStatus.initial:
        break;
        case BarbershopRegisterStateStatus.error:
          Messages.showError("Desculpe, ocorreu um erro ao registrar o estabelecimento", context);
        case BarbershopRegisterStateStatus.sucess:
          Navigator.of(context).pushNamedAndRemoveUntil('/home/adm', (route) => false);
      }
    },);
  
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar estabelecimento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: _nameEC,
                  validator: Validatorless.required('Nome obrigatório'),
                  onTapOutside: (event) => context.unfocus(),
                  decoration: const InputDecoration(label: Text('Nome')),
                ),
                const SizedBox(
                  height: 14,
                ),
                TextFormField(
                  controller: _emailEC,
                  validator: Validatorless.multiple([
                    Validatorless.required('Email Obrigatório'),
                    Validatorless.email('Email invalido.')
                  ]),
                  onTapOutside: (event) => context.unfocus(),
                  decoration: const InputDecoration(label: Text('E-mail')),
                ),
                const SizedBox(
                  height: 14,
                ),
                WeekdaysPanel(
                  onDaySelected: (value) =>
                      barbershopRegisterVm.AddOrRemoveOpenDay(value),
                ),
                const SizedBox(
                  height: 24,
                ),
                HoursPanel(
                  starTime: 6,
                  endTime: 23,
                  onHourPressed: (value) =>
                      barbershopRegisterVm.addOrRemoveOpenHour(value),
                ),
                const SizedBox(
                  height: 24,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(56)),
                    onPressed: () {
                      switch (_formKey.currentState?.validate()) {
                        case false || null:
                        Messages.showError('Formulário Inválido', context);
                        case true:
                          barbershopRegisterVm.register(_nameEC.text, _emailEC.text); 
                      }
                    },
                    child: const Text('CADASTRAR ESTABELECIMENTO'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
