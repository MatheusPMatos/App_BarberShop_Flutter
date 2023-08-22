import 'dart:developer';

import 'package:dw_barbershop/src/core/providers/application_providers.dart';
import 'package:dw_barbershop/src/core/ui/helpers/messages.dart';
import 'package:dw_barbershop/src/core/ui/widgets/avatar_widget.dart';
import 'package:dw_barbershop/src/core/ui/widgets/barbershop_loader.dart';
import 'package:dw_barbershop/src/core/ui/widgets/hours_panel.dart';
import 'package:dw_barbershop/src/core/ui/widgets/weekdays_panel.dart';
import 'package:dw_barbershop/src/features/employee/register/employee_register_state.dart';
import 'package:dw_barbershop/src/features/employee/register/employee_register_vm.dart';
import 'package:dw_barbershop/src/features/home/adm/home_adm_vm.dart';
import 'package:dw_barbershop/src/model/barbershop_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:validatorless/validatorless.dart';

class EmployeeRegisterPage extends ConsumerStatefulWidget {
  const EmployeeRegisterPage({super.key});

  @override
  ConsumerState<EmployeeRegisterPage> createState() =>
      _EmployeeRegisterPageState();
}

class _EmployeeRegisterPageState extends ConsumerState<EmployeeRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeEC = TextEditingController();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();

  @override
  void dispose() {
    _emailEC.dispose();
    _nomeEC.dispose();
    _passwordEC.dispose();
    super.dispose();
  }

  var registerAdm = false;

  @override
  Widget build(BuildContext context) {
    final employeeRegisterVM = ref.watch(employeeRegisterVmProvider.notifier);
    final barberShopAsyncValue = ref.watch(getMyBarbershopProvider);

    ref.listen(
      employeeRegisterVmProvider.select((value) => value.status),
      (_, status) {
        switch (status) {
          case EmployeeRegisterStateStatus.initial:
            break;
          case EmployeeRegisterStateStatus.sucess:
            Messages.showSucess('Colaborador registrado com sucesso', context);
            ref.invalidate(homeAdmVmProvider);
            Navigator.of(context).pop();
          case EmployeeRegisterStateStatus.error:
            Messages.showError('Erro ao registrar colaborador', context);
        }
      },
    );

    return Scaffold(
        appBar: AppBar(
          title: const Text('Cadastrar colaborador'),
        ),
        body: barberShopAsyncValue.when(
          error: (error, stackTrace) {
            log('Erro ao carregar a pagina',
                error: error, stackTrace: stackTrace);
            return const Center(
              child: Text('Erro ao carregar a pagina'),
            );
          },
          loading: () => const BarbershopLoader(),
          data: (barberShopModel) {
            final BarbershopModel(:openingDays, :openingHours) =
                barberShopModel;
            return SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: Center(
                  child: Column(
                    children: [
                      const AvatarWidget(),
                      const SizedBox(
                        height: 32,
                      ),
                      Row(
                        children: [
                          Checkbox.adaptive(
                            value: registerAdm,
                            onChanged: (value) {
                              setState(() {
                                registerAdm = !registerAdm;
                                employeeRegisterVM.setRegisterADM(registerAdm);
                              });
                            },
                          ),
                          const Expanded(
                            child: Text(
                              'Sou administrador e quero me cadastrar como colaborador',
                              style: TextStyle(fontSize: 14),
                            ),
                          )
                        ],
                      ),
                      Offstage(
                        offstage: registerAdm,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 24,
                            ),
                            TextFormField(
                              controller: _nomeEC,
                              validator: registerAdm? null:
                                  Validatorless.required('Nome Obrigatório'),
                              decoration:
                                  const InputDecoration(label: Text('Nome')),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            TextFormField(
                              controller: _emailEC,
                              validator:registerAdm? null: 
                              Validatorless.multiple([
                                Validatorless.required('E-mail obrigatório.'),
                                Validatorless.email('Digite um e-mail valido')
                              ]),
                              decoration:
                                  const InputDecoration(label: Text('E-mail')),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            TextFormField(
                              controller: _passwordEC,
                              obscureText: true,
                              validator:registerAdm? null:
                               Validatorless.multiple([
                                Validatorless.required('Senha obrigatória'),
                                Validatorless.min(6,
                                    'Senha deve conter ao menos 6 caracteres')
                              ]),
                              decoration:
                                  const InputDecoration(label: Text('Senha')),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                          ],
                        ),
                      ),
                      WeekdaysPanel(
                        enableDays: openingDays,
                        onDaySelected: employeeRegisterVM.addOrRemoveWordDays,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      HoursPanel(
                        enableHours: openingHours,
                        starTime: 6,
                        endTime: 23,
                        onHourPressed: employeeRegisterVM.addOrRemoveHours,
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
                                Messages.showError(
                                    'Existem campos inválidos', context);

                              case true:
                                final EmployeeRegisterState(
                                  workdays: List(isNotEmpty: haswordDays),
                                  workHours: List(isNotEmpty: haswordHours)
                                ) = ref.watch(employeeRegisterVmProvider);
                                if (!haswordDays || !haswordHours) {
                                  Messages.showError(
                                      'Por favor selecione os dias e horarios de atendimento.',
                                      context);
                                  return;
                                } else {
                                  employeeRegisterVM.register(
                                      name: _nomeEC.text,
                                      email: _emailEC.text,
                                      password: _passwordEC.text);
                                }
                            }
                          },
                          child: const Text('CADASTRAR COLABORADOR'))
                    ],
                  ),
                ),
              ),
            ));
          },
        ));
  }
}
