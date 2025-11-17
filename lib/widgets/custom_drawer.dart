import 'package:eyeon_ai_frontend/controllers/alerts_controller.dart';
import 'package:eyeon_ai_frontend/controllers/auth_controller.dart';
import 'package:eyeon_ai_frontend/controllers/cameras_controller.dart';
import 'package:eyeon_ai_frontend/controllers/chat_controller.dart';
import 'package:eyeon_ai_frontend/controllers/events_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: const Text(
              'EyeOn AI',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushReplacementNamed(context, '/dashboard');
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Chat Agent'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushReplacementNamed(context, '/chat');
            },
          ),
          ListTile(
            leading: const Icon(Icons.event),
            title: const Text('Events'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushReplacementNamed(context, '/events');
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera),
            title: const Text('Cameras'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushReplacementNamed(context, '/cameras');
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Alerts'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushReplacementNamed(context, '/alerts');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushReplacementNamed(context, '/settings');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
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
    );
  }
}
