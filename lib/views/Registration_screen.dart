import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_dto.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _address = TextEditingController();
  final _phoneNumber = TextEditingController();
  final _email = TextEditingController();
  final _gender = TextEditingController();
  final _country = TextEditingController();
  final _language = TextEditingController();
  final _password = TextEditingController();

  Role _role = Role.BUYER;
  bool _loading = false;
  bool _hidePassword = true;
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _address.dispose();
    _phoneNumber.dispose();
    _email.dispose();
    _gender.dispose();
    _country.dispose();
    _language.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate() || !_acceptedTerms) return;

    setState(() => _loading = true);

    final user = UserDTO(
      firstName: _firstName.text.trim(),
      lastName: _lastName.text.trim(),
      address: _address.text.trim(),
      phoneNumber: _phoneNumber.text.trim(),
      email: _email.text.trim(),
      gender: _gender.text.trim(),
      country: _country.text.trim(),
      language: _language.text.trim(),
      password: _password.text,
      role: _role,
      localDate: DateTime.now().toIso8601String(),
    );

    try {
      await Provider.of<AuthProvider>(context, listen: false).register(user);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Registered successfully!')),
      );
      Navigator.of(context).pushReplacement(_slideTo(const LoginScreen()));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Registration failed.')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Route _slideTo(Widget page) => PageRouteBuilder(
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, animation, __, child) {
      final offset = Tween(begin: const Offset(1, 0), end: Offset.zero)
          .chain(CurveTween(curve: Curves.ease));
      return SlideTransition(position: animation.drive(offset), child: child);
    },
  );

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        validator: (v) => v != null && v.trim().isNotEmpty ? null : 'Required',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 600;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('Register')),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isWide ? 500 : screenWidth),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Personal Information', style: theme.textTheme.titleMedium),
                      _buildTextField(_firstName, 'First Name'),
                      _buildTextField(_lastName, 'Last Name'),
                      _buildTextField(_gender, 'Gender'),
                      _buildTextField(_country, 'Country'),
                      _buildTextField(_language, 'Language'),

                      const SizedBox(height: 16),
                      Text('Contact Details', style: theme.textTheme.titleMedium),
                      _buildTextField(_address, 'Address'),
                      _buildTextField(_phoneNumber, 'Phone Number', keyboardType: TextInputType.phone),
                      _buildTextField(_email, 'Email', keyboardType: TextInputType.emailAddress),

                      const SizedBox(height: 16),
                      Text('Account Setup', style: theme.textTheme.titleMedium),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: DropdownButtonFormField<Role>(
                          value: _role,
                          decoration: const InputDecoration(
                            labelText: 'Role',
                            border: OutlineInputBorder(),
                          ),
                          items: Role.values
                              .map((r) => DropdownMenuItem(value: r, child: Text(r.name)))
                              .toList(),
                          onChanged: (r) => setState(() => _role = r!),
                          validator: (v) => v == null ? 'Select role' : null,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: TextFormField(
                          controller: _password,
                          obscureText: _hidePassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(_hidePassword ? Icons.visibility : Icons.visibility_off),
                              onPressed: () => setState(() => _hidePassword = !_hidePassword),
                            ),
                          ),
                          validator: (v) => v != null && v.length >= 6 ? null : 'Min 6 characters',
                        ),
                      ),
                      CheckboxListTile(
                        value: _acceptedTerms,
                        onChanged: (v) => setState(() => _acceptedTerms = v ?? false),
                        title: const Text('I agree to the Terms & Conditions'),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),

                      const SizedBox(height: 24),
                      _loading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton.icon(
                        icon: const Icon(Icons.person_add),
                        label: const Text('Register'),
                        onPressed: _acceptedTerms ? _register : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton.icon(
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Back to Login'),
                        onPressed: () => Navigator.of(context).push(_slideTo(const LoginScreen())),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
