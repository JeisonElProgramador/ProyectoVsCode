import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/token_storage.dart';

class ApiService {
  final String baseUrl;
  ApiService({this.baseUrl = 'http://10.0.2.2:3000'});

  Future<Map<String, dynamic>> login(String email, String password) async {
    final resp = await http.post(Uri.parse('\$baseUrl/api/auth/login'), 
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    return {'status': resp.statusCode, 'body': resp.body};
  }

  Future<http.Response> getProtected(String path) async {
    final token = await TokenStorage.readToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer \$token',
    };
    final resp = await http.get(Uri.parse('\$baseUrl\$path'), headers: headers);
    return resp;
  }
}
