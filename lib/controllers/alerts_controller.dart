import 'package:flutter/material.dart';
import '../models/alert.dart';
import '../services/supabase_service.dart';

class AlertsController extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();
  List<AlertLog> _alerts = [];
  bool _isLoading = false;
  Stream<List<AlertLog>>? _alertsStream;

  List<AlertLog> get alerts => _alerts;
  bool get isLoading => _isLoading;

  void loadAlerts() {
    debugPrint('AlertsController: Loading alerts');
    _isLoading = true;
    notifyListeners();
    _supabaseService
        .getAlerts()
        .then((alerts) {
          _alerts = alerts;
          _isLoading = false;
          notifyListeners();
          debugPrint('AlertsController: Loaded ${_alerts.length} alerts');
        })
        .catchError((e) {
          debugPrint('AlertsController: Error loading alerts: $e');
          _isLoading = false;
          notifyListeners();
          // Handle error
        });
  }

  Future<List<AlertLog>> fetchAlerts() async {
    debugPrint('AlertsController: Fetching alerts');
    try {
      final alerts = await _supabaseService.getAlerts();
      debugPrint('AlertsController: Fetched ${alerts.length} alerts');
      return alerts;
    } catch (e) {
      debugPrint('AlertsController: Error fetching alerts: $e');
      rethrow;
    }
  }

  void subscribeToAlerts() {
    debugPrint('AlertsController: Subscribing to alerts');
    _alertsStream = _supabaseService.subscribeToAlerts();

    _alertsStream!.listen((alerts) {
      debugPrint(
        'AlertsController: Received ${alerts.length} alerts from stream',
      );
      _alerts = alerts;
      notifyListeners();
    });
  }

  void clearData() {
    debugPrint('AlertsController: Clearing data');
    _alerts.clear();
    _isLoading = false;
    _alertsStream = null;
    notifyListeners();
  }
}
