import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/supabase_service.dart';

class EventsController extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();
  List<Event> _events = [];
  bool _isLoading = false;

  List<Event> get events => _events;
  bool get isLoading => _isLoading;

  Future<void> loadEvents() async {
    _isLoading = true;
    notifyListeners();
    try {
      _events = await _supabaseService.getEvents();
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addEvent(String name, String description) async {
    try {
      final event = await _supabaseService.addEvent(name, description);
      _events.add(event);
      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> updateEvent(
    String id,
    String name,
    String description,
    bool isActive,
  ) async {
    try {
      await _supabaseService.updateEvent(id, name, description, isActive);
      final index = _events.indexWhere((e) => e.id == id);
      if (index != -1) {
        _events[index] = Event(
          id: id,
          name: name,
          description: description,
          isActive: isActive,
          createdAt: _events[index].createdAt,
        );
        notifyListeners();
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> deleteEvent(String id) async {
    try {
      await _supabaseService.deleteEvent(id);
      _events.removeWhere((e) => e.id == id);
      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }
}
