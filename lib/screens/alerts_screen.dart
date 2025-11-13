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
  late Future<List<AlertLog>> _alertsFuture;

  @override
  void initState() {
    super.initState();
    _alertsFuture = context.read<AlertsController>().fetchAlerts();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AlertsController>().subscribeToAlerts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alerts')),
      body: FutureBuilder<List<AlertLog>>(
        future: _alertsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final alerts = snapshot.data!;
            return ListView.builder(
              itemCount: alerts.length,
              itemBuilder: (context, index) {
                final alert = alerts[index];
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
            );
          } else {
            return const Center(child: Text('No alerts found'));
          }
        },
      ),
    );
  }
}
