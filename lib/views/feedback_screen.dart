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
  final _scrollController = ScrollController();

  final _propertyIdController = TextEditingController();
  final _userIdController = TextEditingController();
  final _ratingController = TextEditingController();
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _scrollController.dispose();
    _propertyIdController.dispose();
    _userIdController.dispose();
    _ratingController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _propertyIdController.clear();
    _userIdController.clear();
    _ratingController.clear();
    _commentController.clear();
  }

  Future<void> _submitFeedback(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Submission'),
        content: const Text('Are you sure you want to submit this feedback?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Submit')),
        ],
      ),
    );

    if (confirmed != true) return;

    final propertyId = int.tryParse(_propertyIdController.text.trim());
    final userId = int.tryParse(_userIdController.text.trim());
    final rating = int.tryParse(_ratingController.text.trim());
    final comment = _commentController.text.trim();

    if (propertyId == null || userId == null || rating == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid numeric values')),
      );
      return;
    }

    final request = FeedbackRequest(
      propertyId: propertyId,
      userId: userId,
      rating: rating,
      comment: comment,
    );

    final provider = Provider.of<FeedbackProvider>(context, listen: false);
    await provider.submitFeedback(request);

    if (provider.submissionSuccess) {
      _clearForm();
      FocusScope.of(context).unfocus();
      _scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  Widget _buildStatusBanner({
    required Color color,
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onClose,
  }) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: 1,
      child: Card(
        color: color,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          leading: Icon(icon, color: Colors.black54),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(subtitle),
          trailing: IconButton(
            icon: const Icon(Icons.close),
            onPressed: onClose,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Send Feedback')),
        body: Consumer<FeedbackProvider>(
          builder: (context, provider, child) {
            return SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (provider.isSubmitting)
                    const LinearProgressIndicator(),

                  if (provider.submissionSuccess)
                    _buildStatusBanner(
                      color: Colors.green.shade100,
                      title: 'Feedback Sent',
                      subtitle: 'Thank you for your input!',
                      icon: Icons.check_circle_outline,
                      onClose: provider.resetState,
                    ),

                  if (provider.error != null)
                    _buildStatusBanner(
                      color: Colors.red.shade100,
                      title: 'Submission Failed',
                      subtitle: provider.error!,
                      icon: Icons.error_outline,
                      onClose: provider.resetState,
                    ),

                  const SizedBox(height: 20),
                  Text('Feedback Form', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text('Please fill out the form below to send your feedback.', style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 24),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: _propertyIdController,
                          label: 'Property ID',
                          icon: Icons.home,
                          validator: (v) => v == null || v.trim().isEmpty ? 'Enter Property ID' : null,
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _userIdController,
                          label: 'User ID',
                          icon: Icons.person,
                          validator: (v) => v == null || v.trim().isEmpty ? 'Enter User ID' : null,
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _ratingController,
                          label: 'Rating (1–5)',
                          icon: Icons.star,
                          validator: (v) {
                            final rating = int.tryParse(v ?? '');
                            if (rating == null || rating < 1 || rating > 5) {
                              return 'Enter a rating between 1 and 5';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _commentController,
                          maxLines: 5,
                          maxLength: 300,
                          decoration: const InputDecoration(
                            labelText: 'Your Feedback',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.feedback),
                            counterText: '',
                          ),
                          validator: (v) => v == null || v.trim().isEmpty ? 'Enter your feedback' : null,
                        ),
                        const SizedBox(height: 24),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.send),
                            label: const Text('Submit'),
                            onPressed: provider.isSubmitting ? null : () => _submitFeedback(context),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              backgroundColor: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      validator: validator,
    );
  }
}
