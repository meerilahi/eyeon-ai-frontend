import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/camera.dart';
import '../models/event.dart';
import '../models/alert.dart';
import '../models/message.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;
  final String _user_id = Supabase.instance.client.auth.currentUser?.id ?? "";

  // Cameras CRUD
  Future<List<Camera>> getCameras() async {
    final response = await _client
        .from('cameras')
        .select()
        .eq("user_id", _user_id);
    return response.map((json) => Camera.fromJson(json)).toList();
  }

  Future<Camera> addCamera(
    String name,
    String description,
    String rtspUrl,
  ) async {
    final response = await _client
        .from('cameras')
        .insert({'name': name, 'description': description, 'rtsp_url': rtspUrl})
        .select()
        .single();
    return Camera.fromJson(response);
  }

  Future<void> updateCamera(
    String cameraId,
    String name,
    String description,
    String rtspUrl,
  ) async {
    await _client
        .from('cameras')
        .update({'name': name, 'description': description, 'rtsp_url': rtspUrl})
        .eq('camera_id', cameraId);
  }

  Future<void> deleteCamera(String cameraId) async {
    await _client.from('cameras').delete().eq('camera_id', cameraId);
  }

  // Events CRUD
  Future<List<Event>> getEvents() async {
    final response = await _client
        .from('events')
        .select()
        .eq("user_id", _user_id);
    return response.map((json) => Event.fromJson(json)).toList();
  }

  Future<Event> addEvent(String eventDescription) async {
    final response = await _client
        .from('events')
        .insert({'event_description': eventDescription, 'is_active': true})
        .select()
        .single();
    return Event.fromJson(response);
  }

  Future<void> updateEvent(
    String eventId,
    String eventDescription,
    bool isActive,
  ) async {
    await _client
        .from('events')
        .update({'event_description': eventDescription, 'is_active': isActive})
        .eq('event_id', eventId);
  }

  Future<void> deleteEvent(String eventId) async {
    await _client.from('events').delete().eq('event_id', eventId);
  }

  // Alerts
  Future<List<AlertLog>> getAlerts() async {
    final response = await _client
        .from('alerts')
        .select()
        .eq("user_id", _user_id)
        .order('created_at', ascending: false);
    return response.map((json) => AlertLog.fromJson(json)).toList();
  }

  Stream<List<AlertLog>> subscribeToAlerts() {
    return _client
        .from('alerts')
        .stream(primaryKey: ['alert_id'])
        .eq('user_id', _user_id)
        .order('created_at')
        .map((rows) {
          return rows.map(AlertLog.fromJson).toList();
        });
  }

  // Messages (optional storage)
  Future<void> saveMessage(Message message) async {
    await _client.from('messages').insert(message.toJson());
  }

  Future<List<Message>> getMessages() async {
    final response = await _client.from('messages').select().order('timestamp');
    return response.map((json) => Message.fromJson(json)).toList();
  }
}
