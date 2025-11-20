import 'package:flutter/material.dart';
import '../models/settings.dart';
import '../services/supabase_service.dart';

class SettingsController extends ChangeNotifier {
  SupabaseService? _supabaseService;
  SettingsController(this._supabaseService);

  set supabaseService(SupabaseService? service) {
    _supabaseService = service;
  }

  Settings? _settings;
  bool _isLoading = false;

  Settings? get settings => _settings;
  bool get isLoading => _isLoading;

  // -------------------------------
  // Load Settings
  // -------------------------------
  Future<void> loadSettings() async {
    _isLoading = true;
    notifyListeners();

    try {
      _settings = await _supabaseService!.getSettings();
    } catch (e) {
      debugPrint("SettingsController: Error loading settings: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // -------------------------------
  // Create Settings
  // -------------------------------
  Future<void> createSettings(Settings newSettings) async {
    try {
      final created = await _supabaseService!.createSettings(newSettings);
      _settings = created;
      notifyListeners();
    } catch (e) {
      debugPrint("SettingsController: Error creating settings: $e");
    }
  }

  // -------------------------------
  // Update Settings
  // -------------------------------
  Future<void> updateSettings(Settings updated) async {
    try {
      final newData = await _supabaseService!.updateSettings(updated);
      _settings = newData;
      notifyListeners();
    } catch (e) {
      debugPrint("SettingsController: Error updating settings: $e");
    }
  }

  // -------------------------------
  // Delete Settings
  // -------------------------------
  Future<void> deleteSettings() async {
    try {
      await _supabaseService!.deleteSettings();
      _settings = null;
      notifyListeners();
    } catch (e) {
      debugPrint("SettingsController: Error deleting settings: $e");
    }
  }

  // -------------------------------
  // Clear local state (on logout)
  // -------------------------------
  void clearData() {
    _settings = null;
    _isLoading = false;
  }
}
