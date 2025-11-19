import 'package:eyeon_ai_frontend/screens/alerts_screen.dart';
import 'package:eyeon_ai_frontend/screens/cameras_screen.dart';
import 'package:eyeon_ai_frontend/screens/chat_screen.dart';
import 'package:eyeon_ai_frontend/screens/dashboard_screen.dart';
import 'package:eyeon_ai_frontend/screens/events_screen.dart';
import 'package:eyeon_ai_frontend/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/auth_controller.dart';
import 'controllers/chat_controller.dart';
import 'controllers/cameras_controller.dart';
import 'controllers/events_controller.dart';
import 'controllers/alerts_controller.dart';
import 'services/supabase_service.dart';
import 'screens/auth_screen.dart';
import 'screens/main_screen.dart';

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
      return const MainScreen();
    } else {
      return const AuthScreen();
    }
  }
}
