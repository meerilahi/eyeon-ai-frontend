import 'package:flutter/material.dart';
import '../models/alert.dart';
import '../services/supabase_service.dart';

class AlertsController extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();
  List<Alert> _alerts = [];
  bool _isLoading = false;
  Stream<List<Alert>>? _alertsStream;

  List<Alert> get alerts => _alerts;
  bool get isLoading => _isLoading;

  void loadAlerts() {
    _isLoading = true;
    notifyListeners();
    _supabaseService
        .getAlerts()
        .then((alerts) {
          _alerts = alerts;
          _isLoading = false;
          notifyListeners();
        })
        .catchError((e) {
          _isLoading = false;
          notifyListeners();
          // Handle error
        });
  }

  void subscribeToAlerts() {
    _alertsStream = _supabaseService.subscribeToAlerts();
    _alertsStream!.listen((alerts) {
      _alerts = alerts;
      notifyListeners();
    });
  }

  void markAsRead(String id) {
    final index = _alerts.indexWhere((a) => a.id == id);
    if (index != -1) {
      _alerts[index] = Alert(
        id: _alerts[index].id,
        cameraId: _alerts[index].cameraId,
        eventId: _alerts[index].eventId,
        message: _alerts[index].message,
        timestamp: _alerts[index].timestamp,
        isRead: true,
      );
      notifyListeners();
    }
  }
}
