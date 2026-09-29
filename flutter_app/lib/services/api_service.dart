import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException(this.statusCode, this.message);
  @override
  String toString() => message;
}

class ApiService {
  String get baseUrl {
    if (kIsWeb) return 'http://localhost:8000';
    // Android emulator maps the host machine to 10.0.2.2.
    return 'http://10.0.2.2:8000';
  }

  Future<Map<String, dynamic>> _request(
    String method,
    String path, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    final uri = Uri.parse('$baseUrl$path');
    late http.Response response;
    if (method == 'GET') {
      response = await http.get(uri, headers: headers);
    } else {
      response = await http.post(uri, headers: headers, body: jsonEncode(body ?? {}));
    }
    dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      decoded = {'detail': response.body};
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final detail = decoded is Map ? decoded['detail'] : null;
      throw ApiException(response.statusCode, detail?.toString() ?? 'Error de conexión');
    }
    return Map<String, dynamic>.from(decoded as Map);
  }

  Future<Map<String, dynamic>> login(String email, String password) =>
      _request('POST', '/api/v1/auth/login', body: {'email': email, 'password': password});

  Future<Map<String, dynamic>> register(String email, String password, String nombre) =>
      _request('POST', '/api/v1/auth/register', body: {
        'email': email,
        'password': password,
        'nombre': nombre,
        'tipo_usuario': 'gratis',
      });

  Future<Map<String, dynamic>> stats(String token) =>
      _request('GET', '/api/v1/tracking/stats', token: token);

  Future<Map<String, dynamic>> generateWorkout(String token, Map<String, dynamic> body) =>
      _request('POST', '/api/v1/workouts/generate', body: body, token: token);

  Future<Map<String, dynamic>> askCoach(String token, String question) =>
      _request('POST', '/api/v1/ai/coach', body: {'pregunta': question}, token: token);

  Future<Map<String, dynamic>> checkIn(String token, Map<String, dynamic> body) =>
      _request('POST', '/api/v1/bioregulation/check-in', body: body, token: token);

  Future<Map<String, dynamic>> sessions(String token) =>
      _request('GET', '/api/v1/tracking/sessions', token: token);
}

class AuthProvider extends ChangeNotifier {
  final ApiService api;
  AuthProvider(this.api);

  String? token;
  Map<String, dynamic>? user;
  bool loading = true;
  String? error;

  bool get isLoggedIn => token != null && token!.isNotEmpty;

  Future<void> restore() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('jwt_token');
    final userJson = prefs.getString('user');
    if (userJson != null) user = Map<String, dynamic>.from(jsonDecode(userJson));
    loading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    loading = true; error = null; notifyListeners();
    try {
      final data = await api.login(email.trim(), password);
      token = data['access_token'] as String;
      user = data['user'] == null ? null : Map<String, dynamic>.from(data['user']);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token!);
      if (user != null) await prefs.setString('user', jsonEncode(user));
      return true;
    } catch (e) { error = e.toString(); return false; }
    finally { loading = false; notifyListeners(); }
  }

  Future<bool> register(String email, String password, String nombre) async {
    loading = true; error = null; notifyListeners();
    try { await api.register(email.trim(), password, nombre.trim()); return true; }
    catch (e) { error = e.toString(); return false; }
    finally { loading = false; notifyListeners(); }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    await prefs.remove('user');
    token = null; user = null; notifyListeners();
  }
}
