// lib/services/auth_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://localhost:5000/api';

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(res.body);
    if (res.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      await prefs.setString('userName', data['user']['name']);
      await prefs.setString('userLocation', data['user']['location'] ?? '');
      await prefs.setString('userId', data['user']['id']);
      return data;
    }
    throw Exception(data['message'] ?? 'Login failed');
  }

  static Future<Map<String, dynamic>> register(
      String name, String email, String password, String location) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'location': location,
      }),
    );

    final data = jsonDecode(res.body);
    if (res.statusCode == 201) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      await prefs.setString('userName', data['user']['name']);
      await prefs.setString('userLocation', data['user']['location'] ?? '');
      await prefs.setString('userId', data['user']['id']);
      return data;
    }
    throw Exception(data['message'] ?? 'Registration failed');
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') != null;
  }

  static Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName') ?? 'You';
  }

  static Future<String> getUserLocation() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userLocation') ?? '';
  }
}