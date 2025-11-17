import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/auth_controller.dart';
import 'controllers/chat_controller.dart';
import 'controllers/cameras_controller.dart';
import 'controllers/events_controller.dart';
import 'controllers/alerts_controller.dart';
import 'services/supabase_service.dart';
import 'screens/auth_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/cameras_screen.dart';
import 'screens/events_screen.dart';
import 'screens/alerts_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/settings_screen.dart';
import 'utils/theme_constants.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ProxyProvider<AuthController, SupabaseService>(
          update: (_, auth, _) => SupabaseService(auth.user),
        ),
        ChangeNotifierProvider(create: (_) => ChatController()),
        ChangeNotifierProxyProvider<SupabaseService, CamerasController>(
          create: (_) => CamerasController(null), // Will be updated by update
          update: (_, supabase, controller) =>
              controller!..supabaseService = supabase,
        ),
        ChangeNotifierProxyProvider<SupabaseService, EventsController>(
          create: (_) => EventsController(null), // Will be updated by update
          update: (_, supabase, controller) =>
              controller!..supabaseService = supabase,
        ),
        ChangeNotifierProxyProvider<SupabaseService, AlertsController>(
          create: (_) => AlertsController(null), // Will be updated by update
          update: (_, supabase, controller) =>
              controller!..supabaseService = supabase,
        ),
      ],
      child: MaterialApp(
        title: 'EyeOn AI',
        theme: ThemeConstants.lightTheme,
        debugShowCheckedModeBanner: false,
        home: const AuthWrapper(),
        routes: {
          '/auth': (context) => const AuthScreen(),
          '/dashboard': (context) => const DashboardScreen(),
          '/chat': (context) => const ChatScreen(),
          '/cameras': (context) => const CamerasScreen(),
          '/events': (context) => const EventsScreen(),
          '/alerts': (context) => const AlertsScreen(),
          '/settings': (context) => const SettingsScreen(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();

    if (authController.isAuthenticated) {
      return const DashboardScreen();
    } else {
      return const AuthScreen();
    }
  }
}
