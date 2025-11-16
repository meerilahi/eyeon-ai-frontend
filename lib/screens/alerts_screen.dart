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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      alertsController.loadAlerts();
    });

    alertsController.subscribeToAlerts();
  }

  @override
  Widget build(BuildContext context) {
    final alertsController = context.watch<AlertsController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Alerts')),
      body: alertsController.isLoading
          ? const Center(child: CircularProgressIndicator())
          : alertsController.alerts.isEmpty
          ? const Center(child: Text('No alerts found'))
          : ListView.builder(
              itemCount: alertsController.alerts.length,
              itemBuilder: (context, index) {
                final alert = alertsController.alerts[index];
                return ListTile(
                  title: Text(alert.message),
                  subtitle: Text(alert.timestamp.toString()),
                  leading: Icon(
                    Icons.circle,
                    color: alert.alertLevel == AlertLevel.low
                        ? Colors.green
                        : alert.alertLevel == AlertLevel.medium
                        ? Colors.amber
                        : Colors.red,
                  ),
                );
              },
            ),
    );
  }
}
