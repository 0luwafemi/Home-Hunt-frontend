import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/transection_request.dart';
import '../models/transection_response.dart';
import '../providers/transection_provider.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  int? selectedPropertyId;
  TransactionType? selectedTransactionType;
  final int currentUserId = 1; // Replace with dynamic user ID

  final List<int> propertyOptions = [101, 102, 103]; // Replace with dynamic list
  final List<TransactionType> transactionTypes = TransactionType.values;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitTransaction(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    if (selectedPropertyId == null || selectedTransactionType == null) {
      _showSnack('Please select property and transaction type');
      return;
    }

    final request = TransactionRequest(
      paymentAmount: double.parse(_amountController.text.trim()),
      propertyId: selectedPropertyId!,
      type: selectedTransactionType!,
      description: _descriptionController.text.trim(),
    );

    final provider = Provider.of<TransactionProvider>(context, listen: false);
    provider.processTransaction(request, currentUserId);
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _amountController.clear();
    _descriptionController.clear();
    setState(() {
      selectedPropertyId = null;
      selectedTransactionType = null;
    });
  }

  Widget _buildStatusCard({
    required Color color,
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onClose,
  }) {
    return Card(
      color: color,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.black54),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: IconButton(icon: const Icon(Icons.close), onPressed: onClose),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Process Transaction')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (provider.isProcessing)
              const LinearProgressIndicator(),

            if (provider.response != null)
              _buildStatusCard(
                color: Colors.green.shade100,
                title: 'Transaction Successful',
                subtitle: 'ID: ${provider.response!.transactionId}',
                icon: Icons.check_circle_outline,
                onClose: () {
                  provider.resetState();
                  _resetForm();
                },
              ),

            if (provider.error != null)
              _buildStatusCard(
                color: Colors.red.shade100,
                title: 'Transaction Failed',
                subtitle: provider.error!,
                icon: Icons.error_outline,
                onClose: provider.resetState,
              ),

            const SizedBox(height: 20),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildDropdown<int>(
                    label: 'Select Property',
                    icon: Icons.home,
                    value: selectedPropertyId,
                    items: propertyOptions,
                    itemLabel: (id) => 'Property #$id',
                    onChanged: (val) => setState(() => selectedPropertyId = val),
                    validator: (val) => val == null ? 'Select a property' : null,
                  ),
                  const SizedBox(height: 16),

                  _buildDropdown<TransactionType>(
                    label: 'Transaction Type',
                    icon: Icons.swap_horiz,
                    value: selectedTransactionType,
                    items: transactionTypes,
                    itemLabel: (type) => type.name,
                    onChanged: (val) => setState(() => selectedTransactionType = val),
                    validator: (val) => val == null ? 'Select a transaction type' : null,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                    validator: (value) {
                      final parsed = double.tryParse(value ?? '');
                      if (parsed == null || parsed <= 0) {
                        return 'Enter a valid amount';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.description),
                    ),
                    validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Enter description' : null,
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.send),
                      label: const Text('Submit Transaction'),
                      onPressed: provider.isProcessing
                          ? null
                          : () => _submitTransaction(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required IconData icon,
    required T? value,
    required List<T> items,
    required String Function(T) itemLabel,
    required void Function(T?) onChanged,
    required String? Function(T?) validator,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      isExpanded: true,
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(itemLabel(item))))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      validator: validator,
    );
  }
}
