// ignore_for_file: public_member_api_docs, sort_constructors_first
enum BarbershopRegisterStateStatus {
  initial,
  sucess,
  error
}
class BarbershopRegisterState {
  
  final BarbershopRegisterStateStatus status;
  final List<String> openingDays;
  final List<int> openningHours;

  BarbershopRegisterState.initial():this(status: BarbershopRegisterStateStatus.initial,
  openningHours: <int>[],
  openingDays: <String>[]);

  BarbershopRegisterState({
    required this.status,
    required this.openingDays,
    required this.openningHours,
  });



  BarbershopRegisterState copyWith({
    BarbershopRegisterStateStatus? status,
    List<String>? openingDays,
    List<int>? openningHours,
  }) {
    return BarbershopRegisterState(
      status: status ?? this.status,
      openingDays: openingDays ?? this.openingDays,
      openningHours: openningHours ?? this.openningHours,
    );
  }
}
