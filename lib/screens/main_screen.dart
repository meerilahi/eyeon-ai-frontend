import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../controllers/chat_controller.dart';
import '../controllers/device_controller.dart';
import '../controllers/events_controller.dart';
import '../controllers/alerts_controller.dart';
import 'chat_screen.dart';
import 'devices_screen.dart';
import 'events_screen.dart';
import 'alerts_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = <Widget>[
    ChatScreen(),
    EventsScreen(),
    AlertsScreen(),
    DevicesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1a1a2e), Color(0xFF16213e), Color(0xFF0f3460)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        extendBody: true,

        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: AppBar(
                backgroundColor: Colors.white.withOpacity(0.05),
                elevation: 0,
                centerTitle: true,

                title: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [Colors.white, Colors.red.shade200],
                  ).createShader(bounds),
                  child: const Text(
                    'EyeOn AI',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),

                actions: [
                  PopupMenuButton<String>(
                    color: Colors.black.withOpacity(0.3),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem<String>(
                        value: 'settings',
                        child: Row(
                          children: [
                            Icon(
                              Icons.settings,
                              color: Colors.white.withOpacity(0.8),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Settings',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'logout',
                        child: Row(
                          children: [
                            Icon(
                              Icons.logout,
                              color: Colors.red.shade300,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Logout',
                              style: TextStyle(
                                color: Colors.red.shade300,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'settings') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsScreen(),
                          ),
                        );
                      } else if (value == 'logout') {
                        _logout();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),

        body: _screens.elementAt(_selectedIndex),

        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 26),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.shade400.withOpacity(0.15),
                      blurRadius: 30,
                      spreadRadius: 1,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),

                child: BottomNavigationBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: Colors.red.shade400,
                  unselectedItemColor: Colors.white.withOpacity(0.4),
                  selectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  unselectedLabelStyle: const TextStyle(fontSize: 11),
                  currentIndex: _selectedIndex,
                  onTap: _onItemTapped,

                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.chat_bubble_outline),
                      label: 'Chat',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.event_note_outlined),
                      label: 'Events',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.notifications_outlined),
                      label: 'Alerts',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.camera_alt_outlined),
                      label: 'Devices',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _logout() async {
    final authController = context.read<AuthController>();
    context.read<ChatController>().clearData();
    context.read<DeviceController>().clearData();
    context.read<EventsController>().clearData();
    context.read<AlertsController>().clearData();
    await authController.signOut();
  }
}
