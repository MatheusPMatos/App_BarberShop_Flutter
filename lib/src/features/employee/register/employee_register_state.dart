// ignore_for_file: public_member_api_docs, sort_constructors_first
enum  EmployeeRegisterStateStatus {
  initial,
  sucess,
  error
}


class EmployeeRegisterState {
  final EmployeeRegisterStateStatus status;
  final bool registerAdm;
  final List<String> workdays;
  final List<int> workHours;

  EmployeeRegisterState.initial():this(
    status: EmployeeRegisterStateStatus.initial,
    registerAdm: false,
    workdays: <String>[],
    workHours: <int>[]

  );

  EmployeeRegisterState({
    required this.status,
    required this.registerAdm,
    required this.workdays,
    required this.workHours,
  });
 

  EmployeeRegisterState copyWith({
    EmployeeRegisterStateStatus? status,
    bool? registerAdm,
    List<String>? workdays,
    List<int>? workHours,
  }) {
    return EmployeeRegisterState(
      status: status ?? this.status,
      registerAdm: registerAdm ?? this.registerAdm,
      workdays: workdays ?? this.workdays,
      workHours: workHours ?? this.workHours,
    );
  }
}
