import 'package:flutter/material.dart';
import '../models/alert.dart';
import '../services/supabase_service.dart';

class AlertsController extends ChangeNotifier {
  SupabaseService? _supabaseService;
  AlertsController(this._supabaseService);

  set supabaseService(SupabaseService? service) {
    _supabaseService = service;
  }

  List<AlertLog> _alerts = [];
  bool _isLoading = false;
  Stream<List<AlertLog>>? _alertsStream;

  List<AlertLog> get alerts => _alerts;
  bool get isLoading => _isLoading;

  void loadAlerts() {
    _isLoading = true;
    notifyListeners();
    _supabaseService!
        .getAlerts()
        .then((alerts) {
          _alerts = alerts;
          _isLoading = false;
          notifyListeners();
        })
        .catchError((e) {
          debugPrint('AlertsController: Error loading alerts: $e');
          _isLoading = false;
          notifyListeners();
        });
  }

  Future<List<AlertLog>> fetchAlerts() async {
    try {
      final alerts = await _supabaseService!.getAlerts();
      return alerts;
    } catch (e) {
      debugPrint('AlertsController: Error fetching alerts: $e');
      rethrow;
    }
  }

  void subscribeToAlerts() {
    _alertsStream = _supabaseService!.subscribeToAlerts();

    _alertsStream!.listen((alerts) {
      _alerts = alerts;
      notifyListeners();
    });
  }

  void clearData() {
    _alerts.clear();
    _isLoading = false;
    _alertsStream = null;
  }
}
