import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/supabase_service.dart';

class EventsController extends ChangeNotifier {
  SupabaseService? _supabaseService;
  EventsController(this._supabaseService);

  set supabaseService(SupabaseService? service) {
    _supabaseService = service;
  }

  List<Event> _events = [];
  bool _isLoading = false;

  List<Event> get events => _events;
  bool get isLoading => _isLoading;

  Future<void> loadEvents() async {
    _isLoading = true;
    notifyListeners();
    try {
      _events = await _supabaseService!.getEvents();
    } catch (e) {
      debugPrint('EventsController: Error loading events: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Event>> fetchEvents() async {
    try {
      final events = await _supabaseService!.getEvents();
      return events;
    } catch (e) {
      debugPrint('EventsController: Error fetching events: $e');
      rethrow;
    }
  }

  Future<void> addEvent(String eventDescription) async {
    try {
      final event = await _supabaseService!.addEvent(eventDescription);
      _events.add(event);
      notifyListeners();
    } catch (e) {
      debugPrint('EventsController: Error adding event: $e');
    }
  }

  Future<void> updateEvent(
    String id,
    String eventDescription,
    bool isActive,
  ) async {
    try {
      await _supabaseService!.updateEvent(id, eventDescription, isActive);
      final index = _events.indexWhere((e) => e.eventId == id);
      if (index != -1) {
        _events[index] = Event(
          eventId: id,
          eventDescription: eventDescription,
          isActive: isActive,
          createdAt: _events[index].createdAt,
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('EventsController: Error updating event: $e');
    }
  }

  Future<void> deleteEvent(String id) async {
    try {
      await _supabaseService!.deleteEvent(id);
      _events.removeWhere((e) => e.eventId == id);
      notifyListeners();
    } catch (e) {
      debugPrint('EventsController: Error deleting event: $e');
    }
  }

  void clearData() {
    _events.clear();
    _isLoading = false;
  }
}
