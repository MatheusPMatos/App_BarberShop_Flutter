import 'package:dw_barbershop/src/core/ui/helpers/form_helper.dart';
import 'package:dw_barbershop/src/core/ui/helpers/messages.dart';
import 'package:dw_barbershop/src/core/ui/icons/barberchop_icons.dart';
import 'package:dw_barbershop/src/core/ui/widgets/avatar_widget.dart';
import 'package:dw_barbershop/src/core/ui/widgets/constants.dart';
import 'package:dw_barbershop/src/core/ui/widgets/hours_panel.dart';
import 'package:dw_barbershop/src/features/schedules/schedule_state.dart';
import 'package:dw_barbershop/src/features/schedules/schedule_vm.dart';
import 'package:dw_barbershop/src/features/schedules/widgets/schedule_calendar.dart';
import 'package:dw_barbershop/src/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:validatorless/validatorless.dart';

class SchedulePage extends ConsumerStatefulWidget  {
  const SchedulePage({super.key});

  @override
  ConsumerState<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends ConsumerState<SchedulePage> {

  var dateFormat = DateFormat('dd/MM/yyyy');
  var showCalendar = false;

  final _formKey = GlobalKey<FormState>();
  final _nomeClienteEC = TextEditingController();
  final _dateEC = TextEditingController();

  @override
  void dispose() {
    _nomeClienteEC.dispose();
    _dateEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final userModel = ModalRoute.of(context)!.settings.arguments as UserModel;
    final scheduleVm = ref.watch(scheduleVmProvider.notifier);

    final employeeData = switch(userModel){
      UserModelAdm(: final workdays, :final workHours) => (
        workdays: workdays!,
        workHours: workHours
      ),
      UserModelEmploye(: final workdays, : final workHours)=>(
        workdays: workdays,
        workHours: workHours
      ),
    };

    ref.listen(scheduleVmProvider.select((value) => value.status), (_, status) { 
      switch(status){
        case ScheduleStateStatus.initial:
        break;
        case ScheduleStateStatus.success:
          Messages.showSucess('Cliente agendado com sucesso.', context);
          Navigator.of(context).pop();
        case ScheduleStateStatus.error:
          Messages.showError('Erro ao registrar agendamento', context);

      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendar Cliente'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const AvatarWidget(
                    hideUploadedButton: true,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                   Text(
                    userModel.name,
                    style:const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 37,
                  ),
                  TextFormField(
                    controller: _nomeClienteEC,
                    validator: Validatorless.required('Cliente Obrigatório'),
                    decoration: const InputDecoration(
                      label: Text('Cliente'),
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  TextFormField(
                    controller: _dateEC,
                    validator: Validatorless.required('Selecione a data do agendamento.'),
                    readOnly: true,
                    onTap: () {
                      setState(() {
                        showCalendar = true;
                      });
                      context.unfocus();
                    },
                    decoration: const InputDecoration(
                      label: Text('Selecione uma data'),
                      hintText: 'Selecione uma data',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      
                      suffixIcon: Icon(
                        BarbershopIcons.calendar,
                        color: ColorsConstants.brow,
                      ),
                    ),
                  ),
                  Offstage(
                    offstage: !showCalendar,
                    child: Column(
                      children: [
                        const SizedBox(
                           height: 24,
                        ),
                       ScheduleCalendar(
                        wordDays: employeeData.workdays,
                        cancelPressed: () {
                          setState(() {
                            showCalendar = false;
                          });
                        },
                        okPressed: (value) {
                          setState(() {
                            _dateEC.text = dateFormat.format(value);
                            scheduleVm.dataSelect(value);
                            showCalendar = false;
                          });
                        },),
                      ],
                    ),
                  ),
                  
                  const SizedBox(
                     height: 24,
                  ),
                  HoursPanel.singleSelection(
                    enableHours: employeeData.workHours,
                    starTime: 6, endTime: 23, onHourPressed: scheduleVm.hourSelect,),
                  const SizedBox(
                     height: 24,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(56)
                    ),
                    onPressed: () {
                    switch(_formKey.currentState?.validate()){
                      case null || false:
                       Messages.showError('Dados incompletos', context);
                      case true:
                      final hourSelected = ref.watch(scheduleVmProvider.select((value) => value.scheduleHour != null));
                        if(hourSelected){
                          scheduleVm.register(userModel: userModel, clientName: _nomeClienteEC.text);
                        }else{
                          Messages.showError('Por favor Selecione o horario de atendimento.', context);
                        }


                    }
                  }, child:const Text('AGENDAR'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
