import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/blocs/member/member_event.dart';
import 'package:gym_management_app/blocs/member/member_state.dart';
import 'package:gym_management_app/repositories/member_repository.dart';

class MemberBloc extends Bloc<MemberEvent, MemberState> {
  final MemberRepository memberRepository;

  MemberBloc({required this.memberRepository}) : super(MemberInitial()) {
    on<LoadMembers>(_onLoadMembers);
    on<AddMember>(_onAddMember);
    on<UpdateMember>(_onUpdateMember);
    on<DeleteMember>(_onDeleteMember);
    on<RecordMemberEntry>(_onRecordMemberEntry);
    on<RecordMemberExit>(_onRecordMemberExit);
  }

  Future<void> _onLoadMembers(LoadMembers event, Emitter<MemberState> emit) async {
    emit(MemberLoading());
    try {
      final members = await memberRepository.getMembers();
      emit(MembersLoaded(members: members));
    } catch (e) {
      emit(MemberError(e.toString()));
    }
  }

  Future<void> _onAddMember(AddMember event, Emitter<MemberState> emit) async {
    emit(MemberLoading()); // Or a more specific state like MemberAdding
    try {
      await memberRepository.createMember(
        phoneNumber: event.phoneNumber,
        password: event.password,
        name: event.name,
        email: event.email,
      );
      emit(const MemberOperationSuccess('Member added successfully!'));
      add(LoadMembers()); // Reload members after adding
    } catch (e) {
      emit(MemberError(e.toString()));
    }
  }

  Future<void> _onUpdateMember(UpdateMember event, Emitter<MemberState> emit) async {
    emit(MemberLoading()); // Or a more specific state like MemberUpdating
    try {
      await memberRepository.updateMember(
        event.id,
        phoneNumber: event.phoneNumber,
        name: event.name,
        email: event.email,
        isInGym: event.isInGym,
      );
      emit(const MemberOperationSuccess('Member updated successfully!'));
      add(LoadMembers()); // Reload members after updating
    } catch (e) {
      emit(MemberError(e.toString()));
    }
  }

  Future<void> _onDeleteMember(DeleteMember event, Emitter<MemberState> emit) async {
    emit(MemberLoading()); // Or a more specific state like MemberDeleting
    try {
      await memberRepository.deleteMember(event.id);
      emit(const MemberOperationSuccess('Member deleted successfully!'));
      add(LoadMembers()); // Reload members after deleting
    } catch (e) {
      emit(MemberError(e.toString()));
    }
  }

  Future<void> _onRecordMemberEntry(RecordMemberEntry event, Emitter<MemberState> emit) async {
    emit(MemberLoading());
    try {
      await memberRepository.recordMemberEntry(event.id);
      emit(const MemberOperationSuccess('Member entered gym!'));
      add(LoadMembers()); // Reload to update status
    } catch (e) {
      emit(MemberError(e.toString()));
    }
  }

  Future<void> _onRecordMemberExit(RecordMemberExit event, Emitter<MemberState> emit) async {
    emit(MemberLoading());
    try {
      await memberRepository.recordMemberExit(event.id);
      emit(const MemberOperationSuccess('Member exited gym!'));
      add(LoadMembers()); // Reload to update status
    } catch (e) {
      emit(MemberError(e.toString()));
    }
  }
}