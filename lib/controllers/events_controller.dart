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
    debugPrint('EventsController: Loading events');
    _isLoading = true;
    notifyListeners();
    try {
      _events = await _supabaseService.getEvents();
      debugPrint('EventsController: Loaded ${_events.length} events');
    } catch (e) {
      debugPrint('EventsController: Error loading events: $e');
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Event>> fetchEvents() async {
    debugPrint('EventsController: Fetching events');
    try {
      final events = await _supabaseService.getEvents();
      debugPrint('EventsController: Fetched ${events.length} events');
      return events;
    } catch (e) {
      debugPrint('EventsController: Error fetching events: $e');
      rethrow;
    }
  }

  Future<void> addEvent(String eventDescription) async {
    debugPrint('EventsController: Adding event: $eventDescription');
    try {
      final event = await _supabaseService.addEvent(eventDescription);
      _events.add(event);
      notifyListeners();
      debugPrint('EventsController: Added event: ${event.eventId}');
    } catch (e) {
      debugPrint('EventsController: Error adding event: $e');
      // print(e);
    }
  }

  Future<void> updateEvent(
    String id,
    String eventDescription,
    bool isActive,
  ) async {
    debugPrint('EventsController: Updating event: $id');
    try {
      await _supabaseService.updateEvent(id, eventDescription, isActive);
      final index = _events.indexWhere((e) => e.eventId == id);
      if (index != -1) {
        _events[index] = Event(
          eventId: id,
          eventDescription: eventDescription,
          isActive: isActive,
          createdAt: _events[index].createdAt,
        );
        notifyListeners();
        debugPrint('EventsController: Updated event: $id');
      }
    } catch (e) {
      debugPrint('EventsController: Error updating event: $e');
      // Handle error
    }
  }

  Future<void> deleteEvent(String id) async {
    debugPrint('EventsController: Deleting event: $id');
    try {
      await _supabaseService.deleteEvent(id);
      _events.removeWhere((e) => e.eventId == id);
      notifyListeners();
      debugPrint('EventsController: Deleted event: $id');
    } catch (e) {
      debugPrint('EventsController: Error deleting event: $e');
      // Handle error
    }
  }

  void clearData() {
    debugPrint('EventsController: Clearing data');
    _events.clear();
    _isLoading = false;
    notifyListeners();
  }
}
