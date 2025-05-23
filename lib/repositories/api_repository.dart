import 'package:dio/dio.dart';
import '../models/member.dart';
import '../models/gym_session.dart';

class ApiRepository {
  final Dio _dio;
  final String baseUrl = 'http://localhost:8000/api';

  ApiRepository() : _dio = Dio() {
    _dio.options.baseUrl = baseUrl;
  }

  // Member API methods
  Future<List<Member>> getMembers() async {
    try {
      final response = await _dio.get('/members/');
      return (response.data as List)
          .map((json) => Member.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load members: $e');
    }
  }

  Future<Member> getMember(String phoneNumber) async {
    try {
      final response = await _dio.get('/members/$phoneNumber/');
      return Member.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load member: $e');
    }
  }
}
