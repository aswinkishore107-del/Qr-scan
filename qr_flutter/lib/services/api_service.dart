// lib/services/api_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // ─── IMPORTANT: Change this IP based on your setup ───────────
  // Android Emulator  → use 10.0.2.2
  // Real Android Device → use your PC's local IP
  // Current WiFi IP: 10.253.189.247
  static const String _baseUrl = 'http://10.253.189.247:3000';

  /// POST /scan — Send scanned QR text to the backend
  static Future<Map<String, dynamic>> storeScan(String text) async {
    debugPrint('╔══════════════════════════════════════════');
    debugPrint('║ API CALL: POST $_baseUrl/scan');
    debugPrint('║ Body: {"text": "$text"}');
    debugPrint('╚══════════════════════════════════════════');

    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/scan'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'text': text}),
          )
          .timeout(const Duration(seconds: 15));

      debugPrint('✅ Response status: ${response.statusCode}');
      debugPrint('✅ Response body: ${response.body}');

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 201) {
        return {'success': true, 'data': data};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Server error (${response.statusCode})',
        };
      }
    } on SocketException catch (e) {
      debugPrint('❌ SocketException: $e');
      return {
        'success': false,
        'message': 'Cannot reach server. Check WiFi & IP.\n($e)',
      };
    } on HttpException catch (e) {
      debugPrint('❌ HttpException: $e');
      return {
        'success': false,
        'message': 'HTTP error: $e',
      };
    } on FormatException catch (e) {
      debugPrint('❌ FormatException: $e');
      return {
        'success': false,
        'message': 'Invalid response from server: $e',
      };
    } on Exception catch (e) {
      debugPrint('❌ Exception: $e');
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }

  /// GET /scans — Fetch all stored scans from the backend
  static Future<Map<String, dynamic>> getScans() async {
    debugPrint('📡 API CALL: GET $_baseUrl/scans');

    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/scans'))
          .timeout(const Duration(seconds: 15));

      debugPrint('✅ GET Response: ${response.statusCode}');

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return {'success': true, 'data': data['data']};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to fetch scans.',
        };
      }
    } on SocketException catch (e) {
      debugPrint('❌ GET SocketException: $e');
      return {
        'success': false,
        'message': 'Cannot reach server: $e',
      };
    } on Exception catch (e) {
      debugPrint('❌ GET Exception: $e');
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }
}