import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

sealed class UserModel {
  
final int id;
final String name;
final String email;
final String? avatar;
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
  });

  factory UserModel.fromMap(Map<String, dynamic> json){
    return switch(json['profile']){
      'ADM'=> UserModelAdm.fromMap(json),
      'EMPLOYEE'=> UserModelEmploye.fromMap(json),
      _ =>throw ArgumentError('User profile not found')
    };
  }

}

class UserModelAdm extends UserModel {
  final List<String>? workdays;
  final List<int>? workHours;

  UserModelAdm({
    this.workdays, 
    this.workHours, 
    required super.id, 
    required super.name, 
    required super.email,
    super.avatar
    });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'workdays': workdays,
      'workHours': workHours,
      'id': id,
      'name':name,
      'email': email,
      'work_days':  workdays?? '',
      'work_hours': workHours ?? '',
      'avatar': avatar?? ''
    };
  }

  factory UserModelAdm.fromMap(Map<String, dynamic> map) {
    return switch(map){
      {
        'id':final  int id,
        'name':final String name,
        'email':final String email,
      }=> 
        UserModelAdm(
          workdays: map['work_days']?.cast<String>(), 
          workHours: map['work_hours']?.cast<int>(),
          avatar: map['avatar'], 
          id: id, 
          name: name, 
          email: email),
          _=> throw ArgumentError('Invalid Json')
    };


    
  }

  String toJson() => json.encode(toMap());

  factory UserModelAdm.fromJson(String source) => UserModelAdm.fromMap(json.decode(source) as Map<String, dynamic>);
}

class UserModelEmploye extends UserModel {
  final int barbershopId;
  final List<String> workdays;
  final List<int> workHours;

  UserModelEmploye({
    required this.workdays, 
    required this.workHours, 
    required this.barbershopId, 
    required super.id, 
    required super.name, 
    required super.email,
    super.avatar
    });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
       'workdays': workdays,
      'workHours': workHours,
      'id': id,
      'name':name,
      'email': email,
      'work_days':  workdays,
      'work_hours': workHours,
      'avatar': avatar?? ''
    };
  }

  factory UserModelEmploye.fromMap(Map<String, dynamic> map) {
   return  switch(map){
      {
        'id':final  int id,
        'name':final String name,
        'email':final String email,
        'barbershop_id': final int barbershopId,
        'work_days': final List workdays,
        'work_hours': final List workHours,

      }=> 
        UserModelEmploye(
          workdays: workdays.cast<String>(), 
          workHours: workHours.cast<int>(),
          avatar: map['avatar'],
          barbershopId: barbershopId,
          id: id, 
          name: name, 
          email: email),
          _=> throw ArgumentError('Invalid Json')

      };
    
  }

  String toJson() => json.encode(toMap());

  factory UserModelEmploye.fromJson(String source) => UserModelEmploye.fromMap(json.decode(source) as Map<String, dynamic>);
}
