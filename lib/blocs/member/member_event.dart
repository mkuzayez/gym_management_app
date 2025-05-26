import 'package:equatable/equatable.dart';
import 'package:gym_management_app/models/member.dart';

abstract class MemberEvent extends Equatable {
  const MemberEvent();

  @override
  List<Object> get props => [];
}

class LoadMembers extends MemberEvent {}

class AddMember extends MemberEvent {
  final String phoneNumber;
  final String password;
  final String name;
  final String email;

  const AddMember({
    required this.phoneNumber,
    required this.password,
    required this.name,
    required this.email,
  });

  @override
  List<Object> get props => [phoneNumber, password, name, email];
}

class UpdateMember extends MemberEvent {
  final int id;
  final String? phoneNumber;
  final String? name;
  final String? email;
  final bool? isInGym;

  const UpdateMember({
    required this.id,
    this.phoneNumber,
    this.name,
    this.email,
    this.isInGym,
  });

  @override
  List<Object?> get props => [id, phoneNumber, name, email, isInGym];
}

class DeleteMember extends MemberEvent {
  final int id;

  const DeleteMember({required this.id});

  @override
  List<Object> get props => [id];
}

class RecordMemberEntry extends MemberEvent {
  final int id;

  const RecordMemberEntry({required this.id});

  @override
  List<Object> get props => [id];
}

class RecordMemberExit extends MemberEvent {
  final int id;

  const RecordMemberExit({required this.id});

  @override
  List<Object> get props => [id];
}