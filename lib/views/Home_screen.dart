import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../AppDrawer.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showWelcomePopup();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _showWelcomePopup() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final name = auth.user?.firstName ?? 'User';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Welcome!'),
        content: Text('Hi $name 👋, we’re glad to see you again!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Thanks!'),
          ),
        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await Provider.of<AuthProvider>(context, listen: false).logout();
    if (!context.mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600;
    final textScale = MediaQuery.textScaleFactorOf(context);

    return Consumer2<AuthProvider, ThemeProvider>(
      builder: (context, auth, theme, _) {
        final user = auth.user;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
            actions: [
              IconButton(
                icon: Icon(theme.isDarkMode ? Icons.dark_mode : Icons.light_mode),
                onPressed: () => theme.setDarkMode(!theme.isDarkMode),
                tooltip: 'Toggle Theme',
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => _logout(context),
                tooltip: 'Logout',
              ),
            ],
          ),
          drawer: isWideScreen ? null : const AppDrawer(),
          body: SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: isWideScreen ? 700 : double.infinity),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                          child: Icon(Icons.person, size: 40, color: Theme.of(context).colorScheme.primary),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '${_getGreeting()}, ${user?.firstName ?? 'User'}!',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          textScaleFactor: textScale,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Welcome back to your dashboard.',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                          textScaleFactor: textScale,
                        ),
                        const SizedBox(height: 32),

                        // 🧭 Dashboard Cards
                        _dashboardCard(
                          context,
                          icon: Icons.home_work,
                          title: 'View Properties',
                          subtitle: 'Browse listings',
                          route: '/properties',
                        ),
                        _dashboardCard(
                          context,
                          icon: Icons.swap_horiz,
                          title: 'Transactions',
                          subtitle: 'Track activity',
                          route: '/transaction',
                        ),

                        _dashboardCard(
                          context,
                          icon: Icons.search,
                          title: 'Search Property',
                          subtitle: 'Look for Property',
                          route: '/propertySearch',
                        ),
                        _dashboardCard(
                          context,
                          icon: Icons.feedback_outlined,
                          title: 'Send Feedback',
                          subtitle: 'Share your thoughts',
                          route: '/feedback',
                        ),
                        _dashboardCard(
                          context,
                          icon: Icons.logout,
                          title: 'Logout',
                          subtitle: 'Sign out',
                          onTap: () => _logout(context),
                          backgroundColor: Colors.grey.shade200,
                          foregroundColor: Colors.black87,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _dashboardCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        String? route,
        VoidCallback? onTap,
        Color? backgroundColor,
        Color? foregroundColor,
      }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      color: backgroundColor ?? Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: foregroundColor ?? Theme.of(context).colorScheme.primary),
        title: Text(title, style: TextStyle(color: foregroundColor)),
        subtitle: Text(subtitle, style: TextStyle(color: foregroundColor?.withOpacity(0.8))),
        onTap: onTap ?? () => Navigator.pushNamed(context, route!),
      ),
    );
  }
}
