import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  ApiService()
      : _dio = Dio(BaseOptions(
          baseUrl: 'https://stuntcerdas.my.id/api/',
          headers: {'Content-Type': 'application/json'},
        )),
        _storage = FlutterSecureStorage();

  Future<void> setHeaders() async {
    String? token = await getToken();
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<Map<String, dynamic>> _handleResponse(Response response) async {
    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception(
            'Error: ${response.data['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      throw Exception('Failed to parse response: $e');
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post('login', data: {
        'email': email,
        'password': password,
      });
      await saveToken(response.data['data']['token']);
      return _handleResponse(response);
    } on DioError catch (e) {
      throw Exception(
          'Gagal login: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      throw Exception('Gagal login: $e');
    }
  }

  Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    try {
      final response = await _dio.post('register', data: {
        'nama': name,
        'email': email,
        'password': password,
      });
      await saveToken(response.data['data']['token']);
      return _handleResponse(response);
    } on DioError catch (e) {
      throw Exception(
          'Gagal registrasi: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      throw Exception('Gagal registrasi: $e');
    }
  }

  Future<void> logout() async {
    try {
      await setHeaders();
      await _dio.get('logout');
      await _storage.delete(key: 'token');
    } on DioError catch (e) {
      throw Exception(
          'Gagal logout: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      throw Exception('Gagal logout: $e');
    }
  }

  Future<Map<String, dynamic>> getUser() async {
    try {
      await setHeaders();
      final response = await _dio.get('user');
      return await _handleResponse(response);
    } on DioError catch (e) {
      throw Exception(
          'Gagal mendapatkan profile: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      throw Exception('Gagal mendapatkan profile: $e');
    }
  }

  Future<Map<String, dynamic>> updateUser(
      String name, String email, String password) async {
    try {
      await setHeaders();
      final response = await _dio.put('user', data: {
        'name': name,
        'email': email,
        'password': password,
      });
      return _handleResponse(response);
    } on DioError catch (e) {
      throw Exception(
          'Gagal update profile: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      throw Exception('Gagal update profile: $e');
    }
  }

  Future<Map<String, dynamic>> getArtikel() async {
    try {
      await setHeaders();
      final response = await _dio.get('artikel');
      return _handleResponse(response);
    } on DioError catch (e) {
      throw Exception(
          'Gagal mendapatkan artikel: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      throw Exception('Gagal mendapatkan artikel: $e');
    }
  }

  Future<Map<String, dynamic>> getArtikelById(int id) async {
    try {
      await setHeaders();
      final response = await _dio.get('artikel/$id');
      return _handleResponse(response);
    } on DioError catch (e) {
      throw Exception(
          'Gagal mendapatkan artikel: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      throw Exception('Gagal mendapatkan artikel: $e');
    }
  }

  Future<Map<String, dynamic>> getChat() async {
    try {
      await setHeaders();
      final response = await _dio.get('chat');
      return _handleResponse(response);
    } on DioError catch (e) {
      throw Exception(
          'Gagal mendapatkan chat: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      throw Exception('Gagal mendapatkan chat: $e');
    }
  }

  Future<Map<String, dynamic>> createChat(String pesan) async {
    try {
      await setHeaders();
      final response = await _dio.post('chat', data: {
        'pesan': pesan,
      });

      return _handleResponse(response);
    } on DioError catch (e) {
      throw Exception(
          'Gagal membuat chat: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      throw Exception('Gagal membuat chat: $e');
    }
  }

    Future<Map<String, dynamic>> getKalkulatorFuzzy() async {
      try {
        await setHeaders();
        final response = await _dio.get('kalkulator-fuzzy');
        return _handleResponse(response);
      } on DioError catch (e) {
        throw Exception(
            'Gagal mendapatkan kalkulator fuzzy: ${e.response?.data['message'] ?? e.message}');
      } catch (e) {
        throw Exception('Gagal mendapatkan kalkulator fuzzy: $e');
      }
    }

  Future<Map<String, dynamic>> getKalkulatorFuzzyById(int id) async {
    try {
      await setHeaders();
      final response = await _dio.get('kalkulator-fuzzy/$id');
      return _handleResponse(response);
    } on DioError catch (e) {
      throw Exception(
          'Gagal mendapatkan kalkulator fuzzy: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      throw Exception('Gagal mendapatkan kalkulator fuzzy: $e');
    }
  }

  Future<Map<String, dynamic>> createKalkulatorFuzzy(
      String namaBayi,
      String jenisKelamin,
      int usia,
      double beratBadan,
      double tinggiBadan) async {
    try {
      await setHeaders();

      final data = {
        'nama_bayi': namaBayi,
        'jenis_kelamin': jenisKelamin,
        'usia': usia,
        'berat_badan': beratBadan,
        'tinggi_badan': tinggiBadan,
      };

      final response = await _dio.post('kalkulator-fuzzy', data: data);
      return _handleResponse(response);
    } on DioError catch (e) {
      throw Exception(
          'Gagal membuat kalkulator fuzzy: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      throw Exception('Gagal membuat kalkulator fuzzy: $e');
    }
  }
}
