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

  Future<List<AlertLog>> fetchAlerts() async {
    return await _supabaseService.getAlerts();
  }

  void subscribeToAlerts() {
    _alertsStream = _supabaseService.subscribeToAlerts();
    _alertsStream!.listen((alerts) {
      _alerts = alerts;
      notifyListeners();
    });
  }
}
