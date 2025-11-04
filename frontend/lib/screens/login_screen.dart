import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/token_storage.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ApiService api = ApiService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController(text: 'admin@example.com');
  final TextEditingController passController = TextEditingController(text: '123456');
  bool loading = false;

  void doLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => loading = true);
    final res = await api.login(emailController.text.trim(), passController.text.trim());
    setState(() => loading = false);
    if (res['status'] == 200) {
      final body = jsonDecode(res['body']);
      final token = body['token'];
      await TokenStorage.saveToken(token);
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      final body = res['body'];
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed: ' + body)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 24),
            Text('Bienvenido', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Form(
              key: _formKey,
              child: Column(children: [
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (v) => v == null || v.isEmpty ? 'Ingresa email' : null,
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: passController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Password'),
                  validator: (v) => v == null || v.isEmpty ? 'Ingresa contraseña' : null,
                ),
                SizedBox(height: 20),
                loading ? CircularProgressIndicator() : ElevatedButton(onPressed: doLogin, child: Text('Login')),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
