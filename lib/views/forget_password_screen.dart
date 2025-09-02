import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _newPasswordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  bool _obscureNew = true;
  String? _resetToken;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Retrieve the token passed via Navigator
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String) {
      _resetToken = args;
    }
  }

  void _setLoading(bool value) {
    setState(() => _isLoading = value);
  }

  void _setError(String? message) {
    setState(() => _errorMessage = message);
  }

  Future<bool> forgotPassword({
    required String email,
    required String newPassword,
    required String resetToken,
  }) async {
    _setLoading(true);
    _setError(null);

    final url = Uri.parse('https://your-api.com/forgot-password');
    final body = {
      'email': email,
      'newPassword': newPassword,
      'resetToken': resetToken, // Include token in request
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      _setLoading(false);

      if (response.statusCode == 200) {
        return true;
      } else {
        _setError('Failed to reset password: ${response.body}');
        return false;
      }
    } catch (e) {
      _setLoading(false);
      _setError('Error: $e');
      return false;
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final newPassword = _newPasswordController.text;

    if (_resetToken == null) {
      _setError('Missing reset token');
      return;
    }

    final success = await forgotPassword(
      email: email,
      newPassword: newPassword,
      resetToken: _resetToken!,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset successful')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage ?? 'Unknown error')),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
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
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                value != null && value.contains('@') ? null : 'Enter a valid email',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _newPasswordController,
                obscureText: _obscureNew,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureNew ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _obscureNew = !_obscureNew),
                  ),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) =>
                value != null && value.length >= 6 ? null : 'Password must be at least 6 characters',
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset Password'),
                  onPressed: _handleSubmit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

