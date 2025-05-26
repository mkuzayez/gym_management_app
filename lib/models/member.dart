import 'package:equatable/equatable.dart';

class Member extends Equatable {
  final int id;
  final String phoneNumber;
  final String name;
  final String email;
  final bool isInGym;
  final DateTime dateJoined;

  const Member({
    required this.id,
    required this.phoneNumber,
    required this.name,
    required this.email,
    required this.isInGym,
    required this.dateJoined,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'],
      phoneNumber: json['phone_number'],
      name: json['name'],
      email: json['email'],
      isInGym: json['is_in_gym'],
      dateJoined: DateTime.parse(json['date_joined']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone_number': phoneNumber,
      'name': name,
      'email': email,
      'is_in_gym': isInGym,
      'date_joined': dateJoined.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, phoneNumber, name, email, isInGym, dateJoined];
}