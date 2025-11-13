import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/auth_controller.dart';
import 'controllers/chat_controller.dart';
import 'controllers/cameras_controller.dart';
import 'controllers/events_controller.dart';
import 'controllers/alerts_controller.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/cameras_screen.dart';
import 'screens/events_screen.dart';
import 'screens/alerts_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => ChatController()),
        ChangeNotifierProvider(create: (_) => CamerasController()),
        ChangeNotifierProvider(create: (_) => EventsController()),
        ChangeNotifierProvider(create: (_) => AlertsController()),
      ],
      child: MaterialApp(
        title: 'EyeOn AI',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const AuthWrapper(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignupScreen(),
          '/chat': (context) => const ChatScreen(),
          '/cameras': (context) => const CamerasScreen(),
          '/events': (context) => const EventsScreen(),
          '/alerts': (context) => const AlertsScreen(),
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
      return const HomeScreen();
    } else {
      return const LoginScreen();
    }
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EyeOn AI Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final authController = context.read<AuthController>();
              await authController.signOut();
            },
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        children: [
          _buildMenuCard(context, 'Chat', Icons.chat, '/chat'),
          _buildMenuCard(context, 'Cameras', Icons.camera, '/cameras'),
          _buildMenuCard(context, 'Events', Icons.event, '/events'),
          _buildMenuCard(context, 'Alerts', Icons.notifications, '/alerts'),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    IconData icon,
    String route,
  ) {
    return Card(
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48),
            const SizedBox(height: 8),
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
          ],
        ),
      ),
    );
  }
}
