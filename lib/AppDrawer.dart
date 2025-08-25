import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:homehunt/providers/auth_provider.dart';
import 'package:homehunt/providers/theme_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final user = auth.user;
    final theme = Theme.of(context);
    final initials = (user?.firstName ?? 'U').substring(0, 1).toUpperCase();
    final currentRoute = ModalRoute.of(context)?.settings.name;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // 🌟 Custom Drawer Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [theme.colorScheme.primary, theme.colorScheme.primaryContainer],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Text(
                      initials,
                      style: const TextStyle(fontSize: 24, color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${user?.firstName ?? ''} ${user?.lastName ?? ''}',
                          style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          user?.email ?? '',
                          style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    tooltip: 'Edit Profile',
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/profile');
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // 🧭 Navigation Items
            _drawerItem(context, icon: Icons.dashboard, label: 'Dashboard', route: '/dashboard', active: currentRoute == '/dashboard'),
            _drawerItem(context, icon: Icons.swap_horiz, label: 'Transactions', route: '/transaction', active: currentRoute == '/transaction'),
            _drawerItem(context, icon: Icons.home_work, label: 'Properties', route: '/properties', active: currentRoute == '/properties'),
            _drawerItem(context, icon: Icons.search, label: 'PropertySearch', route: '/propertySearch', active: currentRoute == '/propertySearch'),

            _drawerItem(context, icon: Icons.feedback, label: 'Feedback', route: '/feedback', active: currentRoute == '/feedback'),
            _drawerItem(context, icon: Icons.home, label: 'Home', route: '/home', replace: true, active: currentRoute == '/home'),

            const Divider(),

            // 🌗 Theme Toggle
            SwitchListTile(
              secondary: Icon(themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode),
              title: const Text('Dark Mode'),
              value: themeProvider.isDarkMode,
              onChanged: (value) => themeProvider.setDarkMode(value),
            ),

            const Divider(),

            // 🚪 Logout with confirmation
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text('Logout', style: TextStyle(color: Colors.redAccent)),
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Confirm Logout'),
                    content: const Text('Are you sure you want to log out?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                      TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Logout')),
                    ],
                  ),
                );

                if (confirm == true) {
                  await auth.logout();
                  if (!context.mounted) return;
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(
      BuildContext context, {
        required IconData icon,
        required String label,
        required String route,
        bool replace = false,
        bool active = false,
      }) {
    final theme = Theme.of(context);
    final color = active ? theme.colorScheme.primary : null;
    final textStyle = active
        ? theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: color)
        : theme.textTheme.bodyLarge;

    return ListTile(
      leading: Icon(icon, color: color ?? theme.iconTheme.color),
      title: Text(label, style: textStyle),
      onTap: () {
        Navigator.pop(context);
        if (replace) {
          Navigator.pushReplacementNamed(context, route);
        } else {
          Navigator.pushNamed(context, route);
        }
      },
    );
  }
}

