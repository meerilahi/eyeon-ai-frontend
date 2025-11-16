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
      body: alertsController.isLoading
          ? const Center(child: CircularProgressIndicator())
          : alertsController.alerts.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No alerts found'),
                  SizedBox(height: 8),
                  Text(
                    'You\'re all caught up!',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: alertsController.alerts.length,
              itemBuilder: (context, index) {
                final alert = alertsController.alerts[index];
                Color alertColor;
                String levelText;
                switch (alert.alertLevel) {
                  case AlertLevel.low:
                    alertColor = Colors.green;
                    levelText = 'Low';
                    break;
                  case AlertLevel.medium:
                    alertColor = Colors.amber;
                    levelText = 'Medium';
                    break;
                  case AlertLevel.high:
                    alertColor = Colors.red;
                    levelText = 'High';
                    break;
                }
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: alertColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Alert Level: $levelText',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: alertColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          alert.message,
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              alert.timestamp.toString().split('.')[0],
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
