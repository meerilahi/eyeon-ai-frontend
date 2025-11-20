import 'package:eyeon_ai_frontend/models/settings.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/device.dart';
import '../models/event.dart';
import '../models/alert.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;
  final User? _user;

  SupabaseService(this._user);

  String get _userId => _user?.id ?? "";

  // Devices CRUD
  Future<List<Device>> getDevices() async {
    final response = await _client
        .from('devices')
        .select('*, cameras(*)')
        .eq('user_id', _userId);
    final devices = (response as List)
        .map((json) => Device.fromJson(json))
        .toList();
    return devices;
  }

  Future<Device> addDevice({
    required String name,
    required String type,
    required String ipAddress,
    required String port,
    required String username,
    required String password,
  }) async {
    final response = await _client
        .from('devices')
        .insert({
          'name': name,
          'type': type,
          'ip_address': ipAddress,
          'port': port,
          'username': username,
          'password': password,
        })
        .select()
        .single();
    return Device.fromJson(response);
  }

  Future<void> updateDevice(Device device) async {
    await _client
        .from('devices')
        .update({
          'name': device.name,
          'type': device.type,
          'ip_address': device.ipAddress,
          'port': device.port,
          'username': device.username,
          'password': device.password,
        })
        .eq('device_id', device.deviceId);
  }

  Future<void> deleteDevice(String deviceId) async {
    await _client.from('devices').delete().eq('device_id', deviceId);
  }

  // Cameras CRUD
  Future<Camera> addCamera(String deviceId, String name, String rtspUrl) async {
    final response = await _client
        .from('cameras')
        .insert({
          'device_id': deviceId,
          'name': name,
          'rtsp_url': rtspUrl,
          'user_id': _userId,
        })
        .select()
        .single();
    return Camera.fromJson(response);
  }

  Future<void> updateCamera(
    String cameraId,
    String name,
    String rtspUrl,
  ) async {
    await _client
        .from('cameras')
        .update({'name': name, 'rtsp_url': rtspUrl})
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
        .eq("user_id", _userId);
    final events = response.map((json) => Event.fromJson(json)).toList();
    return events;
  }

  Future<Event> addEvent(String eventDescription) async {
    final response = await _client
        .from('events')
        .insert({'event_description': eventDescription, 'is_active': true})
        .select()
        .single();
    final event = Event.fromJson(response);
    return event;
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

  // Alerts CRUD
  Future<List<AlertLog>> getAlerts() async {
    final response = await _client
        .from('alerts')
        .select()
        .eq("user_id", _userId)
        .order('created_at', ascending: false);
    final alerts = response.map((json) => AlertLog.fromJson(json)).toList();
    return alerts;
  }

  Stream<List<AlertLog>> subscribeToAlerts() {
    return _client
        .from('alerts')
        .stream(primaryKey: ['alert_id'])
        .eq('user_id', _userId)
        .order('created_at')
        .map((rows) {
          final alerts = rows.map(AlertLog.fromJson).toList();
          return alerts;
        });
  }

  // -------------------------------
  // User Settings CRUD
  // -------------------------------

  Future<Settings?> getSettings() async {
    final response = await _client
        .from('settings')
        .select()
        .eq('user_id', _userId)
        .maybeSingle();

    if (response == null) return null;
    return Settings.fromJson(response);
  }

  Future<Settings> getOrCreateSettings() async {
    final existing = await getSettings();
    if (existing != null) return existing;

    final defaultSettings = Settings(
      name: "",
      email: "",
      contactNumber: "",
      alertOnCall: false,
      alertOnSms: false,
      alertOnEmail: false,
    );

    return await createSettings(defaultSettings);
  }

  Future<Settings> createSettings(Settings settings) async {
    final response = await _client
        .from('settings')
        .insert({'user_id': _userId, ...settings.toJson()})
        .select()
        .single();

    return Settings.fromJson(response);
  }

  Future<Settings> updateSettings(Settings settings) async {
    final response = await _client
        .from('settings')
        .update(settings.toJson())
        .eq('user_id', _userId)
        .select()
        .single();

    return Settings.fromJson(response);
  }

  Future<void> deleteSettings() async {
    await _client.from('settings').delete().eq('user_id', _userId);
  }
}
