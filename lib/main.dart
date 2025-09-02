import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Providers
import 'package:homehunt/providers/theme_provider.dart';
import 'package:homehunt/providers/auth_provider.dart';
import 'package:homehunt/providers/property_provider.dart';
import 'package:homehunt/providers/property_search_provider.dart';
import 'package:homehunt/providers/transection_provider.dart';
import 'package:homehunt/providers/feedback_provider.dart';

// Services
import 'package:homehunt/services/property_service.dart';
import 'package:homehunt/services/transection_service.dart';
import 'package:homehunt/services/feedback_service.dart';

// Screens
import 'package:homehunt/views/home_screen.dart';
import 'package:homehunt/views/profile_screen.dart';
import 'package:homehunt/views/property_search_screen.dart';
import 'package:homehunt/views/transection_screen.dart';
import 'package:homehunt/views/dashboard_screen.dart';
import 'package:homehunt/views/login_screen.dart';
import 'package:homehunt/views/registration_screen.dart';
import 'package:homehunt/views/change_password_screen.dart';
import 'package:homehunt/views/forget_password_screen.dart';
import 'package:homehunt/views/reset_token_screen.dart';
import 'package:homehunt/views/feedback_screen.dart';
import 'package:homehunt/views/main_screen.dart';
import 'package:homehunt/views/counter_screen.dart';
import 'package:homehunt/views/property_screen.dart';

void main() {
  runApp(const HomeHuntApp());
}

class HomeHuntApp extends StatelessWidget {
  const HomeHuntApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PropertySearchProvider()),
        Provider(create: (_) => PropertyService()),
        ChangeNotifierProvider(
          create: (context) => PropertyProvider(context.read<PropertyService>()),
        ),
        Provider(create: (_) => TransactionService()),
        ChangeNotifierProvider(
          create: (context) => TransactionProvider(context.read<TransactionService>()),
        ),
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
      initialRoute: RouteNames.home,
      onGenerateRoute: (settings) {
        final args = settings.arguments;

        switch (settings.name) {
          case RouteNames.home:
            return MaterialPageRoute(builder: (_) => const HomeScreen());
          case RouteNames.profile:
            return MaterialPageRoute(builder: (_) => const ProfileScreen());
          case RouteNames.propertySearch:
            return MaterialPageRoute(builder: (_) => PropertySearchScreen());
          case RouteNames.transaction:
            return MaterialPageRoute(builder: (_) => const TransactionScreen());
          case RouteNames.dashboard:
            final token = args is String ? args : '';
            return MaterialPageRoute(builder: (_) => DashboardScreen(restToken: token));
          case RouteNames.login:
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case RouteNames.register:
            return MaterialPageRoute(builder: (_) => const RegistrationScreen());
          case RouteNames.changePassword:
            return MaterialPageRoute(builder: (_) => const ChangePasswordScreen());
          case RouteNames.forgetPassword:
            return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
          case RouteNames.resetToken:
            return MaterialPageRoute(builder: (_) => const ResendTokenScreen());
          case RouteNames.feedback:
            return MaterialPageRoute(builder: (_) => const FeedbackScreen());
          case RouteNames.main:
            return MaterialPageRoute(builder: (_) => const MainScreen());
          case RouteNames.counter:
            return MaterialPageRoute(builder: (_) => const CounterScreen());
          case RouteNames.properties:
            return MaterialPageRoute(builder: (_) => const PropertyScreen());
          default:
            debugPrint('Unknown route: ${settings.name}');
            return MaterialPageRoute(builder: (_) => const RegistrationScreen());
        }
      },
    );
  }
}

class RouteNames {
  static const home = '/home';
  static const profile = '/profile';
  static const propertySearch = '/propertySearch';
  static const transaction = '/transaction';
  static const dashboard = '/dashboard';
  static const login = '/login';
  static const register = '/register';
  static const changePassword = '/changePassword';
  static const forgetPassword = '/forgetPassword';
  static const resetToken = '/resetToken';
  static const feedback = '/feedback';
  static const main = '/main';
  static const counter = '/counter';
  static const properties = '/properties';
}
