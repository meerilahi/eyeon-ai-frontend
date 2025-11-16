import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/auth_controller.dart';
import 'controllers/chat_controller.dart';
import 'controllers/cameras_controller.dart';
import 'controllers/events_controller.dart';
import 'controllers/alerts_controller.dart';
import 'screens/auth_screen.dart';
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
        home: const AuthWrapper(),
        routes: {
          '/auth': (context) => const AuthScreen(),
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
      return const MainScreen();
    } else {
      return const AuthScreen();
    }
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1;

  static const List<Widget> _widgetOptions = <Widget>[
    ChatScreen(),
    CamerasScreen(),
    EventsScreen(),
    AlertsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EyeOn AI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final authController = context.read<AuthController>();
              final chatController = context.read<ChatController>();
              final camerasController = context.read<CamerasController>();
              final eventsController = context.read<EventsController>();
              final alertsController = context.read<AlertsController>();
              await authController.signOut();
              chatController.clearData();
              camerasController.clearData();
              eventsController.clearData();
              alertsController.clearData();
            },
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.camera), label: 'Cameras'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Alerts',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
