import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/feedback_request.dart';
import '../providers/feedback_provider.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _propertyIdController = TextEditingController();
  final _userIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  int _rating = 0;

  @override
  void dispose() {
    _propertyIdController.dispose();
    _userIdController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _propertyIdController.clear();
    _userIdController.clear();
    _emailController.clear();
    _messageController.clear();
    setState(() => _rating = 0);
  }

  Future<void> _submitFeedback(BuildContext context) async {
    if (!_formKey.currentState!.validate() || _rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fill all fields and select a rating')),
      );
      return;
    }

    final propertyId = int.tryParse(_propertyIdController.text.trim());
    final userId = int.tryParse(_userIdController.text.trim());

    if (propertyId == null || userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Property ID and User ID must be numbers')),
      );
      return;
    }

    final request = FeedbackRequest(
      propertyId: propertyId,
      userId: userId,
      comment: _messageController.text.trim(),
      rating: _rating,
    );

    final provider = Provider.of<FeedbackProvider>(context, listen: false);
    await provider.submitFeedback(request);

    if (provider.submissionSuccess) _clearForm();
  }

  Widget _buildRatingStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final star = index + 1;
        return IconButton(
          icon: Icon(
            _rating >= star ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
          onPressed: () => setState(() => _rating = star),
        );
      }),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType type = TextInputType.text,
    List<TextInputFormatter>? formatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      inputFormatters: formatters,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feedback')),
      body: Consumer<FeedbackProvider>(
        builder: (context, provider, _) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  if (provider.isSubmitting)
                    const LinearProgressIndicator(),

                  if (provider.submissionSuccess)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text('✅ Feedback sent successfully!', style: TextStyle(color: Colors.green)),
                    ),

                  if (provider.error != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text('❌ ${provider.error}', style: const TextStyle(color: Colors.red)),
                    ),

                  const SizedBox(height: 16),
                  const Text('Rate your experience:', style: TextStyle(fontWeight: FontWeight.bold)),
                  _buildRatingStars(),

                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _propertyIdController,
                    label: 'Property ID',
                    icon: Icons.home,
                    type: TextInputType.number,
                    formatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),

                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _userIdController,
                    label: 'User ID',
                    icon: Icons.person,
                    type: TextInputType.number,
                    formatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),

                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email (optional)',
                    icon: Icons.email,
                    type: TextInputType.emailAddress,
                    validator: (v) {
                      if (v != null && v.isNotEmpty && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
                        return 'Invalid email';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _messageController,
                    maxLines: 4,
                    maxLength: 300,
                    decoration: const InputDecoration(
                      labelText: 'Your Feedback',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.feedback),
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),

                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.send),
                    label: const Text('Submit'),
                    onPressed: provider.isSubmitting ? null : () => _submitFeedback(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
