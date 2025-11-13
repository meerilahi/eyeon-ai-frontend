import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/alerts_controller.dart';
import '../models/alert.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  @override
  void initState() {
    super.initState();
    final alertsController = context.read<AlertsController>();
    alertsController.loadAlerts();
    alertsController.subscribeToAlerts();
  }

  @override
  Widget build(BuildContext context) {
    final alertsController = context.watch<AlertsController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Alerts')),
      body: alertsController.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: alertsController.alerts.length,
              itemBuilder: (context, index) {
                final alert = alertsController.alerts[index];
                return ListTile(
                  title: Text(alert.message),
                  subtitle: Text(alert.timestamp.toString()),
                  leading: Icon(
                    alert.isRead
                        ? Icons.notifications_none
                        : Icons.notifications,
                    color: alert.isRead ? null : Colors.red,
                  ),
                  onTap: () => alertsController.markAsRead(alert.id),
                );
              },
            ),
    );
  }
}
