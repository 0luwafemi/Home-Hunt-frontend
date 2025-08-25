import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ResendTokenScreen extends StatefulWidget {
  const ResendTokenScreen({super.key});

  @override
  State<ResendTokenScreen> createState() => _ResendTokenScreenState();
}

class _ResendTokenScreenState extends State<ResendTokenScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tokenController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  String? _responseMessage;

  void _setLoading(bool value) {
    setState(() => _isLoading = value);
  }

  void _setError(String? message) {
    setState(() => _errorMessage = message);
  }

  Future<String?> resendToken(String resendToken) async {
    _setLoading(true);
    _setError(null);

    final url = Uri.parse('https://your-api.com/resend-token');
    final body = jsonEncode({'resendToken': resendToken});

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      _setLoading(false);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        _setError('Failed to resend token: ${response.body}');
        return null;
      }
    } catch (e) {
      _setLoading(false);
      _setError('Error: $e');
      return null;
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final token = _tokenController.text.trim();
    final result = await resendToken(token);

    if (!mounted) return;

    if (result != null) {
      setState(() => _responseMessage = result);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Token resent successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage ?? 'Unknown error')),
      );
    }
  }

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resend Token')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              TextFormField(
                controller: _tokenController,
                decoration: const InputDecoration(
                  labelText: 'Resend Token',
                  prefixIcon: Icon(Icons.vpn_key),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value != null && value.isNotEmpty ? null : 'Token is required',
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton.icon(
                  icon: const Icon(Icons.send),
                  label: const Text('Resend Token'),
                  onPressed: _handleSubmit,
                ),
              ),
              if (_responseMessage != null) ...[
                const SizedBox(height: 24),
                Text(
                  'Server Response: $_responseMessage',
                  style: const TextStyle(color: Colors.green),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
