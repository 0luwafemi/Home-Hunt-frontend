import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;
    final theme = Theme.of(context);
    final textScale = MediaQuery.textScaleFactorOf(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: user == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🧑 Avatar
              CircleAvatar(
                radius: 50,
                backgroundColor: theme.colorScheme.primary,
                child: Text(
                  user.firstName[0].toUpperCase(),
                  style: const TextStyle(fontSize: 32, color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${user.firstName} ${user.lastName}',
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                textScaleFactor: textScale,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                user.email,
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
                textScaleFactor: textScale,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              const Divider(),

              // 📋 Info Tiles
              _infoTile(icon: Icons.person, label: 'Full Name', value: '${user.firstName} ${user.lastName}'),
              _infoTile(icon: Icons.email, label: 'Email Address', value: user.email),
              if (user.role.name.isNotEmpty)
                _infoTile(icon: Icons.badge, label: 'Role', value: user.role.name),

              if (user.localDate != null)
                _infoTile(icon: Icons.calendar_today, label: 'Joined On', value: user.localDate!),

              const Spacer(),

              // ✏️ Edit Button
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/edit-profile'),
                icon: const Icon(Icons.edit),
                label: const Text('Edit Profile'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  backgroundColor: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoTile({required IconData icon, required String label, required String value}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(value),
      subtitle: Text(label),
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
    );
  }
}
