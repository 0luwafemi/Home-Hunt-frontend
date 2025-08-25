import 'package:flutter/material.dart';
import 'package:homehunt/providers/property_search_provider.dart';
import 'package:homehunt/services/property_search_service.dart';
import 'package:homehunt/views/property_search_screen.dart';
import 'package:provider/provider.dart';

// Services & Providers
import 'package:homehunt/providers/theme_provider.dart';
import 'package:homehunt/providers/auth_provider.dart';
import 'package:homehunt/providers/property_provider.dart';
import 'package:homehunt/providers/transection_provider.dart';
import 'package:homehunt/providers/feedback_provider.dart';

import 'package:homehunt/services/property_service.dart';
import 'package:homehunt/services/transection_service.dart';
import 'package:homehunt/services/feedback_service.dart';

// Screens
import 'package:homehunt/views/main_screen.dart';
import 'package:homehunt/views/counter_screen.dart';
import 'package:homehunt/views/property_screen.dart';
import 'package:homehunt/views/feedback_screen.dart';
import 'package:homehunt/views/home_screen.dart';
import 'package:homehunt/views/profile_screen.dart';
import 'package:homehunt/views/dashboard_screen.dart';
import 'package:homehunt/views/login_screen.dart';
import 'package:homehunt/views/registration_screen.dart';
import 'package:homehunt/views/transection_screen.dart';

void main() {
  runApp(const HomeHuntApp());
}

class HomeHuntApp extends StatelessWidget {
  const HomeHuntApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Theme
        ChangeNotifierProvider(create: (_) => ThemeProvider()),

        // Auth
        ChangeNotifierProvider(create: (_) => AuthProvider()),

        ChangeNotifierProvider(create: (_) => PropertySearchProvider()),

        // Provider(create: (_) => PropertySearchService()),
        // ChangeNotifierProvider(
        //   create: (context) => PropertySearchProvider(context.read<PropertySearchService>()),
        // ),

        // Property
        Provider(create: (_) => PropertyService()),
        ChangeNotifierProvider(
          create: (context) => PropertyProvider(context.read<PropertyService>()),
        ),

        // Transaction
        Provider(create: (_) => TransactionService()),
        ChangeNotifierProvider(
          create: (context) => TransactionProvider(context.read<TransactionService>()),
        ),

        // Feedback
        Provider(create: (_) => FeedbackService()),
        ChangeNotifierProvider(
          create: (context) => FeedbackProvider(context.read<FeedbackService>()),
        ),
      ],
      child: const HomeHuntRoot(),
    );
  }
}

class HomeHuntRoot extends StatelessWidget {
  const HomeHuntRoot({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Home Hunt',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.themeMode,
      initialRoute: '/home',
      onGenerateRoute: _onGenerateRoute,
    );
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    final routes = <String, Widget>{
      '/home': const HomeScreen(),
      '/profile': const ProfileScreen(),
      '/propertySearch':PropertySearchScreen(),
      '/transaction': const TransactionScreen(),
      '/dashboard': const DashboardScreen(),
      '/login': const LoginScreen(),
      '/register': const RegistrationScreen(),
      '/feedback': const FeedbackScreen(),
      '/main': const MainScreen(),
      '/counter': const CounterScreen(),
      '/properties': const PropertyScreen(),
    };

    final page = routes[settings.name];
    return MaterialPageRoute(
      builder: (_) => page ?? const RegistrationScreen(), // fallback
    );
  }
}
