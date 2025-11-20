import 'package:eyeon_ai_frontend/controllers/settings_controller.dart';
import 'package:eyeon_ai_frontend/screens/alerts_screen.dart';
import 'package:eyeon_ai_frontend/screens/devices_screen.dart';
import 'package:eyeon_ai_frontend/screens/chat_screen.dart';
import 'package:eyeon_ai_frontend/screens/events_screen.dart';
import 'package:eyeon_ai_frontend/screens/settings_screen.dart';
import 'package:eyeon_ai_frontend/services/websocket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/auth_controller.dart';
import 'controllers/chat_controller.dart';
import 'controllers/device_controller.dart';
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
          update: (_, auth, __) => SupabaseService(auth.user),
        ),
        ChangeNotifierProxyProvider<AuthController, ChatController>(
          create: (_) => ChatController(),
          update: (_, auth, chatController) {
            if (auth.isAuthenticated) {
              chatController!.service = WebSocketService(auth.user);
            }
            return chatController!;
          },
        ),
        ChangeNotifierProxyProvider<SupabaseService, DeviceController>(
          create: (_) => DeviceController(null),
          update: (_, supabase, controller) => controller!..service = supabase,
        ),
        ChangeNotifierProxyProvider<SupabaseService, EventsController>(
          create: (_) => EventsController(null),
          update: (_, supabase, controller) =>
              controller!..supabaseService = supabase,
        ),
        ChangeNotifierProxyProvider<SupabaseService, AlertsController>(
          create: (_) => AlertsController(null),
          update: (_, supabase, controller) =>
              controller!..supabaseService = supabase,
        ),
        ChangeNotifierProxyProvider<SupabaseService, SettingsController>(
          create: (_) => SettingsController(null),
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
          '/chat': (context) => const ChatScreen(),
          '/devices': (context) => const DevicesScreen(),
          '/events': (context) => const EventsScreen(),
          '/alerts': (context) => const AlertsScreen(),
          '/settings': (context) => SettingsScreen(),
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
