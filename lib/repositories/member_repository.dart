import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gym_management_app/models/member.dart';
import 'package:gym_management_app/repositories/auth_repository.dart';

class MemberRepository {
  static const String _baseUrl = 'http://127.0.0.1:8000/api'; // TODO: Replace with actual backend URL
  final AuthRepository authRepository;

  MemberRepository({required this.authRepository});

  Future<Map<String, String>> _getAuthHeaders() async {
    final accessToken = await authRepository.getAccessToken();
    if (accessToken == null) {
      throw Exception('Not authenticated. Please log in.');
    }
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
  }

  Future<List<Member>> getMembers() async {
    final headers = await _getAuthHeaders();
    final response = await http.get(
      Uri.parse('$_baseUrl/members/'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> memberJson = json.decode(response.body);
      return memberJson.map((json) => Member.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      await authRepository.refreshToken();
      return getMembers(); // Retry after refreshing token
    } else {
      throw Exception('Failed to load members: ${response.statusCode} ${response.body}');
    }
  }

  Future<Member> getMemberById(int id) async {
    final headers = await _getAuthHeaders();
    final response = await http.get(
      Uri.parse('$_baseUrl/members/$id/'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return Member.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      await authRepository.refreshToken();
      return getMemberById(id); // Retry after refreshing token
    } else {
      throw Exception('Failed to load member: ${response.statusCode} ${response.body}');
    }
  }

  Future<Member> createMember({
    required String phoneNumber,
    required String password,
    required String name,
    required String email,
  }) async {
    final headers = await _getAuthHeaders();
    final response = await http.post(
      Uri.parse('$_baseUrl/members/'),
      headers: headers,
      body: json.encode({
        'phone_number': phoneNumber,
        'password': password,
        'name': name,
        'email': email,
      }),
    );

    if (response.statusCode == 201) {
      return Member.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      await authRepository.refreshToken();
      return createMember(phoneNumber: phoneNumber, password: password, name: name, email: email); // Retry
    } else {
      throw Exception('Failed to create member: ${response.statusCode} ${response.body}');
    }
  }

  Future<Member> updateMember(int id, {
    String? phoneNumber,
    String? name,
    String? email,
    bool? isInGym,
  }) async {
    final headers = await _getAuthHeaders();
    final Map<String, dynamic> body = {};
    if (phoneNumber != null) body['phone_number'] = phoneNumber;
    if (name != null) body['name'] = name;
    if (email != null) body['email'] = email;
    if (isInGym != null) body['is_in_gym'] = isInGym;

    final response = await http.patch( // Use patch for partial updates
      Uri.parse('$_baseUrl/members/$id/'),
      headers: headers,
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      return Member.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      await authRepository.refreshToken();
      return updateMember(id, phoneNumber: phoneNumber, name: name, email: email, isInGym: isInGym); // Retry
    } else {
      throw Exception('Failed to update member: ${response.statusCode} ${response.body}');
    }
  }

  Future<void> deleteMember(int id) async {
    final headers = await _getAuthHeaders();
    final response = await http.delete(
      Uri.parse('$_baseUrl/members/$id/'),
      headers: headers,
    );

    if (response.statusCode == 204) {
      return; // No content
    } else if (response.statusCode == 401) {
      await authRepository.refreshToken();
      return deleteMember(id); // Retry
    } else {
      throw Exception('Failed to delete member: ${response.statusCode} ${response.body}');
    }
  }

  Future<void> recordMemberEntry(int id) async {
    final headers = await _getAuthHeaders();
    final response = await http.post(
      Uri.parse('$_baseUrl/members/$id/enter/'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 401) {
      await authRepository.refreshToken();
      return recordMemberEntry(id); // Retry
    } else {
      throw Exception('Failed to record member entry: ${response.statusCode} ${response.body}');
    }
  }

  Future<void> recordMemberExit(int id) async {
    final headers = await _getAuthHeaders();
    final response = await http.post(
      Uri.parse('$_baseUrl/members/$id/exit/'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 401) {
      await authRepository.refreshToken();
      return recordMemberExit(id); // Retry
    } else {
      throw Exception('Failed to record member exit: ${response.statusCode} ${response.body}');
    }
  }
}