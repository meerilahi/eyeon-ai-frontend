import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/camera.dart';
import '../models/event.dart';
import '../models/alert.dart';
import '../models/message.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;
  final User? _user;

  SupabaseService(this._user);

  String get _userId => _user?.id ?? "";

  // Cameras CRUD
  Future<List<Camera>> getCameras() async {
    debugPrint('SupabaseService: Fetching cameras for user: $_userId');
    final response = await _client
        .from('cameras')
        .select()
        .eq("user_id", _userId);
    final cameras = response.map((json) => Camera.fromJson(json)).toList();
    debugPrint('SupabaseService: Fetched ${cameras.length} cameras');
    return cameras;
  }

  Future<Camera> addCamera(
    String name,
    String description,
    String rtspUrl,
  ) async {
    debugPrint('SupabaseService: Adding camera: $name');
    final response = await _client
        .from('cameras')
        .insert({'name': name, 'description': description, 'rtsp_url': rtspUrl})
        .select()
        .single();
    final camera = Camera.fromJson(response);
    debugPrint('SupabaseService: Added camera: ${camera.cameraId}');
    return camera;
  }

  Future<void> updateCamera(
    String cameraId,
    String name,
    String description,
    String rtspUrl,
  ) async {
    debugPrint('SupabaseService: Updating camera: $cameraId');
    await _client
        .from('cameras')
        .update({'name': name, 'description': description, 'rtsp_url': rtspUrl})
        .eq('camera_id', cameraId);
    debugPrint('SupabaseService: Updated camera: $cameraId');
  }

  Future<void> deleteCamera(String cameraId) async {
    debugPrint('SupabaseService: Deleting camera: $cameraId');
    await _client.from('cameras').delete().eq('camera_id', cameraId);
    debugPrint('SupabaseService: Deleted camera: $cameraId');
  }

  // Events CRUD
  Future<List<Event>> getEvents() async {
    debugPrint('SupabaseService: Fetching events for user: $_userId');
    final response = await _client
        .from('events')
        .select()
        .eq("user_id", _userId);
    final events = response.map((json) => Event.fromJson(json)).toList();
    debugPrint('SupabaseService: Fetched ${events.length} events');
    return events;
  }

  Future<Event> addEvent(String eventDescription) async {
    debugPrint('SupabaseService: Adding event: $eventDescription');
    final response = await _client
        .from('events')
        .insert({'event_description': eventDescription, 'is_active': true})
        .select()
        .single();
    final event = Event.fromJson(response);
    debugPrint('SupabaseService: Added event: ${event.eventId}');
    return event;
  }

  Future<void> updateEvent(
    String eventId,
    String eventDescription,
    bool isActive,
  ) async {
    debugPrint('SupabaseService: Updating event: $eventId');
    await _client
        .from('events')
        .update({'event_description': eventDescription, 'is_active': isActive})
        .eq('event_id', eventId);
    debugPrint('SupabaseService: Updated event: $eventId');
  }

  Future<void> deleteEvent(String eventId) async {
    debugPrint('SupabaseService: Deleting event: $eventId');
    await _client.from('events').delete().eq('event_id', eventId);
    debugPrint('SupabaseService: Deleted event: $eventId');
  }

  // Alerts
  Future<List<AlertLog>> getAlerts() async {
    debugPrint('SupabaseService: Fetching alerts for user: $_userId');
    final response = await _client
        .from('alerts')
        .select()
        .eq("user_id", _userId)
        .order('created_at', ascending: false);
    final alerts = response.map((json) => AlertLog.fromJson(json)).toList();
    debugPrint('SupabaseService: Fetched ${alerts.length} alerts');
    return alerts;
  }

  Stream<List<AlertLog>> subscribeToAlerts() {
    debugPrint('SupabaseService: Subscribing to alerts for user: $_userId');
    return _client
        .from('alerts')
        .stream(primaryKey: ['alert_id'])
        .eq('user_id', _userId)
        .order('created_at')
        .map((rows) {
          final alerts = rows.map(AlertLog.fromJson).toList();
          debugPrint(
            'SupabaseService: Stream received ${alerts.length} alerts',
          );
          return alerts;
        });
  }
}
