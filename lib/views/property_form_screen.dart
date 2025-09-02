import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/location.dart';
import '../models/property_dto.dart';
import '../providers/property_provider.dart';

class PropertyFormScreen extends StatefulWidget {
  const PropertyFormScreen({super.key});

  @override
  State<PropertyFormScreen> createState() => _PropertyFormScreenState();
}

class _PropertyFormScreenState extends State<PropertyFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();
  final _bedroomsController = TextEditingController();

  PropertyStatus? _selectedStatus;
  PropertyType? _selectedType;
  File? _selectedImage;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    _bedroomsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedStatus == null || _selectedType == null || _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final locationParts = _locationController.text.split(',').map((e) => e.trim()).toList();
    final location = Location(
      city: locationParts.isNotEmpty ? locationParts[0] : '',
      state: locationParts.length > 1 ? locationParts[1] : 'Lagos',
      country: locationParts.length > 2 ? locationParts[2] : 'Nigeria',
    );

    final property = PropertyDto(
      id: DateTime.now().millisecondsSinceEpoch,
      title: _titleController.text.trim(),
      price: double.parse(_priceController.text.trim()),
      bedrooms: int.parse(_bedroomsController.text.trim()),
      location: location,
      status: _selectedStatus!,
      type: _selectedType!,
      imageUrl: _selectedImage!.path, // Replace with actual upload logic later
      isFeatured: false,
      description: '',
      agent: User(
        firstName: 'Agent',
        lastName: 'Smith',
        email: 'agent@example.com',
        password: 'secret',
        role: 'AGENT',
        localDate: DateTime.now(),
      ),
    );

    try {
      await Provider.of<PropertyProvider>(context, listen: false).postProperty(property, 1);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Property posted')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
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
      appBar: AppBar(title: const Text('Post Property')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                controller: _titleController,
                label: 'Title',
                icon: Icons.title,
                validator: (v) => v != null && v.trim().isNotEmpty ? null : 'Enter title',
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _priceController,
                label: 'Price',
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
                validator: (v) => double.tryParse(v ?? '') != null ? null : 'Enter valid price',
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _bedroomsController,
                label: 'Bedrooms',
                icon: Icons.bed,
                keyboardType: TextInputType.number,
                validator: (v) => int.tryParse(v ?? '') != null ? null : 'Enter valid number',
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _locationController,
                label: 'Location (City, State, Country)',
                icon: Icons.location_on,
                validator: (v) => v != null && v.trim().isNotEmpty ? null : 'Enter location',
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<PropertyStatus>(
                value: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: PropertyStatus.values.map((status) {
                  return DropdownMenuItem(value: status, child: Text(status.name));
                }).toList(),
                onChanged: (val) => setState(() => _selectedStatus = val),
                validator: (val) => val == null ? 'Select status' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<PropertyType>(
                value: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(),
                ),
                items: PropertyType.values.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type.name));
                }).toList(),
                onChanged: (val) => setState(() => _selectedType = val),
                validator: (val) => val == null ? 'Select type' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.image),
                label: const Text('Upload Image'),
                onPressed: _pickImage,
              ),
              if (_selectedImage != null) ...[
                const SizedBox(height: 12),
                Image.file(_selectedImage!, height: 150, fit: BoxFit.cover),
              ],
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                icon: const Icon(Icons.send),
                label: const Text('Submit'),
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
