import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/token_storage.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService api = ApiService();
  String message = '';
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadProtected();
  }

  void loadProtected() async {
    setState(() => loading = true);
    final resp = await api.getProtected('/api/products/');
    setState(() => loading = false);
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      setState(() => message = 'Productos cargados: ' + (data.length).toString());
    } else if (resp.statusCode == 401) {
      // token inválido o expirado
      await TokenStorage.deleteToken();
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      setState(() => message = 'Error: ' + resp.statusCode.toString());
    }
  }

  void logout() async {
    await TokenStorage.deleteToken();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home'), actions: [IconButton(onPressed: logout, icon: Icon(Icons.logout))]),
      body: Center(
        child: loading ? CircularProgressIndicator() : Text(message),
      ),
    );
  }
}
