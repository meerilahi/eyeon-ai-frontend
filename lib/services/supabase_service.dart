import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/camera.dart';
import '../models/event.dart';
import '../models/alert.dart';
import '../models/message.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // Cameras CRUD
  Future<List<Camera>> getCameras() async {
    final response = await _client.from('cameras').select();
    return response.map((json) => Camera.fromJson(json)).toList();
  }

  Future<Camera> addCamera(String name, String rtspUrl) async {
    final response = await _client
        .from('cameras')
        .insert({'name': name, 'rtsp_url': rtspUrl})
        .select()
        .single();
    return Camera.fromJson(response);
  }

  Future<void> updateCamera(String id, String name, String rtspUrl) async {
    await _client
        .from('cameras')
        .update({'name': name, 'rtsp_url': rtspUrl})
        .eq('id', id);
  }

  Future<void> deleteCamera(String id) async {
    await _client.from('cameras').delete().eq('id', id);
  }

  // Events CRUD
  Future<List<Event>> getEvents() async {
    final response = await _client.from('events').select();
    return response.map((json) => Event.fromJson(json)).toList();
  }

  Future<Event> addEvent(String name, String description) async {
    final response = await _client
        .from('events')
        .insert({'name': name, 'description': description, 'is_active': true})
        .select()
        .single();
    return Event.fromJson(response);
  }

  Future<void> updateEvent(
    String id,
    String name,
    String description,
    bool isActive,
  ) async {
    await _client
        .from('events')
        .update({
          'name': name,
          'description': description,
          'is_active': isActive,
        })
        .eq('id', id);
  }

  Future<void> deleteEvent(String id) async {
    await _client.from('events').delete().eq('id', id);
  }

  // Alerts
  Future<List<Alert>> getAlerts() async {
    final response = await _client
        .from('alerts')
        .select()
        .order('timestamp', ascending: false);
    return response.map((json) => Alert.fromJson(json)).toList();
  }

  Stream<List<Alert>> subscribeToAlerts() {
    return _client
        .from('alerts')
        .stream(primaryKey: ['id'])
        .map((data) => data.map((json) => Alert.fromJson(json)).toList());
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
