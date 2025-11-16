import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
import 'utils/theme_constants.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    notifyListeners();
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
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
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'EyeOn AI',
            theme: ThemeConstants.lightTheme,
            darkTheme: ThemeConstants.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const AuthWrapper(),
            routes: {
              '/auth': (context) => const AuthScreen(),
              '/chat': (context) => const ChatScreen(),
              '/cameras': (context) => const CamerasScreen(),
              '/events': (context) => const EventsScreen(),
              '/alerts': (context) => const AlertsScreen(),
            },
          );
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
    final themeProvider = context.watch<ThemeProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text("EyeOn AI"),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.themeMode == ThemeMode.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () => themeProvider.toggleTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final authController = context.read<AuthController>();
              final chatController = context.read<ChatController>();
              final camerasController = context.read<CamerasController>();
              final eventsController = context.read<EventsController>();
              final alertsController = context.read<AlertsController>();
              chatController.clearData();
              camerasController.clearData();
              eventsController.clearData();
              alertsController.clearData();
              await authController.signOut();
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
        selectedItemColor: Colors.red,
        // unselectedItemColor: Colors.redAccent,
        // unselectedIconTheme: IconThemeData(),
        onTap: _onItemTapped,
      ),
    );
  }
}
