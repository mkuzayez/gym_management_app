import 'package:flutter/material.dart';
import '../models/member.dart';
import '../repositories/api_repository.dart';

class MemberController {
  final ApiRepository _repository;

  MemberController() : _repository = ApiRepository();

  Future<List<Member>> getMembers() async {
    return await _repository.getMembers();
  }

  Future<Member> getMember(String phoneNumber) async {
    return await _repository.getMember(phoneNumber);
  }
}
