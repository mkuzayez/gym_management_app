import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  static const String _baseUrl = 'http://127.0.0.1:8000/api'; // TODO: Replace with actual backend URL
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  Future<void> register({
    required String phoneNumber,
    required String password,
    required String name,
    required String email,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'phone_number': phoneNumber,
        'password': password,
        'name': name,
        'email': email,
      }),
    );

    if (response.statusCode == 201) {
      // Registration successful, no token returned for register
      print('Registration successful');
    } else {
      final error = json.decode(response.body);
      throw Exception(error['detail'] ?? 'Failed to register');
    }
  }

  Future<void> login({
    required String phoneNumber,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'phone_number': phoneNumber,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      await _saveTokens(data['access'], data['refresh']);
    } else {
      final error = json.decode(response.body);
      throw Exception(error['detail'] ?? 'Failed to login');
    }
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
  }

  Future<void> deleteTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
  }

  Future<bool> isAuthenticated() async {
    final accessToken = await getAccessToken();
    return accessToken != null;
  }

  Future<void> refreshToken() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) {
      throw Exception('No refresh token available');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/token/refresh/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'refresh': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      await _saveTokens(data['access'], refreshToken); // Keep the same refresh token
    } else {
      await deleteTokens(); // Clear tokens if refresh fails
      throw Exception('Failed to refresh token');
    }
  }
}