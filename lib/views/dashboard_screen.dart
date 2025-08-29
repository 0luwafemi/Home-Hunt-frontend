import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const username = 'Oluwafemi'; // Replace with dynamic user data if available

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 600;

              return ListView(
                children: [
                  const SizedBox(height: 8),
                  WelcomeBanner(username: username),
                  const SizedBox(height: 24),

                  const SectionHeader(title: 'Overview'),
                  const SizedBox(height: 12),

                  isWide
                      ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Expanded(child: AnimatedCard(delay: 100, child: ActivityCard())),
                      SizedBox(width: 16),
                      Expanded(child: AnimatedCard(delay: 200, child: PerformanceCard())),
                    ],
                  )
                      : Column(
                    children: const [
                      AnimatedCard(delay: 100, child: ActivityCard()),
                      SizedBox(height: 16),
                      AnimatedCard(delay: 200, child: PerformanceCard()),
                    ],
                  ),
                  const SizedBox(height: 32),

                  const SectionHeader(title: 'Quick Actions'),
                  const SizedBox(height: 12),

                  isWide
                      ? Row(
                    children: const [
                      Expanded(child: ActionButton(icon: Icons.home, label: 'View Properties', route: '/properties')),
                      SizedBox(width: 12),
                      Expanded(child: ActionButton(icon: Icons.add, label: 'Post Property', route: '/addProperty')),
                      SizedBox(width: 12),
                      Expanded(child: ActionButton(icon: Icons.lock, label: 'Change Password', route: '/changePassword')),
                    ],
                  )
                      : Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: const [
                      ActionButton(icon: Icons.home, label: 'View Properties', route: '/properties'),
                      ActionButton(icon: Icons.add, label: 'Post Property', route: '/addProperty'),
                      ActionButton(icon: Icons.lock, label: 'Change Password', route: '/changePassword'),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class WelcomeBanner extends StatelessWidget {
  final String username;

  const WelcomeBanner({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.person, size: 32, color: Theme.of(context).colorScheme.onPrimaryContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Welcome back, $username!',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  const ActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        leading: Icon(Icons.analytics, color: Theme.of(context).colorScheme.primary),
        title: const Text('Activity Summary'),
        subtitle: const Text('You’ve logged in 5 times this week'),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Viewing activity details...')),
          );
        },
      ),
    );
  }
}

class PerformanceCard extends StatelessWidget {
  const PerformanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        leading: Icon(Icons.bar_chart, color: Theme.of(context).colorScheme.secondary),
        title: const Text('Performance'),
        subtitle: const Text('Your engagement is up 20%'),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Viewing performance metrics...')),
          );
        },
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;

  const ActionButton({super.key, required this.icon, required this.label, required this.route});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: Theme.of(context).textTheme.labelLarge,
      ),
      onPressed: () => Navigator.pushNamed(context, route),
    );
  }
}

class AnimatedCard extends StatelessWidget {
  final Widget child;
  final int delay;

  const AnimatedCard({super.key, required this.child, this.delay = 0});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 500 + delay),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 20),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
