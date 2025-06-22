// lib/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// SMS Model Classes
class SMS {
  final int id;
  final int userId;
  final int simId;
  final int? transactionId;
  final String recipientNumber;
  final String senderNumber;
  final String content;
  final String status;
  final String direction;
  final String? errorMessage;
  final DateTime createdAt;
  final DateTime? updatedAt;

  SMS({
    required this.id,
    required this.userId,
    required this.simId,
    this.transactionId,
    required this.recipientNumber,
    required this.senderNumber,
    required this.content,
    required this.status,
    required this.direction,
    this.errorMessage,
    required this.createdAt,
    this.updatedAt,
  });

  factory SMS.fromJson(Map<String, dynamic> json) {
    return SMS(
      id: json['id'],
      userId: json['user_id'],
      simId: json['sim_id'],
      transactionId: json['transaction_id'],
      recipientNumber: json['recipient_number'],
      senderNumber: json['sender_number'],
      content: json['content'],
      status: json['status'],
      direction: json['direction'],
      errorMessage: json['error_message'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }
}

class SIM {
  final int id;
  final String phoneNumber;
  final bool isActive;
  final int messagesUsed;
  final int messagesLimit;

  SIM({
    required this.id,
    required this.phoneNumber,
    required this.isActive,
    required this.messagesUsed,
    required this.messagesLimit,
  });

  factory SIM.fromJson(Map<String, dynamic> json) {
    return SIM(
      id: json['id'],
      phoneNumber: json['phone_number'],
      isActive: json['is_active'],
      messagesUsed: json['messages_used'],
      messagesLimit: json['messages_limit'],
    );
  }
}

class ApiService {
  static const String baseUrl = 'http://192.168.95.143:8000/api';
  final _storage = const FlutterSecureStorage();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storage.read(key: 'token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    return await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(data),
    );
  }

  Future<http.Response> postFormUrlEncoded(
      String endpoint, Map<String, String> data) async {
    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    return await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: Uri(queryParameters: data).query,
    );
  }

  Future<http.Response> get(String endpoint) async {
    final headers = await _getHeaders();
    return await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    );
  }
}

class AuthService {
  final ApiService _api = ApiService();
  final _storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _api.post('/auth/register', {
        'username': username,
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Registration failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Registration error: $e');
    }
  }

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _api.postFormUrlEncoded('/auth/token', {
        'username': username,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _storage.write(key: 'token', value: data['access_token']);
        return data;
      } else {
        throw Exception('Login failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await _api.get('/auth/me/');
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting user: $e');
    }
  }
}

// SMS Service extending the existing pattern
class SMSService {
  final ApiService _api = ApiService();

  // Test MQTT connection
  Future<Map<String, dynamic>> testMqttConnection() async {
    try {
      final response = await _api.get('/sms/test-mqtt');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception('MQTT test failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('MQTT connection error: $e');
    }
  }

  // Get user SIMs
  Future<List<SIM>> getUserSims() async {
    try {
      final response = await _api.get('/sims/');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => SIM.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get SIMs: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting SIMs: $e');
    }
  }

  // Send SMS
  Future<SMS> sendSMS({
    required int simId,
    required String recipientNumber,
    required String content,
  }) async {
    try {
      final response = await _api.post('/sms/send', {
        'sim_id': simId,
        'recipient_number': recipientNumber,
        'content': content,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return SMS.fromJson(data);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['detail'] ?? 'Failed to send SMS');
      }
    } catch (e) {
      throw Exception('SMS sending error: $e');
    }
  }

  // Get SMS history
  Future<List<SMS>> getSMSHistory({
    int skip = 0,
    int limit = 100,
  }) async {
    try {
      final response = await _api.get('/sms/?skip=$skip&limit=$limit');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => SMS.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get SMS history: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting SMS history: $e');
    }
  }

  // Get specific SMS
  Future<SMS> getSMS(int smsId) async {
    try {
      final response = await _api.get('/sms/$smsId');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return SMS.fromJson(data);
      } else {
        throw Exception('SMS not found: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting SMS: $e');
    }
  }
}